# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mifiel/version'

Gem::Specification.new do |spec|
  spec.name          = 'mifiel'
  spec.version       = Mifiel::VERSION
  spec.authors       = ['Genaro Madrid']
  spec.email         = ['genmadrid@gmail.com']
  spec.summary       = 'Ruby SDK for mifiel.com.'
  spec.homepage      = 'https://github.com/Mifiel/ruby-api-client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rest-client', '~> 1.7'
  spec.add_runtime_dependency 'json', '~> 1.8'
  spec.add_runtime_dependency 'api-auth', '~> 1.4'
  spec.add_runtime_dependency 'active_rest_client', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.7'
  spec.add_development_dependency 'pry', '~> 0.10', '>= 0.10.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.3', '>= 3.3.0'
  spec.add_development_dependency 'bump', '~> 0.5', '>= 0.5.3'
  spec.add_development_dependency 'webmock', '~> 1.22', '>= 1.22.2'
  spec.add_development_dependency 'sinatra', '~> 1.4', '>= 1.4.7'
end
