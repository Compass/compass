module Compass
  module SassExtensions
    module Sprites
      class ChunkyPngEngine < Sass::Script::Literal
        include Compass::SassExtensions::Sprites::Base::InstanceMethods

        def require_png_library!
          begin
            require 'oily_png'
          rescue LoadError
            require 'chunky_png'
          end
        end

        # Returns a PNG object
        def construct_sprite
          require_png_library!
          output_png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
          images.each do |image|
            input_png  = ChunkyPNG::Image.from_file(image.file)
            if image.repeat == "no-repeat"
              output_png.replace input_png, image.left, image.top
            else
              x = image.left - (image.left / image.width).ceil * image.width
              while x < width do
                output_png.replace input_png, x, image.top
                x += image.width
              end
            end
          end
          output_png
        end
      end
    end
  end
end