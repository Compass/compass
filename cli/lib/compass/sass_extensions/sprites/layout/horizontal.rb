module Compass
  module SassExtensions
    module Sprites
      module Layout
        class Horizontal < SpriteLayout

          def layout!
            calculate_height!
            calculate_width!
            calculate_positions!
            tile_images_that_repeat!
          end

        private # ===========================================================================================>

          def calculate_height!
            @height = @images.map {|image| image.height + image.offset}.max
            if repeating_images?
              calculate_repeat_extra_height!
            end
            @height
          end

          def calculate_width!
            @width = @images.inject(0) { |sum, image| sum += (image.width + image.spacing) }
          end

          def repeating_images?
            @repeating_images ||= @images.any?(&:repeat_y?)
          end

          def calculate_repeat_extra_height!
            m = @images.inject(1) {|m,img| img.repeat_y? ? m.lcm(img.height) : m }
            remainder = @height % m
            @height += (m - remainder) unless remainder.zero?
          end

          def calculate_positions!
            @images.each_with_index do |image, index|
              image.top = image.position.unit_str == '%' ? (@height - image.height) * (image.position.value / 100.0) : image.position.value
              next if index == 0
              last_image = @images[index-1]
              image.left = last_image.left + last_image.width + [image.spacing, last_image.spacing].max
            end
          end

          def tile_images_that_repeat!
            return unless repeating_images?
            @images.map {|img| img if img.repeat_y?}.compact.each do |image|
              y = (image.top + image.height)
              while y < @height do
                begin
                  img = image.dup
                  img.top = y.to_i
                  @images << img
                  y += image.height
                end 
              end #while
            end 
          end 

        end
      end
    end
  end
end
