module Compass::SassExtensions::Functions::Math

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

  def e()
    Sass::Script::Number.new(Math::E)
  end

  def log(number, base = Sass::Script::Number.new(Math::E))
    assert_type number, :Number
    assert_type base, :Number
    Sass::Script::Number.new(Math.log(number.value, base.value), number.numerator_units, number.denominator_units)
  end

  def sqrt(number)
    numeric_transformation(number) { |n| Math.sqrt(n) }
  end

  def pow(number, exponent)
    assert_type number, :Number
    assert_type exponent, :Number
    Sass::Script::Number.new(number.value**exponent.value, number.numerator_units, number.denominator_units)
  end

  private
  def trig(operation, number)
    if number.numerator_units == ["deg"] && number.denominator_units == []
      Sass::Script::Number.new(Math.send(operation, Math::PI * number.value / 180))
    else
      Sass::Script::Number.new(Math.send(operation, number.value), number.numerator_units, number.denominator_units)
    end
  end
end
