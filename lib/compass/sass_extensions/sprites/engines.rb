module Compass
  module SassExtensions
    module Sprites
      class Engine
        attr_accessor :width, :height, :images, :canvas
        def initialize(width, height, images)
          @width, @height, @images = width, height, images
          @canvas = nil
        end
        
        def construct_sprite
          raise ::Compass::Error, "You must implement construct_sprite"
        end
        
        def save(filename)
          raise ::Compass::Error, "You must implement save(filename)"
        end
        
      end
    end
  end
end


require 'compass/sass_extensions/sprites/engines/chunky_png_engine'
