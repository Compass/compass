module Compass
  module Sprites
    module SassExtensions
    end
  end
end

require 'digest/md5'
require 'compass/sprites/sass_extensions/functions'
require 'compass/sprites/sass_extensions/images'
require 'compass/sprites/sass_extensions/layout'
require 'compass/sprites/sass_extensions/image_row'
require 'compass/sprites/sass_extensions/row_fitter'
require 'compass/sprites/sass_extensions/pack_fitter'
require 'compass/sprites/sass_extensions/image'
require 'compass/sprites/sass_extensions/layout_methods'
require 'compass/sprites/sass_extensions/sprite_methods'
require 'compass/sprites/sass_extensions/image_methods'
require 'compass/sprites/sass_extensions/sprite_map'
require 'compass/sprites/sass_extensions/engines'
require 'compass/sprites/importer'

module Sass::Script::Functions
  include Compass::Sprites::SassExtensions::Functions
end
