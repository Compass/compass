module Compass::SassExtensions::Functions::Constants
  if defined?(Sass::Script::List)
    POSITIONS = /top|bottom|left|right|center/
    def is_position(position)
      Sass::Script::Bool.new(position.is_a?(Sass::Script::String) && !!(position.value =~ POSITIONS))
    end
    def is_position_list(position_list)
      Sass::Script::Bool.new(position_list.is_a?(Sass::Script::List) && position_list.value.all?{|p| is_position(p).to_bool})
    end
    # returns the opposite position of a side or corner.
    def opposite_position(position)
      position = unless position.is_a?(Sass::Script::List)
        Sass::Script::List.new([position], :space)
      else
        Sass::Script::List.new(position.value.dup, position.separator)
      end
      position.value.map! do |pos|
        if pos.is_a? Sass::Script::String
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
          Sass::Script::String.new(opposite)
        elsif pos.is_a? Sass::Script::Number
          if pos.numerator_units == ["%"] && pos.denominator_units == []
            Sass::Script::Number.new(100-pos.value, ["%"])
          else
            Compass::Util.compass_warn("Cannot determine the opposite position of: #{pos}")
            pos
          end
        else
          Compass::Util.compass_warn("Cannot determine the opposite position of: #{pos}")
          pos
        end
      end
      if position.value.size == 1
        position.value.first
      else
        position
      end
    end

    def is_url(string)
      if string.is_a?(Sass::Script::String)
        is_url = !!(string.value =~ /^url\(.*\)$/)
        Sass::Script::Bool.new(is_url)
      else
        Sass::Script::Bool.new(false)
      end
    end
  else
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
          pos
        end
      end
      Sass::Script::String.new(opposite.join(" "), position.type)
    end
  end
end
