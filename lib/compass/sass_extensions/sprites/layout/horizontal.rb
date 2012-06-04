module Compass
  module SassExtensions
    module Sprites
      module Layout
        class Horizontal < SpriteLayout

          def layout!
            calculate_height!
            calculate_positions!
            calculate_width!
          end

        private # ===========================================================================================>

          def calculate_height!
            @height = @images.map {|image| image.height + image.offset}.max
          end

          def calculate_width!
            @width = @images.inject(0) { |sum, image| sum += (image.width + image.spacing) }
          end

          def calculate_positions!
            @images.each_with_index do |image, index|
              image.top = image.position.unit_str == '%' ? (@height - image.height) * (image.position.value / 100.0) : image.position.value
              next if index == 0
              last_image = @images[index-1]
              image.left = last_image.left + last_image.width + [image.spacing, last_image.spacing].max
            end
          end

        end
      end
    end
  end
end
