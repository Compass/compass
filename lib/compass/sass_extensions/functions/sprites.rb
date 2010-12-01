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
      File.join(File.join(Compass.configuration.images_path, "#{path}.png"))
    end

    # saves the sprite for later retrieval
    def save!(output_png)
      output_png.save filename
    end

    # All the full-path filenames involved in this sprite
    def image_filenames
      image_names.map do |image_name|
        File.join(File.join(Compass.configuration.images_path, image_name))
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

    def method_missing(meth, *args, &block)
      if @evaluation_context.respond_to?(meth)
        @evaluation_context.send(meth, *args, &block)
      else
        super
      end
    end

  end

  def sprite(uri, kwargs = {})
    kwargs.extend VariableReader
    Sprite.from_uri(uri, self, kwargs)
  end
  Sass::Script::Functions.declare :sprite, [:uri], :var_kwargs => true

  def sprite_image(sprite, image = nil, x_shift = ZERO, y_shift = ZERO)
    unless sprite.is_a?(Sprite)
      missing_sprite!("sprite-image")
    end
    unless image && image.is_a?(Sass::Script::String)
      raise Sass::SyntaxError, %Q(The second argument to sprite-image must be a sprite name. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
    end
    url = sprite_url(sprite)
    position = sprite_position(sprite, image, x_shift, y_shift)
    Sass::Script::List.new([url, position], :space)
  end

  def sprite_name(sprite)
    unless sprite.is_a?(Sprite)
      missing_sprite!("sprite-name")
    end
    Sass::Script::String.new(sprite.name)
  end

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
    
  def sprite_url(sprite)
    unless sprite.is_a?(Sprite)
      missing_sprite!("sprite-url")
    end
    sprite.generate
    image_url(Sass::Script::String.new("#{sprite.path}.png"))
  end

  def missing_image!(sprite, image_name)
    raise Sass::SyntaxError, "No image called #{image_name} found in sprite #{sprite.path}/#{sprite.name}. Did you mean one of: #{sprite.sprite_names.join(", ")}"
  end

  def missing_sprite!(function_name)
    raise Sass::SyntaxError, %Q(The first argument to #{function_name} must be a sprite. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
  end

  def sprite_position(sprite, image_name = nil, x_shift = ZERO, y_shift = ZERO)
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
    if x_shift.unit_str == "%"
      x = x_shift # CE: Shouldn't this be a percentage of the total width?
    else
      x = x_shift.value - image[:left]
      x = Sass::Script::Number.new(x, x == 0 ? [] : ["px"])
    end
    y = y_shift.value - image[:top]
    y = Sass::Script::Number.new(y, y == 0 ? [] : ["px"])
    Sass::Script::List.new([x, y],:space)
  end
  
end
