module Compass::Core::SassExtensions::Functions::GradientSupport

  GRADIENT_ASPECTS = %w(webkit moz svg css2 o owg).freeze

  class CSS3AngleToSVGConverter
    include Math

    def initialize(angle)
      @original_angle = angle
      @angle = handle_keywords(angle)
      @angle = in_radians(@angle) % (2 * PI)
      @quadrant = (@angle * 2 / PI).to_i
      @angle = case @quadrant
               when 0
                 @angle
               when 1
                 PI - @angle
               when 2
                 @angle - PI
               when 3
                 2 * PI  - @angle
               end
    end

    TOP    = 1
    BOTTOM = 2
    RIGHT  = 4
    LEFT   = 8

    DIR_KEYWORDS_TO_ANGLE = {
      TOP            => 0,
      TOP    | RIGHT => 45,
               RIGHT => 90,
      BOTTOM | RIGHT => 135,
      BOTTOM         => 180,
      BOTTOM | LEFT  => 225,
               LEFT  => 270,
      TOP    | LEFT  => 315,
    }

    def handle_keywords(angle)
      if angle.is_a?(Sass::Script::Value::List) || angle.is_a?(Sass::Script::Value::String)
        direction = angle.to_sass
        is_end_point = !!/\bto\b/i.match(direction)
        dir = 0
        dir |= TOP if /\btop\b/i.match(direction)
        dir |= BOTTOM if /\bbottom\b/i.match(direction)
        dir |= RIGHT if /\bright\b/i.match(direction)
        dir |= LEFT if /\bleft\b/i.match(direction)
        if (r = DIR_KEYWORDS_TO_ANGLE[dir])
          r += 180 unless is_end_point
          Sass::Script::Value::Number.new(r, %w(deg), [])
        else
          raise Sass::SyntaxError, "Unknown direction: #{angle.to_sass}"
        end
      else
        angle
      end
    end

    def in_radians(angle)
      case angle.unit_str
      when "deg"
        angle.value * PI / 180.0
      when "grad"
        angle.value * PI / 200.0
      when "rad"
        angle.value
      when "turn"
        angle.value * PI * 2
      else
        raise Sass::SyntaxError.new("#{angle.unit_str} is not an angle")
      end
    end

    def sin2(a)
      v = sin(a)
      v * v
    end

    def x
      @x ||= if @angle > 1.570621793869697
               1.0 # avoid floating point rounding error at the asymptote
             else
               tan(@angle) + (1 - tan(@angle)) * sin2(@angle)
             end
    end

    def y
      @y ||= if @angle < 0.0001
               1.0 # the limit of the expression as we approach 0 is 1.
             else
               x / tan(@angle)
             end
    end

    def x1
      result case @quadrant
             when 0, 1
               -x
             when 2, 3
               x
             end
    end

    def y1
      result case @quadrant
             when 0, 3
               y
             when 1, 2
               -y
             end
    end

    def x2
      result case @quadrant
             when 0, 1
               x
             when 2, 3
               -x
             end
    end

    def y2
      result case @quadrant
             when 0, 3
               -y
             when 1, 2
               y
             end
    end

    def scale(p)
      (p + 1) / 2.0
    end

    def round6(v)
      (v * 1_000_000).round / 1_000_000.0
    end

    def result(v)
      round6(scale(v))
    end
  end

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
        class_eval %Q<
          def to_#{prefix}(options = self.options)
            identifier("-#{prefix}-\#{to_s_prefixed(options)}")
          end
        >
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
      to_official.to_s
    end

    def to_s_prefixed(options = self.options)
      to_s(options)
    end

    def supports?(aspect)
      # I don't know how to support radial old webkit gradients (owg)
      if %w(owg).include?(aspect)
        false
      else
        super
      end
    end

    standardized_prefix :webkit
    standardized_prefix :moz

    def to_webkit(options = self.options)
      s = "-webkit-radial-gradient("
      s << old_standard_arguments(options)
      s << ")"
      identifier(s)
    end

    def to_moz(options = self.options)
      s = "-moz-radial-gradient("
      s << old_standard_arguments(options)
      s << ")"
      identifier(s)
    end

    def to_official
      s = "radial-gradient("
      s << new_standard_arguments(options)
      s << ")"
      identifier(s)
    end

    def new_standard_arguments(options = self.options)
      if shape_and_size
        "#{array_to_s(shape_and_size, options)} at #{array_to_s(position, options)}, #{array_to_s(color_stops, options)}"
      elsif position
        "#{array_to_s(position, options)}, #{array_to_s(color_stops, options)}"
      else
        array_to_s(color_stops, options)
      end
    end

    def old_standard_arguments(options = self.options)
      if shape_and_size
        "#{array_to_s(position, options)}, #{array_to_s(shape_and_size, options)}, #{array_to_s(color_stops, options)}"
      elsif position
        "#{array_to_s(position, options)}, #{array_to_s(color_stops, options)}"
      else
        array_to_s(color_stops, options)
      end
    end

    def to_svg(options = self.options)
      # XXX Add shape support if possible
      radial_svg_gradient(color_stops, position || _center_position)
    end

    def to_css2(options = self.options)
      null
    end

    def array_to_s(array, opts)
      if array.is_a?(Sass::Script::Value::List)
        array.to_s
      else
        l = list(array, :space)
        l.options = opts
        l.to_s
      end
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
      if %w(owg).include?(aspect) && position_or_angle.is_a?(Sass::Script::Value::Number) && position_or_angle.numerator_units.include?("deg")
        false
      elsif %w(owg svg).include?(aspect) && color_stops.value.any?{|cs| cs.stop.is_a?(Sass::Script::Value::String) }
        # calc expressions cannot be represented in svg or owg
        false
      else
        super
      end
    end

    # Output the original webkit gradient syntax
    def to_owg(options = self.options)
      position_list = reverse_side_or_corner(position_or_angle)

      start_point = grad_point(position_list)
      args = []
      args << start_point
      args << linear_end_position(position_list, start_point, color_stops.value.last.stop)
      args << grad_color_stops(color_stops)
      args.each{|a| a.options = options}
      Sass::Script::String.new("-webkit-gradient(linear, #{args.join(', ')})")
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

    def reverse_side_or_corner(position)
      position_array = position.nil? ? [identifier('top')] : position.value.dup
      if position_array.first == identifier('to')
        # Remove the 'to' element from the array
        position_array.shift

        # Reverse all the positions
        reversed_position = position_array.map do |pos|
          opposite_position(pos)
        end
      else
        # When the position does not have the 'to' element we don't need to
        # reverse the direction of the gradient
        reversed_position = position_array
      end
      opts(list(reversed_position, :space))
    end

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
      if position_or_angle.is_a?(Sass::Script::Value::List) &&
         (i = position_or_angle.value.index {|word| word.is_a?(Sass::Script::Value::String) && word.value == "at"})
        shape_and_size = list(position_or_angle.value[0..(i-1)], :space)
        shape_and_size.options = options
        position_or_angle = list(position_or_angle.value[(i+1)..-1], :space)
        position_or_angle.options = options
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
        Sass::Script::String.new("color-stop(#{stop.to_s}, #{ColorStop.color_to_s(color)})")
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
    def linear_end_position(position_or_angle, start_point, end_target)
      end_point = grad_point(opposite_position(position_or_angle))

      if end_target && end_target.numerator_units == ["px"]
        if start_point.value.first == end_point.value.first && start_point.value.last.value == 0
          # this means top-to-bottom
          new_end_point = end_point.value.dup
          new_end_point[1] = number(end_target.value)

          end_point = opts(list(new_end_point, end_point.separator))
        elsif start_point.value.last == end_point.value.last && start_point.value.first.value == 0
          # this implies left-to-right

          new_end_point = end_point.value.dup
          new_end_point[0] = number(end_target.value)

          end_point = opts(list(new_end_point, end_point.separator))
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
      converter = CSS3AngleToSVGConverter.new(start)
      stops = color_stops_in_percentages(color_stops)

      svg = linear_svg(stops, converter.x1, converter.y1, converter.x2, converter.y2)
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
      gradient = %Q{<linearGradient id="grad" gradientUnits="objectBoundingBox" x1="#{x1}" y1="#{y1}" x2="#{x2}" y2="#{y2}">#{color_stops_svg(color_stops)}</linearGradient>}
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
