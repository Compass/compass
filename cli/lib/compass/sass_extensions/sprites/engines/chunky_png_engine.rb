begin
  require 'oily_png'
rescue LoadError
  require 'chunky_png'
end

module Compass
  module SassExtensions
    module Sprites
      class ChunkyPngEngine < Compass::SassExtensions::Sprites::Engine

        def construct_sprite
          @canvas = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
          images.each do |image|
            input_png = begin
              ChunkyPNG::Image.from_file(image.file)
            rescue ChunkyPNG::SignatureMismatch
              raise Compass::SpriteException, "You have provided a file that does not have a PNG signature. Only PNG files are supported by the default sprite engine"
            end
            canvas.replace! input_png, image.left, image.top
          end
        end    
        
        def save(filename)
          if canvas.nil?
            construct_sprite
          end
          
          canvas.save(filename,  Compass.configuration.chunky_png_options)
        end
        
      end
    end
  end
end  