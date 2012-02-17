module Compass::SassExtensions::Functions::ImageSize
  # Returns the width of the image relative to the images directory
  def image_width(image_file)
    width, _ = image_dimensions(image_file)
    Sass::Script::Number.new(width,["px"])
  end
  
  # Returns the height of the image relative to the images directory
  def image_height(image_file)
    _, height = image_dimensions(image_file)
    Sass::Script::Number.new(height, ["px"])
  end

  class ImageProperties
    def initialize(file)
      @file = (file.respond_to?(:to_path) ? file.to_path : file)
      @file_type = File.extname(@file)[1..-1]
    end

    def size
      @dimensions ||= send(:"get_size_for_#{@file_type}")
    rescue NoMethodError
      raise Sass::SyntaxError, "Unrecognized file type: #{@file_type}"
    end

  private
    def get_size_for_png
      File.open(@file, "rb") {|io| io.read}[0x10..0x18].unpack('NN')
    end

    def get_size_for_gif
      File.open(@file, "rb") {|io| io.read}[6..10].unpack('SS')
    end

    def get_size_for_jpg
      get_size_for_jpeg
    end

    def get_size_for_jpeg
      jpeg = JPEG.new(@file)
      [jpeg.width, jpeg.height]
    end
  end

private

  def image_dimensions(image_file)
    options[:compass] ||= {}
    options[:compass][:image_dimensions] ||= {}
    options[:compass][:image_dimensions][image_file.value] = ImageProperties.new(image_path_for_size(image_file.value)).size
  end
  
  def image_path_for_size(image_file)
    if File.exists?(image_file)
      return image_file 
    end
    real_path(image_file)
  end

  def real_path(image_file)
    # Compute the real path to the image on the file stystem if the images_dir is set.
    if Compass.configuration.images_path
      File.join(Compass.configuration.images_path, image_file)
    else
      File.join(Compass.configuration.project_path, image_file)
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
