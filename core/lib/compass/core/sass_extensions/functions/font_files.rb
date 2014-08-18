module Compass::Core::SassExtensions::Functions::FontFiles
  FONT_TYPES = {
    :woff => 'woff',
    :woff2 => 'woff2',
    :otf => 'opentype',
    :opentype => 'opentype',
    :ttf => 'truetype',
    :truetype => 'truetype',
    :svg => 'svg',
    :eot => 'embedded-opentype'
  }

  def font_formats(*args)
    formats = []
    with_each_font_file(*args) do |path, type|
      formats << identifier(type)
    end
    return list(formats, :comma)
  end

  def font_files(*args)
    return null unless args.any?
    files = []
    with_each_font_file(*args) do |path, type|
      files << list(font_url(path), identifier("format('#{type}')"), :space)
    end
    list(files, :comma)
  end

protected
  def with_each_font_file(*args)
    skip_next = false

    args.each_with_index do |path, index|
      assert_type path, :String
      path = unquote(path)
      # if we were told to skip this iteration, do so...
      if skip_next
        skip_next = false
        next
      end

      # back-compat support for passing the font type e.g.
      # font-files('path/to/file.ttf', truetype, 'path/to/file.otf', opentype);
      type = args[index + 1]
      type = type.nil? ? :wrong : type.value.to_sym

      # if the type is valid, keep it, and skip the next index (as it was the type)
      if FONT_TYPES.key? type
        skip_next = true
      # otherwise, we need to look at the file extension to derive the type...
      else
        # let pass url like font.type?thing#stuff
        type = path.to_s.split('.').last.gsub(/(\?(.*))?(#(.*))?\"?/, '').to_sym
      end

      if FONT_TYPES.key? type
        yield(path, FONT_TYPES[type]) if block_given?
      else
        raise Sass::SyntaxError, "Could not determine font type for #{path}"
      end
    end
  end

end
