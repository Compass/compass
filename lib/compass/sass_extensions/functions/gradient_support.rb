module Compass::SassExtensions::Functions::GradientSupport

  class List < Sass::Script::Literal
    attr_accessor :values
    def initialize(*values)
      self.values = values
    end
    def join_with
      ", "
    end
    def inspect
      to_s
    end
    def to_s
      values.map {|v| v.to_s }.join(join_with)
    end
  end

  class SpaceList < List
    def join_with
      " "
    end
  end

  class ColorStop < Sass::Script::Literal
    attr_accessor :color, :stop
    def initialize(color, stop = nil)
      unless Sass::Script::Color === color || Sass::Script::Funcall === color
        raise Sass::SyntaxError, "Expected a color. Got: #{color}"
      end
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

  class RadialGradient < Sass::Script::Literal
    attr_accessor :position_or_angle, :shape_or_size, :color_stops
    def initialize(position_or_angle, shape_or_size, color_stops)
      unless color_stops.values.size >= 2
        raise Sass::SyntaxError, "At least two color stops are required for a radial-gradient"
      end
      self.position_or_angle = position_or_angle
      self.shape_or_size = shape_or_size
      self.color_stops = color_stops
    end
    def inspect
      to_s
    end
    def to_s
      s = "radial-gradient("
      s << position_or_angle.to_s << ", " if position_or_angle
      s << shape_or_size.to_s << ", " if shape_or_size
      s << color_stops.to_s
      s << ")"
    end
    def to_webkit
      args = [
        grad_point(position_or_angle || Sass::Script::String.new("center center")),
        "0",
        grad_point(position_or_angle || Sass::Script::String.new("center center")),
        grad_end_position(color_stops, Sass::Script::Bool.new(true)),
        grad_color_stops(color_stops)
      ]
      Sass::Script::String.new("-webkit-gradient(radial, #{args.join(', ')})")

    end
    def to_moz
      Sass::Script::String.new("-moz-#{to_s}")
    end
    def to_svg
      # XXX Add shape support if possible
      radial_svg_gradient(color_stops, position_or_angle || Sass::Script::String.new("center center"))
    end
  end

  class LinearGradient < Sass::Script::Literal
    attr_accessor :color_stops, :position_or_angle
    def initialize(position_or_angle, color_stops)
      unless color_stops.values.size >= 2
        raise Sass::SyntaxError, "At least two color stops are required for a linear-gradient"
      end
      self.position_or_angle = position_or_angle
      self.color_stops = color_stops
    end
    def inspect
      to_s
    end
    def to_s
      s = "linear-gradient("
      s << position_or_angle.to_s << ", " if position_or_angle
      s << color_stops.to_s
      s << ")"
    end
    def to_webkit
      args = []
      args << grad_point(position_or_angle || Sass::Script::String.new("top"))
      args << grad_point(opposite_position(position_or_angle || Sass::Script::String.new("top")))
      args << grad_color_stops(color_stops)
      Sass::Script::String.new("-webkit-gradient(linear, #{args.join(', ')})")
    end
    def to_moz
      Sass::Script::String.new("-moz-#{to_s}")
    end
    def to_svg
      linear_svg_gradient(color_stops, position_or_angle || Sass::Script::String.new("top"))
    end
  end

  module Functions

    def radial_gradient(position_or_angle, shape_or_size, *color_stops)
      if color_stop?(shape_or_size)
        color_stops.unshift(shape_or_size)
        shape_or_size = nil
      end
      if color_stop?(position_or_angle)
        color_stops.unshift(position_or_angle)
        position_or_angle = nil
      end
      RadialGradient.new(position_or_angle, shape_or_size, send(:color_stops, *color_stops))
    end

    def linear_gradient(position_or_angle, *color_stops)
      if color_stop?(position_or_angle)
        color_stops.unshift(position_or_angle)
        position_or_angle = nil
      end
      LinearGradient.new(position_or_angle, send(:color_stops, *color_stops))
    end

    # returns color-stop() calls for use in webkit.
    def grad_color_stops(color_list)
      stops = color_stops_in_percentages(color_list).map do |stop, color|
        "color-stop(#{stop.inspect}, #{color.inspect})"
      end
      Sass::Script::String.new(stops.join(", "))
    end

    def color_stops_in_percentages(color_list)
      assert_list(color_list)
      normalize_stops!(color_list)
      max = color_list.values.last.stop
      last_value = nil
      color_stops = color_list.values.map do |pos|
        # have to convert absolute units to percentages for use in color stop functions.
        stop = pos.stop
        stop = stop.div(max).times(Sass::Script::Number.new(100,["%"])) if stop.numerator_units == max.numerator_units && max.numerator_units != ["%"]
        # Make sure the color stops are specified in the right order.
        if last_value && last_value.value > stop.value
          raise Sass::SyntaxError.new("Color stops must be specified in increasing order")
        end
        last_value = stop
        [stop, pos.color]
      end
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
          "center #{position}"
        when /left|right/
          "#{position} center"
        when /center/
          "center center"
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
          parse_color_stop(arg)
        else
          raise Sass::SyntaxError, "Not a valid color stop: #{arg}"
        end
      end)
    end

    def linear_svg_gradient(color_stops, start)
      x1, y1 = grad_point(start).to_s.split
      x2, y2 = grad_point(opposite_position(start)).to_s.split
      stops = color_stops_in_percentages(color_stops)

      svg = linear_svg(stops, x1, y1, x2, y2)
      inline_image_string(svg.gsub(/\s+/, ' '), 'image/svg+xml')
    end

    def radial_svg_gradient(color_stops, center)
      cx, cy = grad_point(center).to_s.split
      r = grad_end_position(color_stops,  Sass::Script::Bool.new(true))
      stops = color_stops_in_percentages(color_stops)

      svg = radial_svg(stops, cx, cy, r)
      inline_image_string(svg.gsub(/\s+/, ' '), 'image/svg+xml')
    end

    # Returns a comma-delimited list after removing any non-true values
    def compact(*args)
      List.new(*args.reject{|a| !a.to_bool})
    end

    # Returns a list object from a value that was passed.
    # This can be used to unpack a space separated list that got turned
    # into a string by sass before it was passed to a mixin.
    def _compass_list(arg)
      return arg if arg.is_a?(List)
      values = case arg
        when Sass::Script::String
          expr = Sass::Script::Parser.parse(arg.value, 0, 0)
          if expr.is_a?(Sass::Script::Operation)
            extract_list_values(expr)
          elsif expr.is_a?(Sass::Script::Funcall)
            expr.perform(Sass::Environment.new) #we already evaluated the args in context so no harm in using a fake env
          else
            [arg]
          end
        else
          [arg]
        end

      SpaceList.new(*values)
    end

    # Get the nth value from a list
    def _compass_nth(list, place)
      if place.value == "last"
        list.values.last
      elsif place.value == "first"
        list.values.first
      else
        list.values[place.value - 1]
      end
    end

    # slice a sublist from a list
    def _compass_slice(list, start_index, end_index = nil)
      end_index ||= Sass::Script::Number.new(-1)
      start_index = start_index.value
      end_index = end_index.value
      start_index -= 1 unless start_index < 0
      end_index -= 1 unless end_index < 0
      list.class.new *list.values[start_index..end_index]
    end

    %w(webkit moz o ms svg).each do |prefix|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def _#{prefix}(*args)
          args.map!{|a| a.is_a?(List) ? a.values : a}.flatten!
          List.new(*args.map!{|a| a.respond_to?(:to_#{prefix}) ? a.to_#{prefix} : a})
      end
      RUBY
    end

    # Check if any of the arguments passed have a tendency towards vendor prefixing.
    def prefixed(prefix, *args)
      method = prefix.value.sub(/^-/,"to_").to_sym
      args.map!{|a| a.is_a?(List) ? a.values : a}.flatten!
      Sass::Script::Bool.new(args.any?{|a| a.respond_to?(method)})
    end

    private
    # After using the sass script parser to parse a string, this reconstructs
    # a list from operands to the space/concat operation
    def extract_list_values(operation)
      left = operation.instance_variable_get("@operand1")
      right = operation.instance_variable_get("@operand2")
      left = extract_list_values(left) if left.is_a?(Sass::Script::Operation)
      right = extract_list_values(right) if right.is_a?(Sass::Script::Operation)
      left = literalize(left) unless left.is_a?(Array)
      right = literalize(right) unless right.is_a?(Array)
      Array(left) + Array(right)
    end
    # Makes a literal from other various script nodes.
    def literalize(node)
      case node
      when Sass::Script::Literal
        node
      when Sass::Script::Funcall
        node.perform(Sass::Environment.new)
      else
        Sass::Script::String.new(node.to_s)
      end
    end
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

    def parse_color_stop(arg)
      return ColorStop.new(arg) if arg.is_a?(Sass::Script::Color)
      return nil unless arg.is_a?(Sass::Script::String)
      color = stop = nil
      expr = Sass::Script::Parser.parse(arg.value, 0, 0)
      case expr
      when Sass::Script::Color
        color = expr
      when Sass::Script::Funcall
        color = expr
      when Sass::Script::Operation
        unless [:concat, :space].include?(expr.instance_variable_get("@operator"))
          # This should never happen.
          raise Sass::SyntaxError, "Couldn't parse a color stop from: #{arg.value}"
        end
        color = expr.instance_variable_get("@operand1")
        stop = expr.instance_variable_get("@operand2")
      else
        raise Sass::SyntaxError, "Couldn't parse a color stop from: #{arg.value}"
      end
      ColorStop.new(color, stop)
    end

    def color_stop?(arg)
      parse_color_stop(arg)
    rescue
      nil
    end

    def linear_svg(color_stops, x1, y1, x2, y2)
      gradient = %Q{<linearGradient id="grad" x1="#{x1}" y1="#{y1}" x2="#{x2}" y2="#{y2}">#{color_stops_svg(color_stops)}</linearGradient>}
      svg(gradient)
    end

    def radial_svg(color_stops, cx, cy, r)
      gradient = %Q{<radialGradient id="grad" gradientUnits="userSpaceOnUse" cx="#{cx}" cy="#{cy}" r="#{r}">#{color_stops_svg(color_stops)}</radialGradient>}
      svg(gradient)
    end

    # color_stops = array of: [stop, color]
    def color_stops_svg(color_stops)
      color_stops.each.map{ |stop, color|
          %{<stop offset="#{stop.to_s}" stop-color="#{color.inspect}"/>}
      }.join
    end

    def svg(gradient)
      svg = <<-EOS
<?xml version="1.0" encoding="utf-8"?>
<svg version="1.1" xmlns="http://www.w3.org/2000/svg"><defs>#{gradient}</defs><rect x="0" y="0" width="100%" height="100%" fill="url(#grad)" /></svg>
EOS
    end
  end
  class LinearGradient < Sass::Script::Literal
    include Functions
    include Compass::SassExtensions::Functions::Constants
    include Compass::SassExtensions::Functions::InlineImage
  end
  class RadialGradient < Sass::Script::Literal
    include Functions
    include Compass::SassExtensions::Functions::Constants
    include Compass::SassExtensions::Functions::InlineImage
  end
end
