# Change Log

## 1.0.2

- Ensure StructClass.inspect shows `(keyword_init: true)` (e.g. `Person(keyword_init: true) `)
- Implement to_s (e.g. `#<struct Person full_name=nil, age=nil>` for `Person` class )
- Fix issue with ability to handle cycles in to_s/inspect implementation (printing #<struct #<Class:0x00007ff874073590>:...> when self object is encountered within attributes)
- Fix issue with ability to handle cycles in hash implementation, including Opal
- Fix issue with ability to handle cycles in equality
- Fix issue with ability to handle cycles in equivalence

## 1.0.1

- Include `Enumerable` just as in native `Struct`
- Fix issue with `Struct.new` first attribute interpreted as a class name due to Opal implementing Symbols as Strings
- Fix issue with String#hash implementation in Opal returning a String instead of an Integer

## 1.0.0

- Pure Ruby re-implementation of Struct
