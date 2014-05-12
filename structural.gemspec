# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'structural/version'

Gem::Specification.new do |spec|
  spec.name          = 'structural'
  spec.version       = Structural::VERSION
  spec.authors       = ['Russell Dunphy', 'Radek Molenda', 'Jon Doveston']
  spec.email         = ['jon.doveston@onthebeach.co.uk']
  spec.summary       = %q{Simple models based on hashes}
  spec.description   = %q{A cut down fork of the Id gem developed at On The Beach Ltd.}
  spec.homepage      = 'https://github.com/onthebeach/structural'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'money'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
