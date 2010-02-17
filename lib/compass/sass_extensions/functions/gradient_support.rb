module Compass::SassExtensions::Functions::GradientSupport

  class List < Sass::Script::Literal
    attr_accessor :values
    def initialize(*values)
      self.values = values
    end
    def inspect
      to_s
    end
    def to_s
      values.map{|v| v.to_s}.join(", ")
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
      s = "#{color}"
      if stop
        s << " "
        s << stop.times(Sass::Script::Number.new(100)).to_s
        s << "%"
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
        else
          raise Sass::SyntaxError, "Cannot determine the opposite of #{pos}"
        end
      end
      Sass::Script::String.new(opposite.join(" "))
    end

    # returns color-stop() calls for use in webkit.
    def grad_color_stops(color_list)
      positions = color_list.values.map{|c| [c.stop && c.stop.value, c.color]}
      # fill in the blank positions
      positions[0][0] = 0 unless positions.first.first
      positions[positions.size - 1][0] = 1 unless positions.last.first
      for i in 0...positions.size
        if positions[i].first.nil?
          num = 2.0
          for j in (i+1)...positions.size
            if positions[j].first
              positions[i][0] = positions[i-1].first + (positions[j].first - positions[i-1].first) / num
              break
            else
              num += 1
            end
          end
        end
      end
      positions = positions[1..-1] if positions.first.first == 0.0
      positions = positions[0..-2] if positions.last.first == 1.0
      if positions.empty?
        # We return false here since sass has no nil.
        Sass::Script::Bool.new(false)
      else
        color_stops = positions.map {|pos| "color-stop(#{Sass::Script::Number.new((pos.first*10000).round/100.0).to_s}%, #{pos.last})"}
        Sass::Script::String.new(color_stops.join(", "))
      end
    end

    # the first color from a list of color stops
    def grad_start_color(color_list)
      color_list.values.first.color
    end

    # the last color from a list of color stops
    def grad_end_color(color_list)
      color_list.values.last.color
    end

    # the given a position, return a point in percents
    def grad_point(position)
      position = position.value
      position = if position[" "]
        if position =~ /(top|bottom) (left|right)/
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
        end
      end
      Sass::Script::String.new position.gsub(/top/, "0%").gsub(/bottom/, "100%").gsub(/left/,"0%").gsub(/right/,"100%")
    end

    def color_stops(*args)
      List.new(*args.map do |arg|
        case arg
        when Sass::Script::Color
          ColorStop.new(arg)
        when Sass::Script::String
          color, stop = arg.value.split(/ +/, 2)
          color = Sass::Script::Parser.parse(color, 0, 0)
          if stop =~ /^(\d+)?(?:\.(\d+))?(%)?$/
            integral, decimal, percent = $1, $2, $3
            number = "#{integral || 0}.#{decimal || 0}".to_f
            number = number / 100 if percent
            if number > 1
              raise Sass::SyntaxError, "A color stop location must be between 0#{"%" if percent} and 1#{"00%" if percent}. Got: #{stop}"
            end
            stop = Sass::Script::Number.new(number)
          elsif !stop.nil?
            raise Sass::SyntaxError, "A color stop location must be between 0 and 1 or 0% and 100%. Got: #{stop}"          
          end
          ColorStop.new(color, stop)
        else
          raise Sass::SyntaxError, "Not a valid color stop: #{arg}"          
        end
      end)
    end
  end
end
