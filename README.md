# Pure Struct
[![Gem Version](https://badge.fury.io/rb/pure-struct.svg)](http://badge.fury.io/rb/pure-struct)
[![rspec](https://github.com/AndyObtiva/pure-struct/workflows/rspec/badge.svg)](https://github.com/AndyObtiva/pure-struct/actions?query=workflow%3Arspec)
[![Coverage Status](https://coveralls.io/repos/github/AndyObtiva/pure-struct/badge.svg?branch=master)](https://coveralls.io/github/AndyObtiva/pure-struct?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/2659b419fd5f7d38e443/maintainability)](https://codeclimate.com/github/AndyObtiva/pure-struct/maintainability)

Pure [Ruby](https://www.ruby-lang.org/) re-implementation of [Struct](https://ruby-doc.org/core-2.7.0/Struct.html) to ensure cross-Ruby functionality where needed (e.g. [Opal](https://opalrb.com/))

It is useful when:
- There is a need for a Struct class that works consistently across esoteric implementations of [Ruby](https://www.ruby-lang.org/) like [Opal](https://opalrb.com/). This is useful when writing cross-[Ruby](https://www.ruby-lang.org/) apps like those of [Glimmer](https://github.com/AndyObtiva/glimmer) relying on [YASL](https://github.com/AndyObtiva/yasl) (Yet Another Serialization Library) in [Opal](https://opalrb.com/).
- There is a need to meta-program Struct's data
- There are no big performance requirements that demand native [Struct](https://ruby-doc.org/core-2.7.0/Struct.html)

In all other cases, stick to native [Ruby Struct](https://ruby-doc.org/core-2.7.0/Struct.html) instead since it's optimized for performance.

## Usage Instructions

Run:

`gem install pure-struct`

Or add to [Gemfile](https://bundler.io/man/gemfile.5.html):

```ruby
gem 'pure-struct', '~> 1.0.0'
```

And, run:

`bundle`

Finally, require in [Ruby](https://www.ruby-lang.org/) code:

```ruby
require 'pure-struct'
```

Note that it removes the native `Struct` implementation first, aliasing as `NativeStruct` should you still need it, and then redefining `Struct` in pure [Ruby](https://www.ruby-lang.org/).

Optionally, you may code block the require statement by a specific [Ruby](https://www.ruby-lang.org/) engine like [Opal](https://opalrb.com/):

```
if RUBY_ENGINE == 'opal'
  require 'pure-struct'
end
```

## Contributing to pure-struct

-   Check out the latest master to make sure the feature hasn't been
    implemented or the bug hasn't been fixed yet.
-   Check out the issue tracker to make sure someone already hasn't
    requested it and/or contributed it.
-   Fork the project.
-   Start a feature/bugfix branch.
-   Commit and push until you are happy with your contribution.
-   Make sure to add tests for it. This is important so I don't break it
    in a future version unintentionally.
-   Please try not to mess with the Rakefile, version, or history. If
    you want to have your own version, or is otherwise necessary, that
    is fine, but please isolate to its own commit so I can cherry-pick
    around it.

## Software Process

[Glimmer Process](https://github.com/AndyObtiva/glimmer/blob/master/PROCESS.md)

## TODO

[TODO.md](TODO.md)

## Change Log

[CHANGELOG.md](CHANGELOG.md)

## Copyright

[MIT](LICENSE.txt)

Copyright (c) 2021 Andy Maleh.
