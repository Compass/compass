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
            require 'compass/sass_extensions/sprites/layout/horizontal'
            @images, @width, @height = Layout::Horizontal.new(@images, @kwargs).properties
          else
            require 'compass/sass_extensions/sprites/layout/vertical'
            @images, @width, @height = Layout::Vertical.new(@images, @kwargs).properties
          end
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
        
      end
    end
  end
end
  
