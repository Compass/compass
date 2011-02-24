module Compass
  module SassExtensions
    module Sprites
      module RmagickEngine
        class ::Magick::Image
          alias :save :write
        end
        
        def composite_images(dest_image, src_image, x, y)
          width = [src_image.columns + x, dest_image.columns].max
          height = [src_image.rows + y, dest_image.rows].max
          image = Magick::Image.new(width, height) {self.background_color = 'none'}
          image.composite!(dest_image, 0, 0, Magick::CopyCompositeOp)
          image.composite!(src_image, x, y, Magick::CopyCompositeOp)
          image
        end
        
        # Returns a PNG object
        def construct_sprite
          output_png = Magick::Image.new(width, height)
          output_png.background_color = 'none'
          output_png.format = 'PNG24'
          images.each do |image|
            input_png = Magick::Image.read(image.file).first
            if image.repeat == "no-repeat"
              output_png = composite_images(output_png, input_png, image.left, image.top)
            else
              x = image.left - (image.left / image.width).ceil * image.width
              while x < width do
                output_png = composite_images(output_png, input_png, x, image.top)
                #output_png.composite!(input_png, x, image.top, Magick::CopyCompositeOp)
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