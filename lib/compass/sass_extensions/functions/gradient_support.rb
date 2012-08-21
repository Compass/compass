module Compass::SassExtensions::Functions::GradientSupport

  GRADIENT_ASPECTS = %w(webkit moz svg pie css2 o owg).freeze

  class ColorStop < Sass::Script::Literal
    attr_accessor :color, :stop
    def children
      [color, stop].compact
    end
    def initialize(color, stop = nil)
      unless Sass::Script::Color === color ||
             Sass::Script::Funcall === color ||
             (Sass::Script::String === color && color.value == "transparent")
        raise Sass::SyntaxError, "Expected a color. Got: #{color}"
      end
      if stop && !stop.is_a?(Sass::Script::Number)
        raise Sass::SyntaxError, "Expected a number. Got: #{stop}"
      end
      self.color, self.stop = color, stop
    end
    def inspect
      to_s
    end
    def self.color_to_s(c)
      if c.is_a?(Sass::Script::String)
        c.value.dup
      else
        c.inspect.dup
      end
    end

    def to_s(options = self.options)
      s = self.class.color_to_s(color)
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

  module Gradient

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def standardized_prefix(prefix)
        class_eval %Q{
          def to_#{prefix}(options = self.options)
            Sass::Script::String.new("-#{prefix}-\#{to_s(options)}")
          end
        }
      end
    end

    def inspect
      to_s
    end

    def supports?(aspect)
      GRADIENT_ASPECTS.include?(aspect)
    end

    def has_aspect?
      true
    end

    def angle?(value)
      value.is_a?(Sass::Script::Number) &&
      value.numerator_units.size == 1 &&
      value.numerator_units.first == "deg" &&
      value.denominator_units.empty?
    end

  end

  class RadialGradient < Sass::Script::Literal
    include Gradient

    attr_accessor :position, :shape_and_size, :color_stops

    def children
      [color_stops, position, shape_and_size].compact
    end

    def initialize(position, shape_and_size, color_stops)
      unless color_stops.value.size >= 2
        raise Sass::SyntaxError, "At least two color stops are required for a radial-gradient"
      end
      if angle?(position)
        raise Sass::SyntaxError, "CSS no longer allows angles in radial-gradients."
      end
      self.position = position
      self.shape_and_size = shape_and_size
      self.color_stops = color_stops
    end

    def to_s(options = self.options)
      s = "radial-gradient("
      s << position.to_s(options) << ", " if position
      s << shape_and_size.to_s(options) << ", " if shape_and_size
      s << color_stops.to_s(options)
      s << ")"
    end
    
    standardized_prefix :webkit
    standardized_prefix :moz
    standardized_prefix :o
    
    def to_owg(options = self.options)
      args = [
        grad_point(position || _center_position),
        Sass::Script::String.new("0"),
        grad_point(position || _center_position),
        grad_end_position(color_stops, Sass::Script::Bool.new(true)),
        grad_color_stops(color_stops)
      ]
      args.each {|a| a.options = options}
      Sass::Script::String.new("-webkit-gradient(radial, #{args.join(', ')})")
    end

    def to_svg(options = self.options)
      # XXX Add shape support if possible
      radial_svg_gradient(color_stops, position || _center_position)
    end

    def to_pie(options = self.options)
      Compass::Logger.new.record(:warning, "PIE does not support radial-gradient.")
      Sass::Script::String.new("-pie-radial-gradient(unsupported)")
    end

    def to_css2(options = self.options)
      Sass::Script::String.new("")
    end
  end

  class LinearGradient < Sass::Script::Literal
    include Gradient

    attr_accessor :color_stops, :position_or_angle

    def children
      [color_stops, position_or_angle].compact
    end

    def initialize(position_or_angle, color_stops)
      unless color_stops.value.size >= 2
        raise Sass::SyntaxError, "At least two color stops are required for a linear-gradient"
      end
      self.position_or_angle = position_or_angle
      self.color_stops = color_stops
    end

    def to_s(options = self.options)
      s = "linear-gradient("
      s << position_or_angle.to_s(options) << ", " if position_or_angle
      s << color_stops.to_s(options)
      s << ")"
    end

    standardized_prefix :webkit
    standardized_prefix :moz
    standardized_prefix :o

    def supports?(aspect)
      # I don't know how to support degree-based gradients in old webkit gradients (owg) or svg so we just disable them.
      if %w(owg svg).include?(aspect) && position_or_angle.is_a?(Sass::Script::Number) && position_or_angle.numerator_units.include?("deg")
        false
      else
        super
      end
    end

    # Output the original webkit gradient syntax
    def to_owg(options = self.options)
      args = []
      args << grad_point(position_or_angle || Sass::Script::String.new("top"))
      args << linear_end_position(position_or_angle, color_stops)
      args << grad_color_stops(color_stops)
      args.each{|a| a.options = options}
      Sass::Script::String.new("-webkit-gradient(linear, #{args.join(', ')})")
    end

    def to_svg(options = self.options)
      linear_svg_gradient(color_stops, position_or_angle || Sass::Script::String.new("top"))
    end

    def to_pie(options = self.options)
      # PIE just uses the standard rep, but the property is prefixed so
      # the presence of this attribute helps flag when to render a special rule.
      Sass::Script::String.new to_s(options)
    end

    def to_css2(options = self.options)
      Sass::Script::String.new("")
    end
  end

  module Functions
    # given a position list, return a corresponding position in percents
    # otherwise, returns the original argument
    def grad_point(position)
      original_value = position
      position = unless position.is_a?(Sass::Script::List)
        Sass::Script::List.new([position], :space)
      else
        Sass::Script::List.new(position.value.dup, position.separator)
      end
      # Handle unknown arguments by passing them along untouched.
      unless position.value.all?{|p| is_position(p).to_bool }
        return original_value
      end
      if (position.value.first.value =~ /top|bottom/) or (position.value.last.value =~ /left|right/)
        # browsers are pretty forgiving of reversed positions so we are too.
        position.value.reverse!
      end
      if position.value.size == 1
        if position.value.first.value =~ /top|bottom/
          position.value.unshift Sass::Script::String.new("center")
        elsif position.value.first.value =~ /left|right/
          position.value.push Sass::Script::String.new("center")
        end
      end
      position.value.map! do |p|
        case p.value
        when /top|left/
          Sass::Script::Number.new(0, ["%"])
        when /bottom|right/
          Sass::Script::Number.new(100, ["%"])
        when /center/
          Sass::Script::Number.new(50, ["%"])
        else
          p
        end
      end
      position
    end

    def color_stops(*args)
      Sass::Script::List.new(args.map do |arg|
        if ColorStop === arg
          arg
        elsif Sass::Script::Color === arg
          ColorStop.new(arg)
        elsif Sass::Script::List === arg
          ColorStop.new(*arg.value)
        elsif Sass::Script::String === arg && arg.value == "transparent"
          ColorStop.new(arg)
        else
          raise Sass::SyntaxError, "Not a valid color stop: #{arg.class.name}: #{arg}"
        end
      end, :comma)
    end

    def radial_gradient(position_or_angle, shape_and_size, *color_stops)
      # Have to deal with variable length/meaning arguments.
      if color_stop?(shape_and_size)
        color_stops.unshift(shape_and_size)
        shape_and_size = nil
      elsif list_of_color_stops?(shape_and_size)
        # Support legacy use of the color-stops() function
        color_stops = shape_and_size.value + color_stops
        shape_and_size = nil
      end
      shape_and_size = nil if shape_and_size && !shape_and_size.to_bool # nil out explictly passed falses
      # ditto for position_or_angle
      if color_stop?(position_or_angle)
        color_stops.unshift(position_or_angle)
        position_or_angle = nil
      elsif list_of_color_stops?(position_or_angle)
        color_stops = position_or_angle.value + color_stops
        position_or_angle = nil
      end
      position_or_angle = nil if position_or_angle && !position_or_angle.to_bool

      # Support legacy use of the color-stops() function
      if color_stops.size == 1 && list_of_color_stops?(color_stops.first)
        color_stops = color_stops.first.value
      end
      RadialGradient.new(position_or_angle, shape_and_size, send(:color_stops, *color_stops))
    end

    def linear_gradient(position_or_angle, *color_stops)
      if color_stop?(position_or_angle)
        color_stops.unshift(position_or_angle)
        position_or_angle = nil
      elsif list_of_color_stops?(position_or_angle)
        color_stops = position_or_angle.value + color_stops
        position_or_angle = nil
      end
      position_or_angle = nil if position_or_angle && !position_or_angle.to_bool

      # Support legacy use of the color-stops() function
      if color_stops.size == 1 && (stops = list_of_color_stops?(color_stops.first))
        color_stops = stops
      end
      LinearGradient.new(position_or_angle, send(:color_stops, *color_stops))
    end

    # returns color-stop() calls for use in webkit.
    def grad_color_stops(color_list)
      stops = color_stops_in_percentages(color_list).map do |stop, color|
        "color-stop(#{stop.inspect}, #{ColorStop.color_to_s(color)})"
      end
      Sass::Script::String.new(stops.join(", "))
    end

    def color_stops_in_percentages(color_list)
      assert_type color_list, :List
      color_list = normalize_stops(color_list)
      max = color_list.value.last.stop
      last_value = nil
      color_stops = color_list.value.map do |pos|
        # have to convert absolute units to percentages for use in color stop functions.
        stop = pos.stop
        stop = stop.div(max).times(Sass::Script::Number.new(100,["%"])) if stop.numerator_units == max.numerator_units && max.numerator_units != ["%"]
        # Make sure the color stops are specified in the right order.
        if last_value && stop.numerator_units == last_value.numerator_units && stop.denominator_units == last_value.denominator_units && (stop.value * 1000).round < (last_value.value * 1000).round
          raise Sass::SyntaxError.new("Color stops must be specified in increasing order. #{stop.value} came after #{last_value.value}.")
        end
        last_value = stop
        [stop, pos.color]
      end
    end

    # only used for webkit
    def linear_end_position(position_or_angle, color_list)
      start_point = grad_point(position_or_angle || Sass::Script::String.new("top"))
      end_point = grad_point(opposite_position(position_or_angle || Sass::Script::String.new("top")))
      end_target = color_list.value.last.stop

      if color_list.value.last.stop && color_list.value.last.stop.numerator_units == ["px"]
        new_end = color_list.value.last.stop.value
        if start_point.value.first == end_point.value.first && start_point.value.last.value == 0
          # this means top-to-bottom
          end_point.value[1] = Sass::Script::Number.new(end_target.value)
        elsif start_point.value.last == end_point.value.last && start_point.value.first.value == 0
          # this implies left-to-right
          end_point.value[0] = Sass::Script::Number.new(end_target.value)
        end
      end
      end_point
    end

    # returns the end position of the gradient from the color stop
    def grad_end_position(color_list, radial = Sass::Script::Bool.new(false))
      assert_type color_list, :List
      default = Sass::Script::Number.new(100)
      grad_position(color_list, Sass::Script::Number.new(color_list.value.size), default, radial)
    end

    def grad_position(color_list, index, default, radial = Sass::Script::Bool.new(false))
      assert_type color_list, :List
      stop = color_list.value[index.value - 1].stop
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
        if stop.numerator_units == ["%"] && color_list.value.last.stop && color_list.value.last.stop.numerator_units == ["px"]
          stop = stop.times(color_list.value.last.stop).div(Sass::Script::Number.new(100, ["%"]))
        end
        Compass::Logger.new.record(:warning, "Webkit only supports pixels for the start and end stops for radial gradients. Got: #{orig_stop}") if stop.numerator_units != ["px"]
        stop.div(Sass::Script::Number.new(1, stop.numerator_units, stop.denominator_units))
      elsif stop
        stop
      else
        default
      end
    end

    def linear_svg_gradient(color_stops, start)
      x1, y1 = *grad_point(start).value
      x2, y2 = *grad_point(opposite_position(start)).value
      stops = color_stops_in_percentages(color_stops)

      svg = linear_svg(stops, x1, y1, x2, y2)
      inline_image_string(svg.gsub(/\s+/, ' '), 'image/svg+xml')
    end

    def radial_svg_gradient(color_stops, center)
      cx, cy = *grad_point(center).value
      r = grad_end_position(color_stops,  Sass::Script::Bool.new(true))
      stops = color_stops_in_percentages(color_stops)

      svg = radial_svg(stops, cx, cy, r)
      inline_image_string(svg.gsub(/\s+/, ' '), 'image/svg+xml')
    end

    private

    def color_stop?(arg)
      arg.is_a?(ColorStop) ||
      (arg.is_a?(Sass::Script::List) && ColorStop.new(*arg.value)) ||
      ColorStop.new(arg)
    rescue
      nil
    end

    def normalize_stops(color_list)
      positions = color_list.value.map{|obj| obj.dup}
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
      if defined?(Sass::Script::List)
        Sass::Script::List.new(positions, color_list.separator)
      else
        color_list.class.new(*positions)
      end
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

    def list_of_color_stops?(arg)
      if arg.respond_to?(:value)
        arg.value.is_a?(Array) && arg.value.all?{|a| color_stop?(a)} ? arg.value : nil
      elsif arg.is_a?(Array)
        arg.all?{|a| color_stop?(a)} ? arg : nil
      end
    end
    
    def linear_svg(color_stops, x1, y1, x2, y2)
      transform = ''
      if angle?(position_or_angle)
        transform = %Q{ gradientTransform = "rotate(#{position_or_angle.value})"}
      end
      gradient = %Q{<linearGradient id="grad" gradientUnits="userSpaceOnUse" x1="#{x1}" y1="#{y1}" x2="#{x2}" y2="#{y2}"#{transform}>#{color_stops_svg(color_stops)}</linearGradient>}
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

    def _center_position
      Sass::Script::List.new([
        Sass::Script::String.new("center"),
        Sass::Script::String.new("center")
      ],:space)
    end

  end

  module Assertions
    def assert_type(value, type, name = nil)
      return if value.is_a?(Sass::Script.const_get(type))
      err = "#{value.inspect} is not a #{type.to_s.downcase}"
      err = "$#{name}: " + err if name
      raise ArgumentError.new(err)
    end
  end

  class LinearGradient < Sass::Script::Literal
    include Assertions
    include Functions
    include Compass::SassExtensions::Functions::Constants
    include Compass::SassExtensions::Functions::InlineImage
  end

  class RadialGradient < Sass::Script::Literal
    include Assertions
    include Functions
    include Compass::SassExtensions::Functions::Constants
    include Compass::SassExtensions::Functions::InlineImage
  end
end
