# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compass/sprites/version'

Gem::Specification.new do |spec|
  spec.name          = "compass-sprites"
  spec.version       = Compass::Sprites::VERSION
  spec.authors       = ["Chris Eppstein", "Scott Davis"]
  spec.email         = ["chris@eppsteins.net", "me@sdavis.info"]
  spec.description   = %q{The Compass Core Sprite Library. This Library provides an interface for creating sprites with compass}
  spec.summary       = %q{The Compass Core Sprite Library}
  spec.homepage      = "https://github.com/chriseppstein/compass/tree/master/sprites"
  spec.license       = "MIT"

  spec.files         = `git ls-files #{File.dirname(__FILE__)}`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'chunky_png', '~> 1.2'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
