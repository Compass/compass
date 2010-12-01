require 'chunky_png'

module Compass::SassExtensions::Functions::Sprites
  ZERO = Sass::Script::Number::new(0)
  
  # Provides a consistent interface for getting a variable in ruby
  # from a keyword argument hash that accounts for underscores/dash equivalence
  # and allows the caller to pass a symbol instead of a string.
  module VariableReader
    def get_var(variable_name)
      self[variable_name.to_s.gsub(/-/,"_")]
    end
  end

  class Sprite < Sass::Script::Literal

    attr_accessor :image_names, :path, :name, :options
    attr_accessor :images, :width, :height

    def self.from_uri(uri, context, kwargs)
      path, name = Compass::Sprites.path_and_name(uri.value)
      new(Compass::Sprites.discover_sprites(uri.value), path, name, context, kwargs)
    end

    def initialize(image_names, path, name, context, options)
      @image_names, @path, @name, @options = image_names, path, name, options
      @images = nil
      @width = nil
      @height = nil
      @evaluation_context = context
      validate!
      compute_image_metadata!
    end

    def sprite_names
      image_names.map{|f| Compass::Sprites.sprite_name(f) }
    end

    def validate!
      for sprite_name in sprite_names
        unless sprite_name =~ /\A#{Sass::SCSS::RX::IDENT}\Z/
          raise Sass::SyntaxError, "#{sprite_name} must be a legal css identifier"
        end
      end
    end

    # Calculates the overal image dimensions
    # collects image sizes and input parameters for each sprite
    def compute_image_metadata!
      @images = []
      @width = 0
      image_names.each do |file|
        relative_file = file.gsub(Compass.configuration.images_path+"/", "")
        width, height = Compass::SassExtensions::Functions::ImageSize::ImageProperties.new(file).size
        sprite_name = Compass::Sprites.sprite_name(relative_file)
        @width = [@width, width].max
        @images << {
          :name => sprite_name,
          :file => file,
          :relative_file => relative_file,
          :height => height,
          :width => width,
          :repeat => repeat_for(sprite_name),
          :spacing => spacing_for(sprite_name),
          :position => position_for(sprite_name)
        }
      end
      @images.each_with_index do |image, index|
        if index == 0
          image[:top] = 0
        else
          last_image = @images[index-1]
          image[:top] = last_image[:top] + last_image[:height] + [image[:spacing],  last_image[:spacing]].max
        end
        if image[:position].unit_str == "%"
          image[:left] = (@width - image[:width]) * (image[:position].value / 100)
        else
          image[:left] = image[:position].value
        end
      end
      @height = @images.last[:top] + @images.last[:height]
    end

    def position_for(name)
      options.get_var("#{name}-position") || options.get_var("position") || Sass::Script::Number.new(0, ["px"])
    end

    def repeat_for(name)
      if (var = options.get_var("#{name}-repeat"))
        var.value
      elsif (var = options.get_var("repeat"))
        var.value
      else
        "no-repeat"
      end
    end

    def spacing_for(name)
      (options.get_var("#{name}-spacing") ||
       options.get_var("spacing") ||
       ZERO).value
    end

    def image_for(name)
      @images.detect{|img| img[:name] == name}
    end

    # Calculate the size of the sprite
    def size
      [width, height]
    end

    # Generate a sprite image if necessary
    def generate
      if generation_required?
        save!(construct_sprite)
      end
    end

    def generation_required?
      !File.exists?(filename) || outdated?
    end

    # Returns a PNG object
    def construct_sprite
      output_png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
      images.each do |image|
        input_png  = ChunkyPNG::Image.from_file(image[:file])
        if image[:repeat] == "no-repeat"
          output_png.replace input_png, image[:left], image[:top]
        else
          x = image[:left] - (image[:left] / image[:width]).ceil * image[:width]
          while x < width do
            output_png.replace input_png, x, image[:top]
            x += image[:width]
          end
        end
      end
      output_png 
    end

    # The on-the-disk filename of the sprite
    def filename
      File.join(Compass.configuration.images_path, "#{path}.png")
    end

    # saves the sprite for later retrieval
    def save!(output_png)
      output_png.save filename
    end

    # All the full-path filenames involved in this sprite
    def image_filenames
      image_names.map do |image_name|
        File.join(Compass.configuration.images_path, image_name)
      end
    end

    # Checks whether this sprite is outdated
    def outdated?
      last_update = self.mtime
      image_filenames.each do |image|
        return true if File.mtime(image) > last_update
      end
      false
    end

    def mtime
      File.mtime(filename)
    end

    def inspect
      to_s
    end

    def to_s(options = self.options)
      sprite_url(self).value
    end

    def respond_to?(meth)
      super || @evaluation_context.respond_to?(meth)
    end

    def method_missing(meth, *args, &block)
      if @evaluation_context.respond_to?(meth)
        @evaluation_context.send(meth, *args, &block)
      else
        super
      end
    end

  end

  # Creates a sprite object. A sprite object, when used in a property is the same
  # as calling sprite-url. So the following background properties are equivalent:
  #
  #     $sprite: sprite("icons/*.png");
  #     background: sprite-url($sprite) no-repeat;
  #     background: $sprite no-repeat;
  #
  # The sprite object will generate the sprite image, if it is needed,
  # the first time it is converted to a url. Simply constructing it has no side-effects.
  def sprite(uri, kwargs = {})
    kwargs.extend VariableReader
    Sprite.from_uri(uri, self, kwargs)
  end
  Sass::Script::Functions.declare :sprite, [:uri], :var_kwargs => true

  # Returns the image and background position for use in a single shorthand property:
  #
  #     $sprite: sprite("icons/*.png"); // contains icons/new.png among others.
  #     background: sprite-image($sprite, new) no-repeat;
  #
  # Becomes:
  #
  #     background: url('/images/icons.png?12345678') 0 -24px no-repeat;
  def sprite_image(sprite, image = nil, offset_x = ZERO, offset_y = ZERO)
    unless sprite.is_a?(Sprite)
      missing_sprite!("sprite-image")
    end
    unless image && image.is_a?(Sass::Script::String)
      raise Sass::SyntaxError, %Q(The second argument to sprite-image must be a sprite name. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
    end
    url = sprite_url(sprite)
    position = sprite_position(sprite, image, offset_x, offset_y)
    Sass::Script::List.new([url] + position.value, :space)
  end
  Sass::Script::Functions.declare :sprite_image, [:sprite]
  Sass::Script::Functions.declare :sprite_image, [:sprite, :name]
  Sass::Script::Functions.declare :sprite_image, [:sprite, :name, :offset_x]
  Sass::Script::Functions.declare :sprite_image, [:sprite, :name, :offset_x, :offset_y]

  # Returns the name of a sprite
  # The name is derived from the folder than contains the sprite images.
  def sprite_name(sprite)
    unless sprite.is_a?(Sprite)
      missing_sprite!("sprite-name")
    end
    Sass::Script::String.new(sprite.name)
  end
  Sass::Script::Functions.declare :sprite_name, [:sprite]

  # Returns the path to the original image file for the sprite with the given name
  def sprite_file(sprite, image_name)
    unless sprite.is_a?(Sprite)
      missing_sprite!("sprite-file")
    end
    if image = sprite.image_for(image_name.value)
      Sass::Script::String.new(image[:relative_file])
    else
      missing_image!(sprite, image_name)
    end
  end
  Sass::Script::Functions.declare :sprite_file, [:sprite, :name]
    
  # Returns a url to the sprite image.
  def sprite_url(sprite)
    unless sprite.is_a?(Sprite)
      missing_sprite!("sprite-url")
    end
    sprite.generate
    image_url(Sass::Script::String.new("#{sprite.path}.png"))
  end
  Sass::Script::Functions.declare :sprite_url, [:sprite]

  # Returns the position for the original image in the sprite.
  # This is suitable for use as a value to background-position:
  #
  #     $sprite: sprite("icons/*.png");
  #     background-position: sprite-position($sprite, new);
  #
  # Might generate something like:
  #
  #     background-position: 0 34px;
  #
  # You can adjust the background relative to this position by passing values for
  # offset-x and offset-y:
  #
  #     $sprite: sprite("icons/*.png");
  #     background-position: sprite-position($sprite, new, 3px, -2px);
  #
  # Would change the above output to:
  #
  #     background-position: 3px 32px;
  def sprite_position(sprite, image_name = nil, offset_x = ZERO, offset_y = ZERO)
    unless sprite.is_a?(Sprite)
      missing_sprite!("sprite-position")
    end
    unless image_name && image_name.is_a?(Sass::Script::String)
      raise Sass::SyntaxError, %Q(The second argument to sprite-image must be a sprite name. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
    end
    image = sprite.image_for(image_name.value)
    unless image
      missing_image!(sprite, image_name)
    end
    if offset_x.unit_str == "%"
      x = offset_x # CE: Shouldn't this be a percentage of the total width?
    else
      x = offset_x.value - image[:left]
      x = Sass::Script::Number.new(x, x == 0 ? [] : ["px"])
    end
    y = offset_y.value - image[:top]
    y = Sass::Script::Number.new(y, y == 0 ? [] : ["px"])
    Sass::Script::List.new([x, y],:space)
  end
  Sass::Script::Functions.declare :sprite_position, [:sprite]
  Sass::Script::Functions.declare :sprite_position, [:sprite, :name]
  Sass::Script::Functions.declare :sprite_position, [:sprite, :name, :offset_x]
  Sass::Script::Functions.declare :sprite_position, [:sprite, :name, :offset_x, :offset_y]

protected

  def missing_image!(sprite, image_name)
    raise Sass::SyntaxError, "No image called #{image_name} found in sprite #{sprite.path}/#{sprite.name}. Did you mean one of: #{sprite.sprite_names.join(", ")}"
  end

  def missing_sprite!(function_name)
    raise Sass::SyntaxError, %Q(The first argument to #{function_name} must be a sprite. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
  end

end
