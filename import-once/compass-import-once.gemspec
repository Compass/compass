# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compass/import-once/version'

Gem::Specification.new do |spec|
  spec.name          = "compass-import-once"
  spec.version       = Compass::ImportOnce::VERSION
  spec.authors       = ["Chris Eppstein"]
  spec.email         = ["chris@eppsteins.net"]
  spec.description   = %q{Changes the behavior of Sass's @import directive to only import a file once.}
  spec.summary       = %q{Speed up your Sass compilation by making @import only import each file once.}
  spec.homepage      = "https://github.com/chriseppstein/compass/tree/master/import-once"
  spec.license       = "MIT"

  spec.files         = `git ls-files #{File.dirname(__FILE__)}`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sass", ">= 3.2", "< 3.5"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "diff-lcs"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sass-globbing"
end
