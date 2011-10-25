require 'ostruct'
module Compass
  module Sprites
    class Binding < OpenStruct
            
      def sprite_names
        @sprite_names ||= Compass::SpriteImporter.sprite_names(uri)
      end
      
      def get_binding
        binding
      end
    end
  end
end