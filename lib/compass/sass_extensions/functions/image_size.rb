module Compass::SassExtensions::Functions::ImageSize
  # Returns the width of the image relative to the images directory
  def image_width(image_file)
    image_path = real_path(image_file)
    width = ImageProperties.new(image_path).size.first
    Sass::Script::Number.new(width,["px"])
  end

  # Returns the height of the image relative to the images directory
  def image_height(image_file)
    image_path = real_path(image_file)
    height = ImageProperties.new(image_path).size.last
    Sass::Script::Number.new(height, ["px"])
  end

private
  def real_path(image_file)
    path = image_file.value
    # Compute the real path to the image on the file stystem if the images_dir is set.
    if Compass.configuration.images_path
      File.join(Compass.configuration.images_path, path)
    else
      File.join(Compass.configuration.project_path, path)
    end
  end

  class ImageProperties
    def initialize(file)
      @file = file
      @file_type = File.extname(@file)[1..-1]
    end

    def size
      @dimensions ||= send(:"get_size_for_#{@file_type}")
    rescue NoMethodError
      raise Sass::SyntaxError, "Unrecognized file type: #{@file_type}"
    end

  private
    def get_size_for_png
      IO.read(@file)[0x10..0x18].unpack('NN')
    end

    def get_size_for_gif
      size = IO.read(@file)[6..10].unpack('SS')
    end

    def get_size_for_jpg
      get_size_for_jpeg
    end

    def get_size_for_jpeg
      jpeg = JPEG.new(@file)
      [jpeg.width, jpeg.height]
    end
  end

  class JPEG
    attr_reader :width, :height, :bits

    def initialize(file)
      if file.kind_of? IO
        examine(file)
      else
        File.open(file, 'rb') { |io| examine(io) }
      end
    end

  private
    def examine(io)
      class << io
        unless method_defined?(:readbyte)
          def readbyte
            getc
          end
        end
        def readint; (readbyte << 8) + readbyte; end
        def readframe; read(readint - 2); end
        def readsof; [readint, readbyte, readint, readint, readbyte]; end
        def next
          c = readbyte while c != 0xFF
          c = readbyte while c == 0xFF
          c
        end
      end

      raise 'malformed JPEG!' unless io.readbyte == 0xFF && io.readbyte == 0xD8 # SOI

      while marker = io.next
        case marker
          when 0xC0..0xC3, 0xC5..0xC7, 0xC9..0xCB, 0xCD..0xCF # SOF markers
            length, @bits, @height, @width, components = io.readsof
            raise 'malformed JPEG' unless length == 8 + components * 3
          when 0xD9, 0xDA then  break # EOI, SOS
          when 0xFE then @comment = io.readframe # COM
          when 0xE1 then io.readframe # APP1, contains EXIF tag
          else io.readframe # ignore frame
        end
      end
    end
end
end
