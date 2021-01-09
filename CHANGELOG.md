# Change Log

## 1.0.1

- Include `Enumerable` just as in native `Struct`
- Fix issue with `Struct.new` first attribute interpreted as a class name due to Opal implementing Symbols as Strings
- Fix issue with String#hash implementation in Opal returning a String instead of an Integer

## 1.0.0

- Pure Ruby re-implementation of Struct
