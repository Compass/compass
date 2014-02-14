module Compass::Core::SassExtensions::Functions::GradientSupport

  GRADIENT_ASPECTS = %w(webkit moz svg css2 o owg).freeze

  class ColorStop < Sass::Script::Value::Base
    include Sass::Script::Value::Helpers
    attr_accessor :color, :stop
    def children
      [color, stop].compact
    end
    def initialize(color, stop = nil)
      assert_legal_color! color
      assert_legal_color_stop! stop if stop
      self.color, self.stop = color, stop
    end
    def inspect
      to_s
    end

    def assert_legal_color!(color)
      unless Sass::Script::Value::Color === color ||
             Sass::Script::Tree::Funcall === color ||
             (Sass::Script::Value::String === color && color.value == "currentColor")||
             (Sass::Script::Value::String === color && color.value == "transparent")
        raise Sass::SyntaxError, "Expected a color. Got: #{color}"
      end
    end
    def assert_legal_color_stop!(stop)
      case stop
      when Sass::Script::Value::String
        return stop.value.start_with?("calc(")
      when Sass::Script::Value::Number
        return true
      end
      raise Sass::SyntaxError, "Expected a number or numerical expression. Got: #{stop.inspect}"
    end

    def self.color_to_svg_s(c)
      # svg doesn't support the "transparent" keyword; we need to manually
      # refactor it into "transparent black"
      if c.is_a?(Sass::Script::Value::String) && c.value == "transparent"
        "black"
      elsif c.is_a?(Sass::Script::Value::String)
        c.value.dup
      else
        self.color_to_s(c.with(:alpha => 1))
      end
    end

    def self.color_to_svg_alpha(c)
      # svg doesn't support the "transparent" keyword; we need to manually
      # refactor it into "transparent black"
      if c.is_a?(Sass::Script::Value::String) && c.value == "transparent"
        0
      elsif c.is_a?(Sass::Script::Value::String) && c.value == "currentColor"
        1
      else
        c.alpha
      end
    end

    def self.color_to_s(c)
      if c.is_a?(Sass::Script::Value::String)
        c.value.dup
      else
        c.inspect.dup
      end
    end

    def to_s(options = self.options)
      s = self.class.color_to_s(color)
      if stop
        s << " "
        if stop.respond_to?(:unitless?) && stop.unitless?
          s << stop.times(number(100, "%")).inspect
        else
          s << stop.to_s
        end
      end
      s
    end

    def to_sass(options = nil)
      identifier("color-stop(#{color.to_sass rescue nil}, #{stop.to_sass rescue nil})")
    end
  end

  module Gradient
    include Sass::Script::Value::Helpers

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def standardized_prefix(prefix)
        class_eval %Q{
          def to_#{prefix}(options = self.options)
            identifier("-#{prefix}-\#{to_s_prefixed(options)}")
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

    def is_position(pos)
      pos.value =~ Compass::Core::SassExtensions::Functions::Constants::POSITIONS
    end

    def angle?(value)
      value.is_a?(Sass::Script::Value::Number) &&
      value.numerator_units.size == 1 &&
      value.numerator_units.first == "deg" &&
      value.denominator_units.empty?
    end

  end

  class RadialGradient < Sass::Script::Value::Base
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

    def to_s_prefixed(options = self.options)
      to_s(options)
    end
    
    standardized_prefix :webkit
    standardized_prefix :moz
    standardized_prefix :o

    def to_svg(options = self.options)
      # XXX Add shape support if possible
      radial_svg_gradient(color_stops, position || _center_position)
    end

    def to_css2(options = self.options)
      null
    end
  end

  class LinearGradient < Sass::Script::Value::Base
    include Gradient

    attr_accessor :color_stops, :position_or_angle, :legacy

    def children
      [color_stops, position_or_angle].compact
    end

    def initialize(position_or_angle, color_stops, legacy=false)
      unless color_stops.value.size >= 2
        raise Sass::SyntaxError, "At least two color stops are required for a linear-gradient"
      end
      self.position_or_angle = position_or_angle
      self.color_stops = color_stops
      self.legacy = legacy
    end

    def to_s_prefixed(options = self.options)
      s = "linear-gradient("
      if legacy
        s << position_or_angle.to_s(options) << ", " if position_or_angle
      else
        s << convert_to_or_from_legacy(position_or_angle, options) << ", " if position_or_angle
      end
      s << color_stops.to_s(options)
      s << ")"
    end

    def convert_to_or_from_legacy(position_or_angle, options = self.options)
      input = if position_or_angle.is_a?(Sass::Script::Value::Number)
          position_or_angle
        else
          opts(list(position_or_angle.to_s.split(' ').map {|s| identifier(s) }, :space))
        end
      return convert_angle_from_offical(input).to_s(options)
    end

    def to_s(options = self.options)
      s = 'linear-gradient('
      if legacy
        s << convert_to_or_from_legacy(position_or_angle, options) << ", " if position_or_angle
      else
        s << position_or_angle.to_s(options) << ", " if position_or_angle
      end
      s << color_stops.to_s(options)
      s << ")"
    end

    standardized_prefix :webkit
    standardized_prefix :moz
    standardized_prefix :o

    def supports?(aspect)
      # I don't know how to support degree-based gradients in old webkit gradients (owg) or svg so we just disable them.
      if %w(owg svg).include?(aspect) && position_or_angle.is_a?(Sass::Script::Value::Number) && position_or_angle.numerator_units.include?("deg")
        false
      elsif aspect == "svg" && color_stops.value.any?{|cs| cs.stop.is_a?(Sass::Script::Value::String) }
        # calc expressions cannot be represented in svg
        false
      else
        super
      end
    end

    def to_svg(options = self.options)
      linear_svg_gradient(color_stops, position_or_angle || identifier("top"))
    end

    def to_css2(options = self.options)
      null
    end
  end

  module Functions
    include Sass::Script::Value::Helpers

    def convert_angle_from_offical(deg)
      if deg.is_a?(Sass::Script::Value::Number)
        return number((deg.value.to_f - 450).abs % 360, 'deg')
      else
        args = deg.value
        direction = []
        if args[0] == identifier('to')
          if args.size < 2
            direction = args
          else
            direction << opposite_position(args[1])
          end
        else
          direction << identifier('to')
          args.each do |pos|
            direction << opposite_position(pos)
          end
        end
        return opts(list(direction, :space))
      end
    end

    # given a position list, return a corresponding position in percents
    # otherwise, returns the original argument
    def grad_point(position)
      original_value = position
      position = unless position.is_a?(Sass::Script::Value::List)
        opts(list([position], :space))
      else
        opts(list(position.value.dup, position.separator))
      end
      # Handle unknown arguments by passing them along untouched.
      unless position.value.all?{|p| is_position(p) }
        return original_value
      end
      if (position.value.first.value =~ /top|bottom/) or (position.value.last.value =~ /left|right/)
        # browsers are pretty forgiving of reversed positions so we are too.
        position = opts(list(position.value.reverse, position.separator))
      end
      if position.value.size == 1
        if position.value.first.value =~ /top|bottom/
          position = opts(list(identifier("center"), position.value.first, position.separator))
        elsif position.value.first.value =~ /left|right/
          position = opts(list(position.value.first, identifier("center"), position.separator))
        end
      end
      position = opts(list(position.value.map do |p|
        case p.value
        when /top|left/
          number(0, "%")
        when /bottom|right/
          number(100, "%")
        when /center/
          number(50, "%")
        else
          p
        end
      end, position.separator))
      position
    end

    def color_stops(*args)
      opts(list(args.map do |arg|
        if ColorStop === arg
          arg
        elsif Sass::Script::Value::Color === arg
          ColorStop.new(arg)
        elsif Sass::Script::Value::List === arg
          ColorStop.new(*arg.value)
        elsif Sass::Script::Value::String === arg && arg.value == "transparent"
          ColorStop.new(arg)
        elsif Sass::Script::Value::String === arg && arg.value == "currentColor"
          ColorStop.new(arg)
        else
          raise Sass::SyntaxError, "Not a valid color stop: #{arg.class.name}: #{arg}"
        end
      end, :comma))
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

    def _build_linear_gradient(position_or_angle, *color_stops)
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
      return [position_or_angle, color_stops]
    end

    def _linear_gradient(position_or_angle, *color_stops)
      position_or_angle, color_stops = _build_linear_gradient(position_or_angle, *color_stops)
      LinearGradient.new(position_or_angle, send(:color_stops, *color_stops))
    end

    def _linear_gradient_legacy(position_or_angle, *color_stops)
      position_or_angle, color_stops = _build_linear_gradient(position_or_angle, *color_stops)
      LinearGradient.new(position_or_angle, send(:color_stops, *color_stops), true)
    end

    # returns color-stop() calls for use in webkit.
    def grad_color_stops(color_list)
      stops = color_stops_in_percentages(color_list).map do |stop, color|
        "color-stop(#{stop.inspect}, #{ColorStop.color_to_s(color)})"
      end
      opts(list(stops, :comma))
    end

    def color_stops_in_percentages(color_list)
      assert_type color_list, :List
      color_list = normalize_stops(color_list)
      max = color_list.value.last.stop
      last_value = nil
      color_list.value.map do |pos|
        next [pos.stop, pos.color] if pos.stop.is_a?(Sass::Script::Value::String)
        # have to convert absolute units to percentages for use in color stop functions.
        stop = pos.stop
        stop = stop.div(max).times(number(100, "%")) if stop.numerator_units == max.numerator_units && max.numerator_units != ["%"]
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
      start_point = grad_point(position_or_angle || identifier("top"))
      end_point = grad_point(opposite_position(position_or_angle || identifier("top")))
      end_target = color_list.value.last.stop

      if color_list.value.last.stop && color_list.value.last.stop.numerator_units == ["px"]
        new_end = color_list.value.last.stop.value
        if start_point.value.first == end_point.value.first && start_point.value.last.value == 0
          # this means top-to-bottom
          end_point.value[1] = number(end_target.value)
        elsif start_point.value.last == end_point.value.last && start_point.value.first.value == 0
          # this implies left-to-right
          end_point.value[0] = number(end_target.value)
        end
      end
      end_point
    end

    # returns the end position of the gradient from the color stop
    def grad_end_position(color_list, radial = bool(false))
      assert_type color_list, :List
      default = number(100)
      grad_position(color_list, number(color_list.value.size), default, radial)
    end

    def grad_position(color_list, index, default, radial = bool(false))
      assert_type color_list, :List
      stop = color_list.value[index.value - 1].stop
      if stop && radial.to_bool
        orig_stop = stop
        if stop.unitless?
          if stop.value <= 1
            # A unitless number is assumed to be a percentage when it's between 0 and 1
            stop = stop.times(number(100, "%"))
          else
            # Otherwise, a unitless number is assumed to be in pixels
            stop = stop.times(number(1, "px"))
          end
        end
        if stop.numerator_units == ["%"] && color_list.value.last.stop && color_list.value.last.stop.numerator_units == ["px"]
          stop = stop.times(color_list.value.last.stop).div(number(100, "%"))
        end
        Compass::Logger.new.record(:warning, "Webkit only supports pixels for the start and end stops for radial gradients. Got: #{orig_stop}") if stop.numerator_units != ["px"]
        stop.div(Sass::Script::Value::Number.new(1, stop.numerator_units, stop.denominator_units))
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
      r = grad_end_position(color_stops,  bool(true))
      stops = color_stops_in_percentages(color_stops)

      svg = radial_svg(stops, cx, cy, r)
      inline_image_string(svg.gsub(/\s+/, ' '), 'image/svg+xml')
    end

    private

    def color_stop?(arg)
      arg.is_a?(ColorStop) ||
      (arg.is_a?(Sass::Script::Value::List) && ColorStop.new(*arg.value)) ||
      ColorStop.new(arg)
    rescue
      nil
    end

    def normalize_stops(color_list)
      positions = color_list.value.map{|obj| obj.dup}
      # fill in the start and end positions, if unspecified
      positions.first.stop = number(0) unless positions.first.stop
      positions.last.stop = number(100, "%") unless positions.last.stop
      # fill in empty values
      for i in 0...positions.size
        if positions[i].stop.nil?
          num = 2.0
          for j in (i+1)...positions.size
            if positions[j].stop
              positions[i].stop = positions[i-1].stop.plus((positions[j].stop.minus(positions[i-1].stop)).div(number(num)))
              break
            else
              num += 1
            end
          end
        end
      end
      # normalize unitless numbers
      positions.each do |pos|
        next pos if pos.stop.is_a?(Sass::Script::Value::String)
        if pos.stop.unitless? && pos.stop.value <= 1
          pos.stop = pos.stop.times(number(100, "%"))
        elsif pos.stop.unitless?
          pos.stop = pos.stop.times(number(1, "px"))
        end
      end
      if (positions.last.stop.eq(number(0, "px")).to_bool ||
         positions.last.stop.eq(number(0, "%")).to_bool)
         raise Sass::SyntaxError.new("Color stops must be specified in increasing order")
       end
       opts(list(positions, color_list.separator))
    end

    def parse_color_stop(arg)
      return ColorStop.new(arg) if arg.is_a?(Sass::Script::Value::Color)
      return nil unless arg.is_a?(Sass::Script::Value::String)
      color = stop = nil
      expr = Sass::Script::Parser.parse(arg.value, 0, 0)
      case expr
      when Sass::Script::Value::Color
        color = expr
      when Sass::Script::Tree::Funcall
        color = expr
      when Sass::Script::Tree::Operation
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
      gradient = %Q{<radialGradient id="grad" gradientUnits="userSpaceOnUse" cx="#{cx}" cy="#{cy}" r="#{r}%">#{color_stops_svg(color_stops)}</radialGradient>}
      svg(gradient)
    end

    # color_stops = array of: [stop, color]
    def color_stops_svg(color_stops)
      color_stops.each.map{ |stop, color|
        s = %{<stop offset="#{stop.to_s}"}
        s << %{ stop-color="#{ColorStop.color_to_svg_s(color)}"}
        alpha = ColorStop.color_to_svg_alpha(color)
        s << %{ stop-opacity="#{alpha}"} if alpha != 1
        s << "/>"
      }.join
    end

    def svg(gradient)
      svg = <<-EOS
<?xml version="1.0" encoding="utf-8"?>
<svg version="1.1" xmlns="http://www.w3.org/2000/svg"><defs>#{gradient}</defs><rect x="0" y="0" width="100%" height="100%" fill="url(#grad)" /></svg>
EOS
    end

    def _center_position
      opts(list(identifier("center"), identifier("center"), :space))
    end

    def opts(v)
      v.options = options
      v
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

  class LinearGradient < Sass::Script::Value::Base
    include Assertions
    include Functions
    include Compass::Core::SassExtensions::Functions::Constants
    include Compass::Core::SassExtensions::Functions::InlineImage
  end

  class RadialGradient < Sass::Script::Value::Base
    include Assertions
    include Functions
    include Compass::Core::SassExtensions::Functions::Constants
    include Compass::Core::SassExtensions::Functions::InlineImage
  end
end
