module Compass::Core::SassExtensions::Functions::Constants
  POSITIONS = /top|bottom|left|right|center/
  def is_position(position)
    bool(position.is_a?(Sass::Script::Value::String) && !!(position.value =~ POSITIONS))
  end
  def is_position_list(position_list)
    bool(position_list.is_a?(Sass::Script::Value::List) && position_list.value.all?{|p| is_position(p).to_bool})
  end
  # returns the opposite position of a side or corner.
  def opposite_position(position)
    position = unless position.is_a?(Sass::Script::Value::List)
      list(position, :space)
    else
      list(position.value.dup, position.separator)
    end
    position = list(position.value.map do |pos|
      if pos.is_a? Sass::Script::Value::String
        opposite = case pos.value
        when "top" then "bottom"
        when "bottom" then "top"
        when "left" then "right"
        when "right" then "left"
        when "center" then "center"
        else
          Compass::Util.compass_warn("Cannot determine the opposite position of: #{pos}")
          pos.value
        end
        identifier(opposite)
      elsif pos.is_a? Sass::Script::Value::Number
        if pos.numerator_units == ["%"] && pos.denominator_units == []
          number(100-pos.value, "%")
        else
          Compass::Util.compass_warn("Cannot determine the opposite position of: #{pos}")
          pos
        end
      else
        Compass::Util.compass_warn("Cannot determine the opposite position of: #{pos}")
        pos
      end
    end, position.separator)
    if position.value.size == 1
      position.value.first
    else
      position
    end
  end

  def is_url(string)
    if string.is_a?(Sass::Script::Value::String)
      is_url = !!(string.value =~ /^url\(.*\)$/)
      bool(is_url)
    else
      bool(false)
    end
  end
end
