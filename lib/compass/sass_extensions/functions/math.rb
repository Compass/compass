module Compass::SassExtensions::Functions::Math

  def pi()
    Sass::Script::Number.new(Math::PI)
  end
  Sass::Script::Functions.declare :pi, []

  def sin(number)
    trig(:sin, number)
  end
  Sass::Script::Functions.declare :sin, [:number]

  def cos(number)
    trig(:cos, number)
  end
  Sass::Script::Functions.declare :cos, [:number]

  def tan(number)
    trig(:tan, number)
  end
  Sass::Script::Functions.declare :tan, [:number]

  def e()
    Sass::Script::Number.new(Math::E)
  end
  Sass::Script::Functions.declare :pi, []

  def logarithm(number, base = e )
    assert_type number, :Number
    assert_type base, :Number
    raise Sass::SyntaxError, "base to logarithm must be unitless." unless base.unitless?

    result = Math.log(number.value, base.value) rescue Math.log(number.value) / Math.log(base.value)
    Sass::Script::Number.new(result, number.numerator_units, number.denominator_units)
  end
  Sass::Script::Functions.declare :logarithm, [:number]
  Sass::Script::Functions.declare :logarithm, [:number, :base]

  def sqrt(number)
    numeric_transformation(number) { |n| Math.sqrt(n) }
  end
  Sass::Script::Functions.declare :sqrt, [:number]

  alias square_root sqrt
  Sass::Script::Functions.declare :square_root, [:number]

  def pow(number, exponent)
    assert_type number, :Number
    assert_type exponent, :Number
    raise Sass::SyntaxError, "exponent to pow must be unitless." unless exponent.unitless?
    Sass::Script::Number.new(number.value**exponent.value, number.numerator_units, number.denominator_units)
  end
  Sass::Script::Functions.declare :pow, [:number, :exponent]

  private
  def trig(operation, number)
    if number.numerator_units == ["deg"] && number.denominator_units == []
      Sass::Script::Number.new(Math.send(operation, Math::PI * number.value / 180))
    else
      Sass::Script::Number.new(Math.send(operation, number.value), number.numerator_units, number.denominator_units)
    end
  end
end
