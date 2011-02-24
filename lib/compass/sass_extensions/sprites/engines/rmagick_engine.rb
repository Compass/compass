module Compass
  module SassExtensions
    module Sprites
      module RmagickEngine
        class ::Magick::Image
          alias :save :write
        end
        # Returns a PNG object
        def construct_sprite
          output_png = Magick::Image.new(width, height)
          output_png.background_color = 'transparent'
          output_png.format = 'PNG'
          images.each do |image|
            input_png = Magick::Image.read(image.file).first
            if image.repeat == "no-repeat"
              output_png.composite!(input_png, image.left, image.top, Magick::CopyCompositeOp)
            else
              x = image.left - (image.left / image.width).ceil * image.width
              while x < width do
                output_png.composite!(input_png, x, image.top, Magick::CopyCompositeOp)
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