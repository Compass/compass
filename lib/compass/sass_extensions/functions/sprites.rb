require 'chunky_png'

module Compass::SassExtensions::Functions::Sprites
  def sprite_image(uri)
    uri = uri.value
    path, name = Compass::Sprites.path_and_name(uri)
    last_spacing = 0
    default_spacing = number_from_var("#{name}-spacing")
    width = 0
    height = 0
    images = Compass::Sprites.sprites(name)
    
    # Calculation
    images.each do |image|
      current_spacing = number_from_var("#{name}-#{image[:name]}-spacing")
      if height > 0
        height += [current_spacing, last_spacing, default_spacing].max
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
      x = 0
      y = image[:y]
      output_png.replace input_png, x, y
    end
    output_png.save File.join(File.join(Compass.configuration.images_path, "#{path}.png"))
    
    image_url(Sass::Script::String.new("#{path}.png"))
  end

  def sprite_position(file)
    name = File.dirname(file.value)
    sprite = File.basename(file.value, '.png')
    y = Compass::Sprites.sprites(name).detect{ |sprite_info| sprite_info[:name] == sprite }[:y]
    y = "-#{y}px" unless y == 0
    Sass::Script::String.new("0 #{y}")
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
