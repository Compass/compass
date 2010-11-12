module Compass::SassExtensions::Functions::Trig

  def pi()
    Sass::Script::Number.new(Math::PI)
  end

  def sin(number)
    trig(:sin, number)
  end

  def cos(number)
    trig(:cos, number)
  end

  def tan(number)
    trig(:tan, number)
  end
  
  private
  def trig(operation, number)
    if number.numerator_units == ["deg"] && number.denominator_units == []
      Sass::Script::Number.new(Math.send(operation, Math::PI * number.value / 360))
    else
      Sass::Script::Number.new(Math.send(operation, number.value), number.numerator_units, number.denominator_units)
    end
  end
end
