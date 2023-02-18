# frozen_string_literal: true

require_relative 'lib/truemail/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'truemail-client'
  spec.version       = Truemail::Client::VERSION
  spec.authors       = ['Vladislav Trotsenko']
  spec.email         = ['admin@bestweb.com.ua']

  spec.summary       = %(truemail-client)
  spec.description   = %(Truemail web API client library for Ruby)

  spec.homepage      = 'https://github.com/truemail-rb/truemail-ruby-client'
  spec.license       = 'MIT'

  spec.metadata = {
    'homepage_uri' => 'https://truemail-rb.org',
    'changelog_uri' => 'https://github.com/truemail-rb/truemail-ruby-client/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/truemail-rb/truemail-ruby-client',
    'documentation_uri' => 'https://truemail-rb.org/truemail-ruby-client',
    'bug_tracker_uri' => 'https://github.com/truemail-rb/truemail-ruby-client/issues'
  }

  spec.required_ruby_version = '>= 2.5.0'
  spec.files = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(bin|lib)/|.ruby-version|truemail.gemspec|LICENSE}) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'ffaker', '~> 2.21'
  spec.add_development_dependency 'json_matchers', '~> 0.11.1'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'webmock', '~> 3.18', '>= 3.18.1'
end
