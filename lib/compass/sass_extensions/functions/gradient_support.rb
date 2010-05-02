module Compass::SassExtensions::Functions::GradientSupport

  class List < Sass::Script::Literal
    attr_accessor :values
    def initialize(*values)
      self.values = values
    end
    def inspect
      values.map{|v| v.inspect}.join(", ")
    end
    def to_s
      inspect
    end
  end

  class ColorStop < Sass::Script::Literal
    attr_accessor :color, :stop
    def initialize(color, stop = nil)
      self.color, self.stop = color, stop
    end
    def inspect
      to_s
    end
    def to_s
      s = color.inspect.dup
      if stop
        s << " "
        if stop.unitless?
          s << stop.times(Sass::Script::Number.new(100, ["%"])).inspect
        else
          s << stop.inspect
        end
      end
      s
    end
  end

  module Functions
    # returns the opposite position of a side or corner.
    def grad_opposite_position(position)
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
      Sass::Script::String.new(opposite.join(" "))
    end

    # returns color-stop() calls for use in webkit.
    def grad_color_stops(color_list)
      assert_list(color_list)
      normalize_stops!(color_list)
      max = color_list.values.last.stop
      last_value = nil
      color_stops = color_list.values.map do |pos|
        # have to convert absolute units to percentages for use in color stop functions.
        stop = pos.stop
        stop = stop.div(max).times(Sass::Script::Number.new(100,["%"])) if stop.numerator_units == max.numerator_units
        # Make sure the color stops are specified in the right order.
        if last_value && last_value.value > stop.value
          raise Sass::SyntaxError.new("Color stops must be specified in increasing order")
        end
        last_value = stop
        "color-stop(#{stop.inspect}, #{pos.color.inspect})"
      end
      
      Sass::Script::String.new(color_stops.join(", "))
    end

    # returns the end position of the gradient from the color stop
    def grad_end_position(color_list, radial = Sass::Script::Bool.new(false))
      assert_list(color_list)
      default = Sass::Script::Number.new(100)
      grad_position(color_list, Sass::Script::Number.new(color_list.values.size), default, radial)
    end

    def grad_position(color_list, index, default, radial = Sass::Script::Bool.new(false))
      assert_list(color_list)
      stop = color_list.values[index.value - 1].stop
      if stop && radial.to_bool
        orig_stop = stop
        if stop.unitless?
          if stop.value <= 1
            # A unitless number is assumed to be a percentage when it's between 0 and 1
            stop = stop.times(Sass::Script::Number.new(100, ["%"]))
          else
            # Otherwise, a unitless number is assumed to be in pixels
            stop = stop.times(Sass::Script::Number.new(1, ["px"]))
          end
        end
        if stop.numerator_units == ["%"] && color_list.values.last.stop && color_list.values.last.stop.numerator_units == ["px"]
          stop = stop.times(color_list.values.last.stop).div(Sass::Script::Number.new(100, ["%"]))
        end
        Compass::Logger.new.record(:warning, "Webkit only supports pixels for the start and end stops for radial gradients. Got: #{orig_stop}") if stop.numerator_units != ["px"]
        stop.div(Sass::Script::Number.new(1, stop.numerator_units, stop.denominator_units))
      elsif stop
        stop
      else
        default
      end
    end

    # the given a position, return a point in percents
    def grad_point(position)
      position = position.value
      position = if position[" "]
        if position =~ /(top|bottom|center) (left|right|center)/
          "#{$2} #{$1}"
        else
          position
        end
      else
        case position
        when /top|bottom/
          "left #{position}"
        when /left|right/
          "#{position} top"
        else
          position
        end
      end
      Sass::Script::String.new(position.
        gsub(/top/, "0%").
        gsub(/bottom/, "100%").
        gsub(/left/,"0%").
        gsub(/right/,"100%").
        gsub(/center/, "50%"))
    end

    def color_stops(*args)
      List.new(*args.map do |arg|
        case arg
        when Sass::Script::Color
          ColorStop.new(arg)
        when Sass::Script::String
          # We get a string as the result of concatenation
          # So we have to reparse the expression
          color = stop = nil
          expr = Sass::Script::Parser.parse(arg.value, 0, 0)
          case expr
          when Sass::Script::Color
            color = expr
          when Sass::Script::Funcall
            color = expr
          when Sass::Script::Operation
            unless expr.instance_variable_get("@operator") == :concat
              # This should never happen.
              raise Sass::SyntaxError, "Couldn't parse a color stop from: #{arg.value}"
            end
            color = expr.instance_variable_get("@operand1")
            stop = expr.instance_variable_get("@operand2")
          else
            raise Sass::SyntaxError, "Couldn't parse a color stop from: #{arg.value}"
          end
          ColorStop.new(color, stop)
        else
          raise Sass::SyntaxError, "Not a valid color stop: #{arg}"
        end
      end)
    end
    private
    def normalize_stops!(color_list)
      positions = color_list.values
      # fill in the start and end positions, if unspecified
      positions.first.stop = Sass::Script::Number.new(0) unless positions.first.stop
      positions.last.stop = Sass::Script::Number.new(100, ["%"]) unless positions.last.stop
      # fill in empty values
      for i in 0...positions.size
        if positions[i].stop.nil?
          num = 2.0
          for j in (i+1)...positions.size
            if positions[j].stop
              positions[i].stop = positions[i-1].stop.plus((positions[j].stop.minus(positions[i-1].stop)).div(Sass::Script::Number.new(num)))
              break
            else
              num += 1
            end
          end
        end
      end
      # normalize unitless numbers
      positions.each do |pos|
        if pos.stop.unitless? && pos.stop.value <= 1
          pos.stop = pos.stop.times(Sass::Script::Number.new(100, ["%"]))
        elsif pos.stop.unitless?
          pos.stop = pos.stop.times(Sass::Script::Number.new(1, ["px"]))
        end
      end
      if (positions.last.stop.eq(Sass::Script::Number.new(0, ["px"])).to_bool ||
         positions.last.stop.eq(Sass::Script::Number.new(0, ["%"])).to_bool)
         raise Sass::SyntaxError.new("Color stops must be specified in increasing order")
       end
      nil
    end
    def assert_list(value)
      return if value.is_a?(List)
      raise ArgumentError.new("#{value.inspect} is not a list of color stops. Expected: color_stops(<color> <number>?, ...)")
    end
  end
end
