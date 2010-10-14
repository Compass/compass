module Compass::SassExtensions::Functions::Sprites

  def sprite_position(file)
    name = File.dirname(file.value)
    sprite = File.basename(file.value, '.png')
    y = Compass::Sprites.sprites(name).detect{ |sprite_info| sprite_info[:name] == sprite }[:y]
    y = "-#{y}px" unless y == 0
    Sass::Script::String.new("0 #{y}")
  end

end
