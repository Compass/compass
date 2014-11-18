module Compass
  module Sprites
    module SassExtensions
      module LayoutMethods
        HORIZONTAL = 'horizontal'
        DIAGONAL = 'diagonal'
        SMART = 'smart'
        VERTICAL = 'vertical'
        PACKED = 'packed'
        
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
        
        def packed?
          layout == PACKED
        end
        
        def layout
          @layout ||= @kwargs.get_var('layout').value
        end
        
        # Calculates the overal image dimensions
        # collects image sizes and input parameters for each sprite
        def compute_image_positions!
          case layout
          when SMART
            require 'compass/sprites/sass_extensions/layout/smart'
            @images, @width, @height = Layout::Smart.new(@images, @kwargs).properties
          when PACKED
            require 'compass/sprites/sass_extensions/layout/packed'
            @images, @width, @height = Layout::Packed.new(@images, @kwargs).properties
          when DIAGONAL
            require 'compass/sprites/sass_extensions/layout/diagonal'
            @images, @width, @height = Layout::Diagonal.new(@images, @kwargs).properties
          when HORIZONTAL
            require 'compass/sprites/sass_extensions/layout/horizontal'
            @images, @width, @height = Layout::Horizontal.new(@images, @kwargs).properties
          else
            require 'compass/sprites/sass_extensions/layout/vertical'
            @images, @width, @height = Layout::Vertical.new(@images, @kwargs).properties
          end
        end
        
      end
    end
  end
end
  
