module Compass
  module SassExtensions
    module Sprites
      module Layout
        class Vertical < SpriteLayout

          def layout!
            calculate_width!
            calculate_positions!
            calculate_height!
            tile_images_that_repeat!
          end

        private # ===========================================================================================>

          def calculate_width!
            @width = @images.map { |image| image.width + image.offset }.max
            if repeating_images?
              calculate_repeat_extra_width!
            end

            @width
          end

          def calculate_height!
            last    = @images.last
            @height = last.top + last.height
          end

          def repeating_images?
            @repeating_images ||= @images.any?(&:repeat_x?)
          end

          def calculate_repeat_extra_width!
            m = @images.inject(1) {|m,img| img.repeat_x? ? m.lcm(img.width) : m }
            remainder = @width % m
            @width += (m - remainder) unless remainder.zero?
          end

          def calculate_positions!
            @images.each_with_index do |image, index|
            image.left = (image.position.unit_str == "%" ? (@width - image.width) * (image.position.value / 100.0) : image.position.value).to_i
            next if index == 0
            last_image = @images[index-1]
            image.top = last_image.top + last_image.height + [image.spacing,  last_image.spacing].max
            end #each_with_index
          end #method

          def tile_images_that_repeat!
            return unless repeating_images?
            @images.map {|img| img if img.repeat_x?}.compact.each do |image|
              x = image.left - (image.left / image.width).ceil * image.width
              while x < @width do
                begin
                  img = image.dup
                  img.top = image.top
                  img.left = x.to_i
                  @images << img
                  x += image.width 
                end #begin
              end #while
            end #map
          end #method
        end #Vertical
      end #Layout
    end #Sprites
  end #SassExtensions
end #Compass