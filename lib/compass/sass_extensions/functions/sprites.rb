module Compass::SassExtensions::Functions::Sprites
  def sprite_image(uri)
    uri = uri.value
    path, name = Compass::Sprites.path_and_name(uri)
    y = 0
    last_spacing = 0
    default_spacing = number_from_var("#{name}-spacing")
    images = Compass::Sprites.sprites(name)
    images.each do |image|
      current_spacing = number_from_var("#{name}-#{image[:name]}-spacing")
      if y > 0
        y += [current_spacing, last_spacing, default_spacing].max
      end
      image[:y] = y
      y += image[:height]
      last_spacing = current_spacing
    end
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
