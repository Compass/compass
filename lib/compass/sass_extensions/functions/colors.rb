module Compass::SassExtensions::Functions::Colors

  # a genericized version of lighten/darken so that negative values can be used.
  def adjust_lightness(color, amount)
    assert_type color, :Color
    assert_type amount, :Number
    color.with(:lightness => Compass::Util.restrict(color.lightness + amount.value, 0..100))
  end

  # Scales a color's lightness by some percentage.
  # If the amount is negative, the color is scaled darker, if positive, it is scaled lighter.
  # This will never return a pure light or dark color unless the amount is 100%.
  def scale_lightness(color, amount)
    assert_type color, :Color
    assert_type amount, :Number
    color.with(:lightness => scale_color_value(color.lightness, amount.value))
  end

  # a genericized version of saturation/desaturate so that negative values can be used.
  def adjust_saturation(color, amount)
    assert_type color, :Color
    assert_type amount, :Number
    color.with(:saturation => Compass::Util.restrict(color.saturation + amount.value, 0..100))
  end

  # Scales a color's saturation by some percentage.
  # If the amount is negative, the color is desaturated, if positive, it is saturated.
  # This will never return a pure saturated or desaturated color unless the amount is 100%.
  def scale_saturation(color, amount)
    assert_type color, :Color
    assert_type amount, :Number
    color.with(:saturation => scale_color_value(color.saturation, amount.value))
  end

  def shade(color, percentage)
    assert_type color, :Color
    assert_type percentage, :Number
    black = Sass::Script::Color.new([0, 0, 0])
    mix(black, color, percentage)
  end

  def tint(color, percentage)
    assert_type color, :Color
    assert_type percentage, :Number
    white = Sass::Script::Color.new([255, 255, 255])
    mix(white, color, percentage)
  end

  # returns an IE hex string for a color with an alpha channel
  # suitable for passing to IE filters.
  def ie_hex_str(color)
    assert_type color, :Color
    alpha = (color.alpha * 255).round
    alphastr = alpha.to_s(16).rjust(2, '0')
    Sass::Script::String.new("##{alphastr}#{color.send(:hex_str)[1..-1]}".upcase)
  end
  
  private
  def scale_color_value(value, amount)
    if amount > 0
      value += (100 - value) * (amount / 100.0)
    elsif amount < 0
      value += value * amount / 100.0
    end
    value
  end
end
