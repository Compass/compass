module Compass::SassExtensions::Functions::Sprites
  include Compass::SassExtensions::Functions::ImageSize
  class SpriteInfo < Sass::Script::Literal
    attr_reader :sprite
    attr_reader :sprite_item
    attr_reader :type

    def initialize(type, sprite, sprite_item = nil, position_x = nil, position_y_shift = nil)
      super(nil)
      @type = type
      @sprite = sprite
      @sprite_item = sprite_item
      @position_x = position_x
      @position_y_shift = position_y_shift
    end

    def to_s(opts = {})
      case @type
      when :position
        position
      when :url
        url
      when :both
        pos = position
        if pos == '0 0'
          url
        else
          "#{url} #{pos}"
        end
      end
    end

    def to_sass
      to_s
    end

  private

    def position
      x = @position_x || 0
      if @sprite_item[:index] == 0 and (@position_y_shift.nil? or @position_y_shift.value == 0)
        "#{x.inspect} 0"
      else
        expression  = "Compass::Sprites.sprites['#{@sprite[:file]}'][:images][#{@sprite_item[:index]}][:y].unary_minus"
        expression << ".plus(Sass::Script::Number.new(#{@position_y_shift.value}, ['px']))" if @position_y_shift
        "#{x.inspect} <%= #{expression} %>"
      end
    end

    def url
      if defined?(Compass)
        compass = Class.new.extend(Compass::SassExtensions::Functions::Urls)
        compass.image_url(Sass::Script::String.new(@sprite[:file])).to_s
      else
        "url('/#{@sprite[:file]}')"
      end
    end

  end


  def sprite_url(file)
    dir, name, basename = extract_names(file)
    sprite = sprite_for("#{dir}#{name}")
    SpriteInfo.new(:url, sprite)
  end

  def sprite_position(file, position_x = nil, position_y_shift = nil, margin_top_or_both = nil, margin_bottom = nil)
    sprite, sprite_item = sprite_url_and_position(file, position_x, position_y_shift, margin_top_or_both, margin_bottom)
    SpriteInfo.new(:position, sprite, sprite_item, position_x, position_y_shift)
  end

  def sprite_image(file, position_x = nil, position_y_shift = nil, margin_top_or_both = nil, margin_bottom = nil)
    sprite, sprite_item = sprite_url_and_position(file, position_x, position_y_shift, margin_top_or_both, margin_bottom)
    SpriteInfo.new(:both, sprite, sprite_item, position_x, position_y_shift)
  end
  alias_method :sprite_img, :sprite_image

  def sprite_files_in_folder(folder)
    assert_type folder, :String
    count = sprite_file_list_from_folder(folder).length
    Sass::Script::Number.new(count)
  end

  def sprite_file_from_folder(folder, n)
    assert_type folder, :String
    assert_type n, :Number
    file = sprite_file_list_from_folder(folder)[n.to_i]
    file = File.basename(file)
    Sass::Script::String.new(File.join(folder.value, file))
  end

  def sprite_name(file)
    dir, name, basename = extract_names(file)
    Sass::Script::String.new(name)
  end

  def image_basename(file)
    dir, name, basename = extract_names(file, :check_file => true)
    Sass::Script::String.new(basename)
  end

private

  def sprite_file_list_from_folder(folder)
    dir = File.join(Compass::Sprites.sprites_path, folder.value)
    Dir.glob(File.join(dir, '*.png')).sort
  end

  def sprite_url_and_position(file, position_x = nil, position_y_shift = nil, margin_top_or_both = nil, margin_bottom = nil)
    dir, name, basename = extract_names(file, :check_file => true)
    filestr = File.join(Compass::Sprites.sprites_path, file.value)

    sprite_file = "#{dir}#{name}.png"
    sprite = sprite_for(sprite_file)
    sprite_item = image_for(sprite, filestr, position_x, position_y_shift, margin_top_or_both, margin_bottom)

    # Create a temporary destination file so compass doesn't complain about a missing image
    FileUtils.touch File.join(Compass::Sprites.images_path, sprite_file) unless File.exists?(File.join(Compass::Sprites.images_path, sprite_file))

    [sprite, sprite_item]
  end

  def extract_names(file, options = {})
    assert_type file, :String
    unless (file.value =~ %r(^(.+/)?([^\.]+?)(/(.+?)\.(png))?$)) == 0
      raise Sass::SyntaxError, 'Please provide a file in a folder: e.g. sprites/button.png'
    end
    dir, name, basename = $1, $2, $4
    if options[:check_file] and basename.nil?
      raise Sass::SyntaxError, 'Please provide a file in a folder: e.g. sprites/button.png'
    end
    [dir, name, basename]
  end

  def sprite_for(file)
    file = "#{file}.png" unless file =~ /\.png$/
    Compass::Sprites.sprites[file] ||= {
        :file => "#{file}",
        :height => 0,
        :width => 0,
        :images => [],
        :margin_bottom => 0
      }
  end

  def image_for(sprite, file, position_x, position_y_shift, margin_top_or_both, margin_bottom)
    image = sprite[:images].detect{ |image| image[:file] == file }
    margin_top_or_both ||= Sass::Script::Number.new(0)
    margin_top = margin_top_or_both.value #calculate_margin_top(sprite, margin_top_or_both, margin_bottom)
    margin_bottom = (margin_bottom || margin_top_or_both).value
    if image
      image[:margin_top] = margin_top if margin_top > image[:margin_top]
      image[:margin_bottom] = margin_bottom if margin_bottom > image[:margin_bottom]
    else
      width, height = ImageProperties.new(file).size
      x = (position_x and position_x.numerator_units == %w(%)) ? position_x : Sass::Script::Number.new(0)
      y = sprite[:height] + margin_top
      y = Sass::Script::Number.new(y, y == 0 ? [] : ['px'])
      image = {
        :file => file,
        :height => height,
        :width => width,
        :x => x,
        :margin_top => margin_top,
        :margin_bottom => margin_bottom,
        :index => sprite[:images].length
      }
      sprite[:images] << image
    end
    image
  rescue Errno::ENOENT
    raise Sass::SyntaxError, "#{file} does not exist in sprites_dir #{Compass::Sprites.sprites_path}"
  rescue ChunkyPNG::SignatureMismatch
    raise Sass::SyntaxError, "#{file} is not a recognized png file, can't use for sprite creation"
  end

end
