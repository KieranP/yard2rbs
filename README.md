# Yard2Rbs

Convert YARD documentation in Ruby files into compatible RBS type definitions.

## Motivation

Ruby has an official way to declare static types, RBS (https://github.com/ruby/rbs). However, what I consider to be its biggest flaw is that it requires a software engineer to remember to update the type signatures in a separate RBS file each time they change the implementation in the RB file. This could easily result in the signatures and implementation diverging over time.

RBS has a competing static type declartion/validation tool called Sorbet (https://sorbet.org/) ans its format RBI. However, specifying types requires making method calls, which increases start up time and memory usage (albeit usually tiny compared to the rest of the app). And I've also personally never had much success in getting it to function properly on a large existing codebase.

Before RBS and Sorbet were created, YARD (https://yardoc.org/) defined a way to specify the params and return types of Ruby classes, methods, and variables using special tags in comments (similar to JSDoc). YARDs primary use was as a documentation generator, able to create readable API documentation for libraries/rubygems. To my knowledge, no static type analysis tools have been created for YARD.

This project was created to bridge the gap between YARD and RBS. It allows us to document our static types using YARD syntax alongside the implementation, reducing the risk of signature/implementation disconnect. Being comments, they also add negligable start up time, and no runtime cost. Using yard2rbs, we parse through the supplied Ruby files (using the `prism` parser), convert any YARD declarations into compatible RBS syntax, validate the result, and save it into a sig/ directory. We can then use a tool like Steep (https://github.com/soutaro/steep) do the static analysis.

## Requirements

This project requires Ruby 3.1 or newer in order to execute properly. However, it is capable of parsing and converting Ruby files that run on older Ruby versions (has been tested with a large codebase designed for Ruby 2.7).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add yard2rbs

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install yard2rbs

## Usage

### yard2rbs convert [files]

Convert specified files RBS

```
yard2rbs convert app/models/user.rb app/services/user_creator.rb

yard2rbs convert lib/**/*.rb
```

### yard2rbs watch [dirs]

Watch specified directories for changes to Ruby filea and convert to RBS.

```
yard2rbs watch lib/
```

## Contributing

Want to contribute? The project needs more specs to find and cover gaps in either the YARD parser or the RBS construction.

Bug reports and pull requests are welcome on GitHub at https://github.com/KieranP/yard2rbs/issues

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
