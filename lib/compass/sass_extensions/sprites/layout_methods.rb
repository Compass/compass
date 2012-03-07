module Compass
  module SassExtensions
    module Sprites
      module LayoutMethods
        HORIZONTAL = 'horizontal'
        DIAGONAL = 'diagonal'
        SMART = 'smart'
        VERTICAL = 'vertical'
        
        def smart?
          layout == SMART
        end
        
        def horizontal?
          layout == HORIZONTAL
        end
        
        def diagonal?
          layout == DIAGONAL
        end

        def vertical?
          layout == VERTICAL
        end
        
        def layout
          @layout ||= @kwargs.get_var('layout').value
        end
        
        # Calculates the overal image dimensions
        # collects image sizes and input parameters for each sprite
        def compute_image_positions!
          case layout
          when SMART
            calculate_smart_positions
          when DIAGONAL
            calculate_diagonal_dimensions
            calculate_diagonal_positions
          when HORIZONTAL
            @height = height_for_horizontal_layout
            calculate_horizontal_positions
            @width = width_for_horizontal_layout
          else
            @images.sort! do |a,b| 
              if (b.size <=> a.size) === 0
                a.name <=> b.name
              else
                b.size <=> a.size
              end
            end

            @width = width_for_vertical_layout
            calulate_vertical_postions
            @height = height_for_vertical_layout
            if @images.any?(&:repeat_x?)
              calculate_repeat_extra_width!
              tile_images_that_repeat
             end
          end
        end

        def tile_images_that_repeat
          @images.map {|img| img if img.repeat_x?}.compact.each do |image|
            x = image.left - (image.left / image.width).ceil * image.width
              while x < @width do
                begin
                  img = image.dup
                  img.top = image.top
                  img.left = x.to_i
                  @images << img
                  x += image.width 
                end
              end
            end
        end

        def calculate_repeat_extra_width!
          require 'rational' #for ruby 1.8.7
          m = @images.inject(1) {|m,img| img.repeat_x? ? m.lcm(img.width) : m}
          remainder = @width % m
          @width += (m - remainder) unless remainder.zero?
        end
        
        def calculate_smart_positions
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
        
        
        def calculate_diagonal_dimensions
          @width = @images.inject(0) {|sum, img| sum + img.width}
          @height = @images.inject(0) {|sum, img| sum + img.height}
        end
        
        def calculate_diagonal_positions
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
        
        def calculate_horizontal_positions
          @images.each_with_index do |image, index|
            image.top = image.position.unit_str == '%' ? (@height - image.height) * (image.position.value / 100.0) : image.position.value
            next if index == 0
            last_image = @images[index-1]
            image.left = last_image.left + last_image.width + [image.spacing, last_image.spacing].max
          end
        end
        
        def calulate_vertical_postions
          @images.each_with_index do |image, index|
            image.left = (image.position.unit_str == "%" ? (@width - image.width) * (image.position.value / 100.0) : image.position.value).to_i
            next if index == 0
            last_image = @images[index-1]
            image.top = last_image.top + last_image.height + [image.spacing,  last_image.spacing].max
          end
        end
        
        def height_for_vertical_layout
          last = @images.last
          last.top + last.height
        end
        
        def height_for_horizontal_layout
          @height = @images.map {|image| image.height + image.offset}.max
        end
        
        def width_for_horizontal_layout
          @images.inject(0) { |sum, image| sum += (image.width + image.spacing) }
        end
        
        def width_for_vertical_layout
          @images.map { |image| image.width + image.offset }.max
        end
      end
    end
  end
end
  