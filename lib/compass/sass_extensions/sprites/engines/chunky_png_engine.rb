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
            input_png  = ChunkyPNG::Image.from_file(image.file)
            canvas.replace! input_png, image.left, image.top
          end
        end

        def save(filename)
          if canvas.nil?
            construct_sprite
          end

          Sass::Util.atomic_create_and_write_file(filename) do |file|
            canvas.write(file, Compass.configuration.chunky_png_options)
          end
        end

      end
    end
  end
end
