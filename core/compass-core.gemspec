# coding: utf-8
lib = File.expand_path('lib', File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compass/core/version'

Gem::Specification.new do |spec|
  spec.name          = "compass-core"
  spec.version       = Compass::Core::VERSION
  spec.authors       = ["Chris Eppstein", "Scott Davis", "Eric M. Suzanne", "Brandon Mathis"]
  spec.email         = ["chris@eppsteins.net"]
  spec.description   = %q{The Compass core stylesheet library and minimum required ruby extensions. This library can be used stand-alone without the compass ruby configuration file or compass command line tools.}
  spec.summary       = %q{The Compass core stylesheet library}
  spec.homepage      = "http://compass-style.org/reference/compass/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).select {|f| File.exist?(f) && f =~ %r{^(data|lib|stylesheets|templates)/} }
  spec.files         += %w(
    VERSION
    LICENSE.txt
  )
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sass", ">= 3.3.0"
  spec.add_dependency 'multi_json', '~> 1.0'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
