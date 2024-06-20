# Yard2Rbs

Convert YARD documentation in Ruby files into RBS type definitions.

Utilizes `prism` Ruby parser to parse files and validates resulting RBS files.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add yard2rbs

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install yard2rbs

## Usage

Convert all files:

```
yard2rbs **/*.rb
```

Convert specific files:

```
yard2rbs app/models/user.rb app/services/user_creator.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KieranP/yard2rbs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
