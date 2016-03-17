require 'RMagick'
include Magick

module Compass::Core::SassExtensions::Functions::InlineImage

  def inline_image(path, mime_type = nil)
    path = path.value
    real_path = File.join(Compass.configuration.images_path, path)
    inline_image_string(data(real_path), compute_mime_type(path, mime_type))
  end

  def inline_font_files(*args)
    files = []
    with_each_font_file(*args) do |path, type|
      path = path.value
      real_path = File.join(Compass.configuration.fonts_path, path)
      data = inline_image_string(data(real_path), compute_mime_type(path))
      files << list(data, unquoted_string("format('#{type}')"), :space)
    end
    list(files, :comma)
  end

  def inline_svg_code(str)
    code = str.value
    inline_svg_string(format_svg_code(code))
  end

  def inline_svg_code_to_png(str)
    code = str.value
    inline_image_string(convert_svg_code_to_png(code), 'png')
  end

protected
  def inline_image_string(data, mime_type)
    data = [data].flatten.pack('m').gsub("\n","")
    url = "url('data:#{mime_type};base64,#{data}')"
    unquoted_string(url)
  end

  def inline_svg_string(data)
    url = "url('data:image/svg+xml,#{data}')"
    unquoted_string(url)
  end

private
  def compute_mime_type(path, mime_type = nil)
    return mime_type.value if mime_type
    case path
    when /\.png$/i
      'image/png'
    when /\.jpe?g$/i
      'image/jpeg'
    when /\.gif$/i
      'image/gif'
    when /\.svg$/i
      'image/svg+xml'
    when /\.otf$/i
      'font/opentype'
    when /\.eot$/i
      'application/vnd.ms-fontobject'
    when /\.ttf$/i
      'font/truetype'
    when /\.woff$/i
      'application/font-woff'
    when /\.off$/i
      'font/openfont'
    when /\.([a-zA-Z]+)$/
      "image/#{Regexp.last_match(1).downcase}"
    else
      raise Compass::Error, "A mime type could not be determined for #{path}, please specify one explicitly."
    end
  end

  def data(real_path)
    if File.readable?(real_path)
      File.open(real_path, "rb") {|io| io.read}
    else
      raise Compass::Error, "File not found or cannot be read: #{real_path}"
    end
  end

  def format_svg_code(code)
    ERB::Util.url_encode(code)
  end

  def convert_svg_code_to_png(str)
    img, data = Magick::Image.from_blob(str) {
      self.format = 'SVG'
      self.background_color = 'transparent'
    }
    img.to_blob {
      self.format = 'PNG'
    }
  end
end
