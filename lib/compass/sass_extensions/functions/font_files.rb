module Compass::SassExtensions::Functions::FontFiles
  FONT_TYPES = {
    :woff => 'woff',
    :otf => 'opentype',
    :opentype => 'opentype',
    :ttf => 'truetype',
    :truetype => 'truetype',
    :svg => 'svg',
    :eot => 'embedded-opentype'
  }

  def font_files(*args)
    files = []
    args_length = args.length
    skip_next = false

    args.each_with_index do |arg, index|
      if skip_next
        skip_next = false
        next
      end

      type = (args_length > (index + 1)) ? args[index + 1].value.to_sym : :wrong

      if FONT_TYPES.key? type
        skip_next = true
      else
        # let pass url like font.type?thing#stuff
        type = arg.to_s.split('.').last.gsub(/(\?(.*))?(#(.*))?"/, '').to_sym
      end

      if FONT_TYPES.key? type
        files << "#{font_url(arg)} format('#{FONT_TYPES[type]}')"
      else
        raise Sass::SyntaxError, "Could not determine font type for #{arg}"
      end
    end

    Sass::Script::String.new(files.join(", "))
  end
end
