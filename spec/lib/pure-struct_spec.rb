require 'spec_helper'

RSpec.describe Struct do
  before(:all) do
    @ruby_engine = RUBY_ENGINE
    load File.expand_path(File.join(__dir__, '..', '..', 'lib/pure-struct.rb'))
  end
  
  after do
    RUBY_ENGINE = @ruby_engine unless RUBY_ENGINE == @ruby_engine
  end

  let(:full_name) {'Sean Hux'}
  let(:age) {48}
  
  context 'keyword_init: true' do
    it 'builds a new anonymous class, can set/get attributes, and provide equality methods' do
      struct = Struct.new(:full_name, :age, keyword_init: true)
      expect(struct.name).to be_nil
      expect(struct.inspect).to eq("#{struct.send(:__inspect__)}(keyword_init: true)")
      
      object = struct.new(full_name: full_name, age: age)
      expect(object).to be_a(struct)
      expect(object).to be_a(Struct)
      expect(object).to be_a(Enumerable)
      
      # getters
      expect(object.full_name).to eq(full_name)
      expect(object[:full_name]).to eq(full_name)
      expect(object['full_name']).to eq(full_name)
      
      expect(object.age).to eq(age)
      expect(object[:age]).to eq(age)
      expect(object['age']).to eq(age)
      
      expect(object.members).to eq([:full_name, :age])
      expect(object.each_pair).to be_a(Enumerator)
      expect(object.each_pair.to_a).to eq([[:full_name, full_name], [:age, age]])
      expect(object.each).to be_a(Enumerator)
      expect(object.each.to_a).to eq([full_name, age])
      expect(object.select {|value| value.is_a?(Integer)}).to eq([age])
      expect(object.to_h).to eq(full_name: full_name, age: age)
      expect(object.to_a).to eq([full_name, age])
      expect(object.to_s).to eq('#<struct full_name="Sean Hux", age=48>')
      expect(object.inspect).to eq(object.to_s)
      expect(object.size).to eq(2)
      expect(object.length).to eq(2)

      # setters
      
      object.full_name = 'Shaw Gibbins'
      expect(object.full_name).to eq('Shaw Gibbins')
      expect(object['full_name']).to eq('Shaw Gibbins')
      expect(object[:full_name]).to eq('Shaw Gibbins')
      
      object[:full_name] = 'Andy Griffith'
      expect(object.full_name).to eq('Andy Griffith')
      expect(object['full_name']).to eq('Andy Griffith')
      expect(object[:full_name]).to eq('Andy Griffith')
      
      object['full_name'] = 'Bob Macintosh'
      expect(object.full_name).to eq('Bob Macintosh')
      expect(object['full_name']).to eq('Bob Macintosh')
      expect(object[:full_name]).to eq('Bob Macintosh')
      
      object['full_name'] = {first_name: 'Bob', last_name: 'Macintosh'}
      expect(object.dig(:full_name, :first_name)).to eq('Bob')
      
      # equals
      object.full_name = full_name
      object2 = struct.new(full_name: full_name, age: age)
      expect(object2.equal?(object)).to eq(false)
      expect(object2.eql?(object)).to eq(true)
      expect(object2 == object).to eq(true)
      expect(object2.hash).to eq(object.hash)
      
      # detect cycle
      object.full_name = object
      expect(object.to_s).to eq("#<struct full_name=#<struct #{struct.send(:__inspect__)}:...>, age=48>")
      expect(object).to eq(object)
      expect(object).to eql(object)
      expect(object.hash).to eq(object.full_name.hash)
      expect(object.hash).to be_a(Integer)
    end
        
    it 'builds a new named class with string class name, can set/get attributes, and provide equality methods' do
      struct = Struct.new('PersonStruct', :full_name, :age, keyword_init: true)
      expect(struct).to eq(Struct::PersonStruct)
      expect(Struct::PersonStruct.name).to eq('Struct::PersonStruct')
      expect(Struct::PersonStruct.inspect).to eq("Struct::PersonStruct(keyword_init: true)")
      
      object = Struct::PersonStruct.new(full_name: full_name, age: age)
      
      # getters
      expect(object.full_name).to eq(full_name)
      expect(object[:full_name]).to eq(full_name)
      expect(object['full_name']).to eq(full_name)
      
      expect(object.age).to eq(age)
      expect(object[:age]).to eq(age)
      expect(object['age']).to eq(age)
      
      expect(object.members).to eq([:full_name, :age])
      expect(object.each_pair).to be_a(Enumerator)
      expect(object.each_pair.to_a).to eq([[:full_name, full_name], [:age, age]])
      expect(object.each).to be_a(Enumerator)
      expect(object.each.to_a).to eq([full_name, age])
      expect(object.select {|value| value.is_a?(Integer)}).to eq([age])
      expect(object.to_h).to eq(full_name: full_name, age: age)
      expect(object.to_a).to eq([full_name, age])
      expect(object.to_s).to eq('#<struct Struct::PersonStruct full_name="Sean Hux", age=48>')
      expect(object.inspect).to eq(object.to_s)
      expect(object.size).to eq(2)
      expect(object.length).to eq(2)
      
      # setters
      
      object.full_name = 'Shaw Gibbins'
      expect(object.full_name).to eq('Shaw Gibbins')
      expect(object['full_name']).to eq('Shaw Gibbins')
      expect(object[:full_name]).to eq('Shaw Gibbins')
      
      object[:full_name] = 'Andy Griffith'
      expect(object.full_name).to eq('Andy Griffith')
      expect(object['full_name']).to eq('Andy Griffith')
      expect(object[:full_name]).to eq('Andy Griffith')
      
      object['full_name'] = 'Bob Macintosh'
      expect(object.full_name).to eq('Bob Macintosh')
      expect(object['full_name']).to eq('Bob Macintosh')
      expect(object[:full_name]).to eq('Bob Macintosh')
      
      object['full_name'] = {first_name: 'Bob', last_name: 'Macintosh'}
      expect(object.dig(:full_name, :first_name)).to eq('Bob')
      
      # equals
      object.full_name = full_name
      object2 = struct.new(full_name: full_name, age: age)
      expect(object2.equal?(object)).to eq(false)
      expect(object2.eql?(object)).to eq(true)
      expect(object2 == object).to eq(true)
      expect(object2.hash).to eq(object.hash)
      
      # detect cycle
      object.full_name = object
      expect(object.to_s).to eq("#<struct Struct::PersonStruct full_name=#<struct #{struct.send(:__inspect__)}:...>, age=48>")
      expect(object).to eq(object)
      expect(object).to eql(object)
      expect(object.hash).to eq(object.full_name.hash)
      expect(object.hash).to be_a(Integer)
    end
    
    it 'raises error if class name does not start with capital letter' do
      expect {
        Struct.new('personStruct', :full_name, :age, keyword_init: true)
      }.to raise_error(NameError, 'identifier name needs to be constant')
    end
    
    it 'does not raise error in Opal if class name does not start with capital letter, yet treats as an attribute instead (since Opal does not distinguish String from Symbol)' do
      RUBY_ENGINE = 'opal'
      
      expect {
        Struct.new('PersonStruct', :full_name, :age, keyword_init: true)
      }.to_not raise_error
      object1 = Struct::PersonStruct.new(full_name: 'full name value', age: 48)
      expect(object1.members).to eq([:full_name, :age])
      expect(object1.hash).to be_a(String)
      expect(object1.to_s).to eq("#<struct Struct::PersonStruct full_name=\"full name value\", age=48>")
      expect(object1.inspect).to eq(object1.to_s)
            
      struct = nil
      expect {
        struct = Struct.new('personStruct', :full_name, :age, keyword_init: true)
      }.to_not raise_error
      object = struct.new(personStruct: 'person struct value', full_name: 'full name value', age: 48)
      expect(object.members).to eq([:personStruct, :full_name, :age])
      expect(object.hash).to be_a(String)
      expect(object.to_s).to eq("#<struct personStruct=\"person struct value\", full_name=\"full name value\", age=48>")
      expect(object.inspect).to eq(object.to_s)
      
      # nil member
      object.full_name = nil
      expect(object.to_s).to eq("#<struct personStruct=\"person struct value\", full_name=nil, age=48>")
      
      # detect cycle
      object.full_name = object
      expect(object.to_s).to eq("#<struct personStruct=\"person struct value\", full_name=#<struct #{struct.send(:__inspect__)}:...>, age=48>")
      expect(object).to eq(object)
      expect(object).to eql(object)
      expect(object.hash).to eq(object.full_name.hash)
      expect(object.hash).to be_a(String)
    end
    
    it 'raises error if no attributes are passed in' do
      expect {Struct.new}.to raise_error(ArgumentError)
    end
    
    it 'raises error if an attribute is nil' do
      expect {Struct.new(nil)}.to raise_error('Arguments cannot be nil')
      expect {Struct.new(:name, nil, 'age')}.to raise_error('Arguments cannot be nil')
    end
    
    it 'modifying members array causes no changes' do
      struct = Struct.new('PersonStruct', :full_name, :age, keyword_init: true)
      object = Struct::PersonStruct.new(full_name: full_name, age: age)
      expect(object.members).to eq([:full_name, :age])
      object.members.shift
      expect(object.members).to eq([:full_name, :age])
      object.members.pop
      expect(object.members).to eq([:full_name, :age])
      object.members.push(:address)
      expect(object.members).to eq([:full_name, :age])
    end
  end
  
  context 'keyword_init: false' do
    it 'builds a new anonymous class, can set/get attributes, and provide equality methods' do
      struct = Struct.new(:full_name, 'age')
      expect(struct.name).to be_nil
      expect(struct.inspect).to eq("#{struct.send(:__inspect__)}")
      
      object = struct.new(full_name, age)
      
      # getters
      expect(object.full_name).to eq(full_name)
      expect(object[:full_name]).to eq(full_name)
      expect(object['full_name']).to eq(full_name)
      
      expect(object.age).to eq(age)
      expect(object[:age]).to eq(age)
      expect(object['age']).to eq(age)
      
      expect(object.members).to eq([:full_name, :age])
      expect(object.each_pair).to be_a(Enumerator)
      expect(object.each_pair.to_a).to eq([[:full_name, full_name], [:age, age]])
      expect(object.each).to be_a(Enumerator)
      expect(object.each.to_a).to eq([full_name, age])
      expect(object.select {|value| value.is_a?(Integer)}).to eq([age])
      expect(object.to_h).to eq(full_name: full_name, age: age)
      expect(object.to_a).to eq([full_name, age])
      expect(object.to_s).to eq('#<struct full_name="Sean Hux", age=48>')
      expect(object.inspect).to eq(object.to_s)
      expect(object.size).to eq(2)
      expect(object.length).to eq(2)
      
      # setters
      
      object.full_name = 'Shaw Gibbins'
      expect(object.full_name).to eq('Shaw Gibbins')
      expect(object['full_name']).to eq('Shaw Gibbins')
      expect(object[:full_name]).to eq('Shaw Gibbins')
      
      object[:full_name] = 'Andy Griffith'
      expect(object.full_name).to eq('Andy Griffith')
      expect(object['full_name']).to eq('Andy Griffith')
      expect(object[:full_name]).to eq('Andy Griffith')
      
      object['full_name'] = 'Bob Macintosh'
      expect(object.full_name).to eq('Bob Macintosh')
      expect(object['full_name']).to eq('Bob Macintosh')
      expect(object[:full_name]).to eq('Bob Macintosh')
      
      object['full_name'] = {first_name: 'Bob', last_name: 'Macintosh'}
      expect(object.dig(:full_name, :first_name)).to eq('Bob')
      
      # equals
      object.full_name = full_name
      object2 = struct.new(full_name, age)
      expect(object2.equal?(object)).to eq(false)
      expect(object2.eql?(object)).to eq(true)
      expect(object2 == object).to eq(true)
      expect(object2.hash).to eq(object.hash)
      
      # detect cycle
      object.full_name = object
      expect(object.to_s).to eq("#<struct full_name=#<struct #{struct.send(:__inspect__)}:...>, age=48>")
      expect(object).to eq(object)
      expect(object).to eql(object)
      expect(object.hash).to eq(object.full_name.hash)
      expect(object.hash).to be_a(Integer)
    end
    
    it 'builds a new named class with string class name, can set/get attributes, and provide equality methods' do
      struct = Struct.new('PersonStruct', :full_name, :age, keyword_init: false)
      expect(struct).to eq(Struct::PersonStruct)
      expect(Struct::PersonStruct.name).to eq('Struct::PersonStruct')
      expect(Struct::PersonStruct.inspect).to eq("Struct::PersonStruct")
      
      object = Struct::PersonStruct.new(full_name, age)
      
      # getters
      expect(object.full_name).to eq(full_name)
      expect(object[:full_name]).to eq(full_name)
      expect(object['full_name']).to eq(full_name)
      
      expect(object.age).to eq(age)
      expect(object[:age]).to eq(age)
      expect(object['age']).to eq(age)
      
      expect(object.members).to eq([:full_name, :age])
      expect(object.each_pair).to be_a(Enumerator)
      expect(object.each_pair.to_a).to eq([[:full_name, full_name], [:age, age]])
      expect(object.each).to be_a(Enumerator)
      expect(object.each.to_a).to eq([full_name, age])
      expect(object.select {|value| value.is_a?(Integer)}).to eq([age])
      expect(object.to_h).to eq(full_name: full_name, age: age)
      expect(object.to_a).to eq([full_name, age])
      expect(object.to_s).to eq('#<struct Struct::PersonStruct full_name="Sean Hux", age=48>')
      expect(object.inspect).to eq(object.to_s)
      expect(object.size).to eq(2)
      expect(object.length).to eq(2)
      
      # setters
      
      object.full_name = 'Shaw Gibbins'
      expect(object.full_name).to eq('Shaw Gibbins')
      expect(object['full_name']).to eq('Shaw Gibbins')
      expect(object[:full_name]).to eq('Shaw Gibbins')
      
      object[:full_name] = 'Andy Griffith'
      expect(object.full_name).to eq('Andy Griffith')
      expect(object['full_name']).to eq('Andy Griffith')
      expect(object[:full_name]).to eq('Andy Griffith')
      
      object['full_name'] = 'Bob Macintosh'
      expect(object.full_name).to eq('Bob Macintosh')
      expect(object['full_name']).to eq('Bob Macintosh')
      expect(object[:full_name]).to eq('Bob Macintosh')
      
      object['full_name'] = {first_name: 'Bob', last_name: 'Macintosh'}
      expect(object.dig(:full_name, :first_name)).to eq('Bob')
      
      # equals
      object.full_name = full_name
      object2 = struct.new(full_name, age)
      expect(object2.equal?(object)).to eq(false)
      expect(object2.eql?(object)).to eq(true)
      expect(object2 == object).to eq(true)
      expect(object2.hash).to eq(object.hash)
      
      # detect cycle
      object.full_name = object
      expect(object.to_s).to eq("#<struct Struct::PersonStruct full_name=#<struct #{struct.send(:__inspect__)}:...>, age=48>")
      expect(object).to eq(object)
      expect(object).to eql(object)
      expect(object.hash).to eq(object.full_name.hash)
      expect(object.hash).to be_a(Integer)
    end
  end
end
