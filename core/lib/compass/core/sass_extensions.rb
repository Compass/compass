require 'sass'
unless Sass::Script::Functions.methods.grep(/\Adeclare\Z/).any?
  raise LoadError, "It looks like you've got an incompatible version of Sass. This often happens when you have an old haml gem installed. Please upgrade Haml to v3.1 or above."
end

module Compass::Core::SassExtensions
end

require 'compass/core/sass_extensions/functions'
require 'compass/core/sass_extensions/monkey_patches'
