module Compass
  module SassExtensions
    module Sprites
      module Layout
        class Diagonal < SpriteLayout

          def layout!
            calculate_width!
            calculate_height!
            calculate_positions!
          end

        private # ===========================================================================================>

          def calculate_width!
            @width = @images.inject(0) {|sum, img| sum + img.width}
          end

          def calculate_height!
            @height = @images.inject(0) {|sum, img| sum + img.height}
          end

          def calculate_positions!
            previous = nil
            @images.each_with_index do |image, index|
              if previous.nil?
                previous = image
                image.top = @height - image.height
                image.left = 0
                next
              end
              image.top = previous.top - image.height
              image.left = previous.left + previous.width
              previous = image
            end
          end

        end
      end
    end
  end
end
