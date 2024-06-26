# frozen_string_literal: true

require_relative 'lib/yard2rbs/version'

Gem::Specification.new do |spec|
  spec.name = 'yard2rbs'
  spec.version = Yard2rbs::VERSION
  spec.authors = ['Kieran Pilkington']
  spec.email = ['kieran776@gmail.com']

  spec.summary = 'Convert YARD documentation into RBS files'
  # spec.description = 'TODO: Write a longer description or delete this line.'
  # spec.homepage = 'TODO: Put your gem's website or public repo URL here.'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
  # spec.metadata['allowed_push_host'] = 'TODO: Set to your gem server 'https://example.com''
  # spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata['source_code_uri'] = 'TODO: Put your gem's public repo URL here.'
  # spec.metadata['changelog_uri'] = 'TODO: Put your gem's CHANGELOG.md URL here.'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile sig/spec])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'listen', '~> 3.9.0'
  spec.add_dependency 'prism', '~> 0.30.0'
  spec.add_dependency 'rbs', '~> 3.5.1'
end
