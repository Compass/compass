require 'rational'
module Compass
  module SassExtensions
    module Sprites
      module Layout
        class SpriteLayout

          attr_reader :images, :options
          attr_accessor :height, :width

          def initialize(images, kwargs={})
            @images  = images
            @options = kwargs
            @height  = 0
            @width   = 0
            
            layout!
          end

          def layout!
            raise Compass::SpriteException, "You must impliment layout!"
          end

          def properties
            if @width.zero?
              raise Compass::SpriteException, "You must set the width fetching the properties"
            end
            if @height.zero?
              raise Compass::SpriteException, "You must set the height fetching the properties"
            end

            [@images, @width, @height]
          end

        end
      end
    end
  end
end