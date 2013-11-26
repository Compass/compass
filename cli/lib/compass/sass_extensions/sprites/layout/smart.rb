module Compass
  module SassExtensions
    module Sprites
      module Layout
        class Smart < SpriteLayout

          def layout!
            calculate_positions!
          end

        private # ===========================================================================================>

          def calculate_positions!
            fitter = ::Compass::SassExtensions::Sprites::RowFitter.new(@images)
            current_y = 0
            fitter.fit!.each do |row|
              current_x = 0
              row.images.each_with_index do |image, index|
                image.left = current_x
                image.top = current_y
                current_x += image.width
              end
              current_y += row.height
            end
            @width = fitter.width
            @height = fitter.height
          end

        end
      end
    end
  end
end
