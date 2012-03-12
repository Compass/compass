require 'forwardable'

module Compass
  module SassExtensions
    module Sprites
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
          images.map(&:height).max
        end
        
        def width
          images.map(&:width).max
        end

        def total_width
          images.inject(0) {|sum, img| sum + img.width }
        end
        
        def efficiency
          1 - (total_width.to_f / max_width.to_f)
        end

        def will_fit?(image)
          (total_width + image.width) <= max_width
        end
      end
    end
  end
end