require 'chunky_png'

module Compass::SassExtensions::Functions::Sprites
  SASS_NULL = Sass::Script::Number::new(0)
  
  def generate_sprite_image(uri)
    path, name = Compass::Sprites.path_and_name(uri.value)
    last_spacing = 0
    width = 0
    height = 0
    images = Compass::Sprites.sprites(name)
    
    # Calculation
    images.each do |image|
      current_spacing = number_from_var("#{name}-#{image[:name]}-spacing")
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
      
      position = environment.var("#{name}-#{image[:name]}-position")
      if position.unit_str == "%"
        image[:x] = (width - image[:width]) * (position.value / 100)
      else
        image[:x] = position.value
      end
      
      repeat = environment.var("#{name}-#{image[:name]}-repeat").to_s
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
  
  def sprite_image(uri, x_shift = SASS_NULL, y_shift = SASS_NULL)
    url = sprite_url(uri)
    position = sprite_position(uri, x_shift, y_shift)
    Sass::Script::String.new("#{url} #{position}")
  end
    
  def sprite_url(uri)
    path, name = Compass::Sprites.path_and_name(uri.value)
    image_url(Sass::Script::String.new("#{path}.png"))
  end

  def sprite_position(uri, x_shift = SASS_NULL, y_shift = SASS_NULL)
    name = File.dirname(uri.value)
    image_name = File.basename(uri.value, '.png')
    image = Compass::Sprites.sprites(name).detect{ |image| image[:name] == image_name }
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
  
  def number_from_var(var_name)
    if var = environment.var(var_name)
      var.value
    else
      0
    end
  end
end
