module Compass
  module SassExtensions
    module Sprites
      module LayoutMethods
        HORIZONTAL = 'horizontal'
        
        def horizontal?
          @kwargs.get_var('layout').value == HORIZONTAL
        end
        
        # Calculates the overal image dimensions
        # collects image sizes and input parameters for each sprite
        def compute_image_positions!
          if horizontal?
            calculate_height
            calculate_horizontal_positions
            calculate_width
          else
            @images.sort! {|a,b| b.size <=> b.size} #put small images first
            calculate_width
            calulate_vertical_postions
            calculate_height
          end
        end
        
        def calculate_horizontal_positions
          @images.each_with_index do |image, index|
            image.top = image.position.unit_str == '%' ? (@height - image.height) * (image.position.value / 100.0) : image.position.value
            next if index == 0
            last_image = @images[index-1]
            image.left = last_image.left + last_image.width + [image.offset, last_image.offset].max
          end
        end
        
        def calulate_vertical_postions
          @images.each_with_index do |image, index|
            image.left = image.position.unit_str == "%" ? (@width - image.width) * (image.position.value / 100.0) : image.position.value
            next if index == 0
            last_image = @images[index-1]
            image.top = last_image.top + last_image.height + [image.spacing,  last_image.spacing].max
          end
        end
        
        
        def calculate_dimensions!
          calculate_width
          calculate_height
        end
        
        def calculate_height
          @height = if horizontal?
            height_for_horizontal_layout
          else
            height_for_vertical_layout
          end
        end
        
        def height_for_vertical_layout
          last = @images.last
          last.top + last.height
        end
        
        def height_for_horizontal_layout
          @height = @images.map {|image| image.height + image.spacing}.max
        end
        
        def calculate_width
          @width = if horizontal?
            width_for_horizontal_layout
          else
            width_for_vertical_layout
          end
        end
        
        def width_for_horizontal_layout
          @images.inject(0) { |sum, image| sum += (image.width + image.offset) }
        end
        
        def width_for_vertical_layout
          @images.map { |image| image.width + image.offset }.max
        end
      end
    end
  end
end
  