require 'chunky_png'

module Compass::SassExtensions::Functions::Sprites
  SASS_NULL = Sass::Script::Number::new(0)
  
  # Provides a consistent interface for getting a variable in ruby
  # from a keyword argument hash that accounts for underscores/dash equivalence
  # and allows the caller to pass a symbol instead of a string.
  module VariableReader
    def get_var(variable_name)
      self[variable_name.to_s.gsub(/-/,"_")]
    end
  end

  def generate_sprite_image(uri, kwargs = {})
    kwargs.extend VariableReader
    path, name = Compass::Sprites.path_and_name(uri.value)
    last_spacing = 0
    width = 0
    height = 0

    # Get image metadata
    Compass::Sprites.discover_sprites(uri.value).each do |file|
      Compass::Sprites.compute_image_metadata! file, path, name
    end

    images = Compass::Sprites.sprites(path, name)

    # Calculation
    images.each do |image|
      current_spacing = number_from_var(kwargs, "#{image[:name]}-spacing", 0)
      if height > 0
        height += [current_spacing, last_spacing].max
      end
      image[:y] = height
      height += image[:height]
      last_spacing = current_spacing
      width = image[:width] if image[:width] > width
    end
    
    # Generation
    output_png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
    images.each do |image|
      input_png  = ChunkyPNG::Image.from_file(image[:file])
      
      position = kwargs.get_var("#{image[:name]}-position") || Sass::Script::Number.new(0, ["%"])
      if position.unit_str == "%"
        image[:x] = (width - image[:width]) * (position.value / 100)
      else
        image[:x] = position.value
      end
      
      repeat = if (var = kwargs.get_var("#{image[:name]}-repeat"))
        var.value
      else
        "no-repeat"
      end
      if repeat == "no-repeat"
        output_png.replace input_png, image[:x], image[:y]
      else
        x = image[:x] - (image[:x] / image[:width]).ceil * image[:width]
        while x < width do
          output_png.replace input_png, x, image[:y]
          x += image[:width]
        end
      end
    end
    output_png.save File.join(File.join(Compass.configuration.images_path, "#{path}.png"))
    
    sprite_url(uri)
  end
  Sass::Script::Functions.declare :generate_sprite_image, [:uri], :var_kwargs => true
  
  def sprite_image(uri, x_shift = SASS_NULL, y_shift = SASS_NULL, depricated_1 = nil, depricated_2 = nil)
    check_spacing_deprecation uri, depricated_1, depricated_2
    url = sprite_url(uri)
    position = sprite_position(uri, x_shift, y_shift)
    Sass::Script::String.new("#{url} #{position}")
  end
    
  def sprite_url(uri)
    path, name = Compass::Sprites.path_and_name(uri.value)
    image_url(Sass::Script::String.new("#{path}.png"))
  end

  def sprite_position(uri, x_shift = SASS_NULL, y_shift = SASS_NULL, depricated_1 = nil, depricated_2 = nil)
    check_spacing_deprecation uri, depricated_1, depricated_2
    path, name = Compass::Sprites.path_and_name(uri.value)
    image_name = File.basename(uri.value, '.png')
    image = Compass::Sprites.sprites(path, name).detect{ |image| image[:name] == image_name }
    if x_shift.unit_str == "%"
      x = x_shift.to_s
    else
      x = x_shift.value - image[:x]
      x = "#{x}px" unless x == 0
    end
    y = y_shift.value - image[:y]
    y = "#{y}px" unless y == 0
    Sass::Script::String.new("#{x} #{y}")
  end
  
private
  
  def number_from_var(kwargs, var_name, default_value)
    if number = kwargs.get_var(var_name)
      assert_type number, :Number
      number.value
    else
      default_value
    end
  end
  
  def check_spacing_deprecation(uri, spacing_before, spacing_after)
    if spacing_before or spacing_after
      path, name, image_name = Compass::Sprites.path_and_name(uri.value)
      message = %Q(Spacing parameter is deprecated. ) +
        %Q(Please add `$#{name}-#{image_name}-spacing: #{spacing_before};` ) +
        %Q(before the `@import "#{path}/*.png";` statement.)
      raise Compass::Error, message
    end
  end
end
