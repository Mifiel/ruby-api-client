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
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.2'

  # 1.4 fixes a security MITM issue
  # 2.5 is actually a breaking change: it changes the MD5 header
  spec.add_dependency 'api-auth', '~> 2.0'
  spec.add_dependency 'flexirest', '~> 1.6'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
