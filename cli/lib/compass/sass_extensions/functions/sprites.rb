module Compass::SassExtensions::Functions::Sprites

  extend Compass::SassExtensions::Functions::SassDeclarationHelper
  extend Sass::Script::Value::Helpers
  include Sass::Script::Value::Helpers

  ZERO = number(0)
  BOOL_FALSE = bool(false)
  VALID_SELECTORS = %w(hover active target focus)

  # Provides a consistent interface for getting a variable in ruby
  # from a keyword argument hash that accounts for underscores/dash equivalence
  # and allows the caller to pass a symbol instead of a string.
  module VariableReader
    def get_var(variable_name)
      self[variable_name.to_s.gsub(/-/,"_")]
    end
  end

  # Returns the width of the generated sprite map
  def sprite_width(map, sprite=nil)
    verify_map(map, 'sprite-width')
    file = get_sprite_file(map, sprite)
    width, _ = image_dimensions(file)
    number(width, "px")
  end
  declare :sprite_width, [:map]
  declare :sprite_width, [:map, :sprite]
  
  # Returns the height of the generated sprite map
  def sprite_height(map, sprite=nil)
    verify_map(map, 'sprite-height')
    file = get_sprite_file(map, sprite)
    _, height = image_dimensions(file)
    number(height, "px")
  end
  declare :sprite_height, [:map]
  declare :sprite_height, [:map, :sprite]

  # Returns a list of all sprite names
  def sprite_names(map)
    verify_map(map, 'sprite-names')
    list(map.sprite_names.map { |f| identifier(f) }, :comma)
  end
  declare :sprite_names, [:map]

  # Returns the system path of the sprite file
  def sprite_path(map)
    verify_map(map, 'sprite-path')
    identifier(map.filename)
  end
  declare :sprite_path, [:map]

  # Returns the sprite file as an inline image
  #    @include "icon/*.png";
  #     #{$icon-sprite-base-class} {
  #       background-image: inline-sprite($icon-sprites);
  #      }
  def inline_sprite(map)
    verify_map(map, "sprite-url")
    map.generate
    path = map.filename
    inline_image_string(data(path), compute_mime_type(path))
  end
  declare :inline_sprite, [:map]

  # Creates a Compass::SassExtensions::Sprites::SpriteMap object. A sprite map, when used in a property is the same
  # as calling sprite-url. So the following background properties are equivalent:
  #
  #     $icons: sprite-map("icons/*.png");
  #     background: sprite-url($icons) no-repeat;
  #     background: $icons no-repeat;
  #
  # The sprite map object will generate the sprite map image, if necessary,
  # the first time it is converted to a url. Simply constructing it has no side-effects.
  def sprite_map(glob, kwargs = {})
    kwargs.extend VariableReader
    Compass::SassExtensions::Sprites::SpriteMap.from_uri(glob, self, kwargs)
  end
  declare :sprite_map, [:glob], :var_kwargs => true

  # Returns the image and background position for use in a single shorthand property:
  #
  #     $icons: sprite-map("icons/*.png"); // contains icons/new.png among others.
  #     background: sprite($icons, new) no-repeat;
  #
  # Becomes:
  #
  #     background: url('/images/icons.png?12345678') 0 -24px no-repeat;
  #
  # If the `use_percentages` parameter is passed as true, percentages will be
  # used to position the sprite. Example output:
  #     
  #     background: url('/images/icons.png?12345678') 0 50% no-repeat;
  #
  def sprite(map, sprite, offset_x = ZERO, offset_y = ZERO, use_percentages = BOOL_FALSE)
    sprite = convert_sprite_name(sprite)
    verify_map(map)
    verify_sprite(sprite)
    url = sprite_url(map)
    position = sprite_position(map, sprite, offset_x, offset_y, use_percentages)
    list([url] + position.value, :space)
  end
  declare :sprite, [:map, :sprite]
  declare :sprite, [:map, :sprite, :offset_x]
  declare :sprite, [:map, :sprite, :offset_x, :offset_y]
  declare :sprite, [:map, :sprite, :offset_x, :offset_y, :use_percentages]

  # Returns the name of a sprite map
  # The name is derived from the folder than contains the sprites.
  def sprite_map_name(map)
    verify_map(map, "sprite-map-name")
    identifier(map.name)
  end
  declare :sprite_name, [:sprite]

  # Returns the path to the original image file for the sprite with the given name
  def sprite_file(map, sprite)
    sprite = convert_sprite_name(sprite)
    verify_map(map, "sprite")
    verify_sprite(sprite)
    if image = map.image_for(sprite.value)
      image_path = Pathname.new(File.expand_path(image.file))
      images_path = Pathname.new(File.expand_path(Compass.configuration.images_path))
      quoted_string(image_path.relative_path_from(images_path).to_s)
    else
      missing_image!(map, sprite)
    end
  end
  declare :sprite_file, [:map, :sprite]

  # Returns boolean if sprite has a parent
  def sprite_does_not_have_parent(map, sprite)
    sprite = convert_sprite_name(sprite)
    verify_map map
    verify_sprite sprite
    bool(map.image_for(sprite.value).parent.nil?)
  end
  declare :sprite_does_not_have_parent, [:map, :sprite]

  #return the name of the selector file
  def sprite_selector_file(map, sprite, selector)
    sprite = convert_sprite_name(sprite)
    image = map.image_for(sprite)
    if map.send(:"has_#{selector.value}?", sprite.value)
      return identifier(image.send(selector.value).name)
    end

    raise Sass::SyntaxError, "Sprite: #{sprite.value} does not have a #{selector} state"
  end

  declare :sprite_selector_file, [:map, :sprite, :selector]

  # Returns boolean if sprite has the selector
  def sprite_has_selector(map, sprite, selector)
    sprite = convert_sprite_name(sprite)
    verify_map map
    verify_sprite sprite
    unless VALID_SELECTORS.include?(selector.value)
      raise Sass::SyntaxError, "Invalid Selctor did you mean one of: #{VALID_SELECTORS.join(', ')}"
    end
    bool map.send(:"has_#{selector.value}?", sprite.value)
  end
  
  declare :sprite_has_selector, [:map, :sprite, :selector]

  # Determines if the CSS selector is valid
  IDENTIFIER_RX = /\A#{Sass::SCSS::RX::IDENT}\Z/
  def sprite_has_valid_selector(selector)
    unless selector.value =~ IDENTIFIER_RX
      raise Sass::SyntaxError, "#{selector} must be a legal css identifier"
    end
    bool true
  end

  # Returns a url to the sprite image.
  def sprite_url(map)
    verify_map(map, "sprite-url")
    map.generate
    generated_image_url(identifier("#{map.path}-s#{map.uniqueness_hash}.png"))
  end
  declare :sprite_url, [:map]

  # Returns the position for the original image in the sprite.
  # This is suitable for use as a value to background-position:
  #
  #     $icons: sprite-map("icons/*.png");
  #     background-position: sprite-position($icons, new);
  #
  # Might generate something like:
  #
  #     background-position: 0 -34px;
  #
  # You can adjust the background relative to this position by passing values for
  # `$offset-x` and `$offset-y`:
  #
  #     $icons: sprite-map("icons/*.png");
  #     background-position: sprite-position($icons, new, 3px, -2px);
  #
  # Would change the above output to:
  #
  #     background-position: 3px -36px;
  #
  # If you set the `use_percentages` parameter to true, the position will be
  # expressed in percentages. An example:
  #
  #     background-position: sprite-position($icons, new, 0, 0, true);
  #
  # Would result in something like this:
  #
  #     background-position: 0 42%;
  # 
  def sprite_position(map, sprite = nil, offset_x = ZERO, offset_y = ZERO, use_percentages = BOOL_FALSE)
    assert_type offset_x, :Number
    assert_type offset_y, :Number
    sprite = convert_sprite_name(sprite)
    verify_map(map, "sprite-position")
    unless sprite.is_a?(Sass::Script::Value::String) || sprite.is_a?(Sass::Script::Value::Number)
      raise Sass::SyntaxError, %Q(The second argument to sprite-position must be a sprite name. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
    end
    image = map.image_for(sprite.value)
    unless image
      missing_image!(map, sprite)
    end
    if use_percentages.value
      xdivis = map.width - image.width;
      x = (offset_x.value + image.left.to_f) / (xdivis.nonzero? || 1) * 100
      x = x == 0 ? number(x) : number(x, "%")
      ydivis = map.height - image.height;
      y = (offset_y.value + image.top.to_f) / (ydivis.nonzero? || 1) * 100
      y = y == 0 ? number(y) : number(y, "%")
    else
      if offset_x.unit_str == "%"
        x = offset_x # CE: Shouldn't this be a percentage of the total width?
      else
        x = offset_x.value - image.left
        x = x == 0 ? number(x) : number(x, "px")
      end
      y = offset_y.value - image.top
      y = y == 0 ? number(y) : number(y, "px")
    end
    list(x, y, :space)
  end
  declare :sprite_position, [:map]
  declare :sprite_position, [:map, :sprite]
  declare :sprite_position, [:map, :sprite, :offset_x]
  declare :sprite_position, [:map, :sprite, :offset_x, :offset_y]
  declare :sprite_position, [:map, :sprite, :offset_x, :offset_y, :use_percentages]

protected

  def get_sprite_file(map, sprite=nil)
    if sprite
      map.image_for(sprite).file
    else
      map.filename
    end
  end

  def reversed_color_names
    if Sass::Script::Value::Color.const_defined?(:HTML4_COLORS_REVERSE)
      Sass::Script::Value::Color::HTML4_COLORS_REVERSE
    else
      Sass::Script::Value::Color::COLOR_NAMES_REVERSE
    end
  end

  def convert_sprite_name(sprite)
    case sprite
      when Sass::Script::Value::Color
        rgb = if reversed_color_names.keys.first.size == 3
                sprite.rgb
              else
                # Sass 3.3 includes the alpha channel
                sprite.rgba
              end
        identifier(reversed_color_names[rgb])
      when Sass::Script::Value::Bool
        identifier(sprite.to_s)
      else
        sprite
    end
  end

  def verify_map(map, error = "sprite")
    unless map.is_a?(Compass::SassExtensions::Sprites::SpriteMap)
      missing_sprite!(error)
    end
  end

  def verify_sprite(sprite)
    unless sprite.is_a?(Sass::Script::Value::String) || sprite.is_a?(Sass::Script::Value::Number)
      raise Sass::SyntaxError, %Q(The second argument to sprite() must be a sprite name. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
    end
  end

  def missing_image!(map, sprite)
    raise Sass::SyntaxError, "No sprite called #{sprite} found in sprite map #{map.path}/#{map.name}. Did you mean one of: #{map.sprite_names.join(", ")}"
  end

  def missing_sprite!(function_name)
    raise Sass::SyntaxError, %Q(The first argument to #{function_name}() must be a sprite map. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
  end

end
