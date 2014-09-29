require 'forwardable'

module Compass
  module Sprites
    module SassExtensions
      class ImageRow
        extend Forwardable

        attr_reader :images, :max_width
        def_delegators :@images, :last, :delete, :empty?, :length
        
        def initialize(max_width)
          @images = []
          @max_width = max_width
        end
        
        def add(image)
          return false if !will_fit?(image)
          @images << image
          true
        end

        alias :<< :add
        
        def height
          images.map(&:height_with_spacing).max
        end
        
        def width
          images.map(&:width_with_spacing).max
        end

        def total_width
          images.inject(0) {|sum, img| sum + img.width }
        end
        
        def efficiency
          1 - (total_width.to_f / max_width.to_f)
        end

        def will_fit?(image)
          (total_width + image.width_with_spacing) <= max_width
        end
      end
    end
  end
end
