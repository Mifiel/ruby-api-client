# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mifiel/version'

Gem::Specification.new do |spec|
  spec.name          = 'mifiel'
  spec.version       = Mifiel::VERSION
  spec.authors       = ['Genaro Madrid']
  spec.email         = ['genmadrid@gmail.com']
  spec.summary       = 'Ruby SDK for mifiel.com.'
  spec.homepage      = 'https://www.mifiel.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '~> 2.3'

  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'api-auth', '~> 1.4'
  spec.add_runtime_dependency 'flexirest', '~> 1.6'
  spec.add_runtime_dependency 'json', '>= 1.8'
  spec.add_runtime_dependency 'rest-client', '>= 1.8'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'bump', '~> 0.5', '>= 0.5.3'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug',     '~> 9.0', '< 9.0.6'
  spec.add_development_dependency 'pry-byebug', '~> 3.4', '>= 3.3.0'
  spec.add_development_dependency 'rake',       '~> 10.0'
  spec.add_development_dependency 'rspec',      '~> 3.1', '>= 3.1.7'
  spec.add_development_dependency 'rubocop',    '~> 0.79.0'
  spec.add_development_dependency 'simplecov',  '~> 0.15'
  spec.add_development_dependency 'sinatra'
  spec.add_development_dependency 'webmock'
end
