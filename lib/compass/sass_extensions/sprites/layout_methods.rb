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
            require 'compass/sass_extensions/sprites/layout/smart'
            @images, @width, @height = Layout::Smart.new(@images, @kwargs).properties
          when DIAGONAL
            require 'compass/sass_extensions/sprites/layout/diagonal'
            @images, @width, @height = Layout::Diagonal.new(@images, @kwargs).properties
          when HORIZONTAL
            require 'compass/sass_extensions/sprites/layout/horizontal'
            @images, @width, @height = Layout::Horizontal.new(@images, @kwargs).properties
          else
            require 'compass/sass_extensions/sprites/layout/vertical'
            @images, @width, @height = Layout::Vertical.new(@images, @kwargs).properties
          end
        end
        
      end
    end
  end
end
  
