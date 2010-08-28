module Compass::SassExtensions::Functions::Constants
  # returns the opposite position of a side or corner.
  def opposite_position(position)
    opposite = position.value.split(/ +/).map do |pos|
      case pos
      when "top" then "bottom"
      when "bottom" then "top"
      when "left" then "right"
      when "right" then "left"
      when "center" then "center"
      else
        raise Sass::SyntaxError, "Cannot determine the opposite of #{pos}"
      end
    end
    Sass::Script::String.new(opposite.join(" "), position.type)
  end
end
