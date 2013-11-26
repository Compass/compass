module Compass::Core::SassExtensions::Functions::Math
  extend Compass::Core::SassExtensions::Functions::SassDeclarationHelper

  PI = Sass::Script::Number.new(Math::PI)
  def pi()
    PI
  end
  declare :pi, []

  def random(*args)
    value = if args.length == 1
      rand(args.pop.value)
    else
      range = (args.first.value..args.last.value).to_a
      range[rand(range.length)]
    end
    Sass::Script::Number.new(value)
  end
  declare :random, [:limit]
  declare :random, [:start, :limit]

  def sin(number)
    trig(:sin, number)
  end
  declare :sin, [:number]

  def asin(number)
    trig(:asin, number)
  end
  declare :asin, [:number]

  def cos(number)
    trig(:cos, number)
  end
  declare :cos, [:number]

  def acos(number)
    trig(:acos, number)
  end
  declare :acos, [:number]

  def tan(number)
    trig(:tan, number)
  end
  declare :tan, [:number]

  def atan(number)
    trig(:atan, number)
  end
  declare :atan, [:number]

  def e
    Sass::Script::Number.new(Math::E)
  end
  declare :e, []

  def logarithm(number, base = e )
    assert_type number, :Number
    assert_type base, :Number
    raise Sass::SyntaxError, "base to logarithm must be unitless." unless base.unitless?

    result = Math.log(number.value, base.value) rescue Math.log(number.value) / Math.log(base.value)
    Sass::Script::Number.new(result, number.numerator_units, number.denominator_units)
  end
  declare :logarithm, [:number]
  declare :logarithm, [:number, :base]

  def sqrt(number)
    numeric_transformation(number) { |n| Math.sqrt(n) }
  end
  declare :sqrt, [:number]

  alias square_root sqrt
  declare :square_root, [:number]

  def pow(number, exponent)
    assert_type number, :Number
    assert_type exponent, :Number
    raise Sass::SyntaxError, "exponent to pow must be unitless." unless exponent.unitless?
    Sass::Script::Number.new(number.value**exponent.value, number.numerator_units, number.denominator_units)
  end
  declare :pow, [:number, :exponent]

  private
  def trig(operation, number)
    if number.numerator_units == ["deg"] && number.denominator_units == []
      Sass::Script::Number.new(Math.send(operation, Math::PI * number.value / 180))
    else
      Sass::Script::Number.new(Math.send(operation, number.value), number.numerator_units, number.denominator_units)
    end
  end
end
