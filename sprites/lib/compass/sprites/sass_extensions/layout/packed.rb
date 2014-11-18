module Compass
  module Sprites
    module SassExtensions
      module Layout
        class Packed < SpriteLayout

          def layout!
            calculate_positions!
          end

        private # ===========================================================================================>

          def calculate_positions!
            packing = ::Compass::SassExtensions::Sprites::PackFitter.new(@images)
            packing.pack! # image.left and image.top are set in here
            @width = packing.width
            @height = packing.height
          end

        end
      end
    end
  end
end

        
        
        
        
        
