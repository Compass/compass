require 'chunky_png'

module Compass::SassExtensions::Functions::Sprites
  SASS_NULL = Sass::Script::Number::new(0)
  
  def sprite_image(uri)
    uri = uri.value
    path, name = Compass::Sprites.path_and_name(uri)
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
      output_png.replace input_png, image[:x], image[:y]
    end
    output_png.save File.join(File.join(Compass.configuration.images_path, "#{path}.png"))
    
    image_url(Sass::Script::String.new("#{path}.png"))
  end

  def sprite_position(file, x_shift = SASS_NULL, y_shift = SASS_NULL)
    name = File.dirname(file.value)
    image_name = File.basename(file.value, '.png')
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
