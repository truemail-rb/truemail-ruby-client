# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'truemail/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'truemail-client'
  spec.version       = Truemail::Client::VERSION
  spec.authors       = ['Vladislav Trotsenko']
  spec.email         = ['admin@bestweb.com.ua']

  spec.summary       = %(truemail-client)
  spec.description   = %(Truemail web API client library for Ruby)

  spec.homepage      = 'https://github.com/truemail-rb/truemail-ruby-client'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.5.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'bundler-audit', '~> 0.6.1'
  spec.add_development_dependency 'fasterer', '~> 0.8.2'
  spec.add_development_dependency 'ffaker', '~> 2.14'
  spec.add_development_dependency 'json_matchers', '~> 0.11.1'
  spec.add_development_dependency 'overcommit', '~> 0.52.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.8'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
  spec.add_development_dependency 'reek', '~> 5.6'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.80.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5', '>= 1.5.2'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.38', '>= 1.38.1'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
  spec.add_development_dependency 'webmock', '~> 3.8', '>= 3.8.3'
end
