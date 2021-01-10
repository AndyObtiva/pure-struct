# Copyright (c) 2021 Andy maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Native Ruby built-in Struct implementation aliased as NativeStruct (with Struct pointing to the new pure Ruby implementation)
NativeStruct = Struct
Object.send(:remove_const, :Struct) if Object.constants.include?(:Struct)

# Pure Ruby re-implementation of Struct to ensure cross-Ruby functionality where needed (e.g. Opal)
#
# Struct class object instances store members in @members Array and member values in @member_values Hash
#
# API perfectly matches that of Native Ruby built-in Struct.
#
# Native Ruby built-in Struct implementation is aliased as NativeStruct
class Struct
  include Enumerable

  class << self
    alias __new__ new
    send(:private, :__new__)
    
    def new(class_name_or_attribute, *attributes, keyword_init: false)
      raise 'Arguments cannot be nil' if ARG_VALIDATION[class_name_or_attribute, *attributes]
      class_name = CLASS_NAME_EXTRACTION[class_name_or_attribute]
      attributes.unshift(class_name_or_attribute) if class_name.nil?
      attributes = attributes.map(&:to_sym)
      struct_class = Class.new(self, &CLASS_DEFINITION_FOR_ATTRIBUTES[attributes, keyword_init])
      class_name.nil? ? struct_class : const_set(class_name, struct_class)
    end
    
    private
    
    CLASS_DEFINITION_FOR_ATTRIBUTES = lambda do |attributes, keyword_init|
      lambda do |defined_class|
        defined_class.class_variable_set(:@@attributes, attributes)
        defined_class.class_variable_set(:@@keyword_init, keyword_init)
        
        defined_class.singleton_class.define_method(:new) {|*args, &block| __new__(*args, &block)}
        defined_class.singleton_class.alias_method(:__inspect__, :inspect)
        defined_class.private_class_method :__inspect__
        
        defined_class.singleton_class.define_method(:inspect) do
          "#{__inspect__}#{'(keyword_init: true)' if keyword_init}"
        end
              
        attributes.each do |attribute|
          define_method(attribute) do
            self[attribute]
          end
          define_method("#{attribute}=") do |value|
            self[attribute] = value
          end
        end
      
        if keyword_init
          def initialize(struct_class_keyword_args = {})
            members
            @member_values = {}
            struct_class_keyword_args.each do |attribute, value|
              self[attribute] = value
            end
          end
        else
          def initialize(*attribute_values)
            members
            @member_values = {}
            attribute_values.each_with_index do |value, i|
              attribute = @members[i]
              self[attribute] = value
            end
          end
        end
                
      end
      
    end
    
    ARG_VALIDATION = lambda do |class_name_or_attribute, *attributes|
      class_name_or_attribute.nil? || attributes.any?(&:nil?)
    end
    
    CLASS_NAME_EXTRACTION = lambda do |class_name_or_attribute|
      if class_name_or_attribute.is_a?(String) && (RUBY_ENGINE != 'opal' || class_name_or_attribute.match(/^[A-Z]/))
        raise NameError, "identifier name needs to be constant" if RUBY_ENGINE != 'opal' && !class_name_or_attribute.match(/^[A-Z]/)
        class_name_or_attribute
      end
    end
  
  end

  # Returns member symbols (strings in Opal) representing Struct attribute names
  def members
    (@members ||= self.class.class_variable_get(:@@attributes)).clone
  end
          
  def []=(attribute, value)
    normalized_attribute = attribute.to_sym
    raise NameError, "no member #{attribute} in struct" unless @members.include?(normalized_attribute)
    @member_values[normalized_attribute] = value
  end
  
  def [](attribute)
    normalized_attribute = attribute.to_sym
    raise NameError, "no member #{attribute} in struct" unless @members.include?(normalized_attribute)
    @member_values[normalized_attribute]
  end
  
  # Iterates through each value
  def each(&block)
    to_a.each(&block)
  end
  
  # Iterates through each member value pair
  def each_pair(&block)
    @member_values.each_pair(&block)
  end
  
  # Returns member values Hash (includes member keys)
  def to_h
    @member_values.clone
  end
  
  # Returns values Array (no member keys)
  def to_a
    @member_values.values
  end
  
  # Original Object #inspect implementation
  alias __inspect__ inspect
  send(:private, :__inspect__)
  
  # Prints Struct member values including class name if set
  #
  # #inspect does the same thing
  #
  # __inspect__ aliases the original Object inspect implementation
  def to_s
    member_values_string = @member_values.map do |member, value|
      if value.equal?(self)
        value_class_string = self.class.send(:__inspect__).split.first
        value_string = "#<struct #{value_class_string}:...>"
      else
        value_string = value.inspect
      end
      "#{member}=#{value_string}"
    end.join(', ')
    class_name_string = "#{self.class.name} " unless self.class.name.nil?
    "#<struct #{class_name_string}#{member_values_string}>"
  end
  alias inspect to_s
  
  def size
    @members.size
  end
  alias length size
  
  def dig(*args)
    @member_values.dig(*args)
  end
  
  # Selects values with block (only value is passed in as block arg)
  def select(&block)
    to_a.select(&block)
  end
  
  def eql?(other)
    instance_of?(other.class) &&
      @members.all? { |key| (self[key].equal?(self) && other[key].equal?(self)) || self[key].eql?(other[key]) }
  end
  
  def ==(other)
    other = coerce(other).first if respond_to?(:coerce, true)
    other.kind_of?(self.class) &&
      @members.all? { |key| (self[key].equal?(self) && other[key].equal?(self)) || self[key] == other[key] }
  end
  
  # Return compound hash value consisting of Struct class hash and all indexed value hashes
  #
  # Opal doesn't implement hash as Integer everywhere, returning strings as themselves,
  # so this returns a String in Opal as a safe common denominator for all object types.
  def hash
    return __hash__opal__ if RUBY_ENGINE == 'opal'
    class_hash = self.class.hash
    indexed_values = to_a.each_with_index
    value_hashes = indexed_values.map do |value, i|
      value_hash = value.equal?(self) ? class_hash : value.hash
      i+1 * value_hash
    end
    class_hash + value_hashes.sum
  end

  private
  
  def __hash__opal__
    class_hash = self.class.hash
    indexed_values = to_a.each_with_index
    class_hash = class_hash.to_s
    value_hashes = indexed_values.map do |value, i|
      value_hash_string = value.equal?(self) ? class_hash : value.hash.to_s
      (i+1).to_s + value_hash_string
    end
    class_hash + value_hashes.reduce(:+)
  end
  
end
