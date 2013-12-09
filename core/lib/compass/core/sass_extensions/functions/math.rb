module Compass::Core::SassExtensions::Functions::Math
  extend Compass::Core::SassExtensions::Functions::SassDeclarationHelper
  extend Sass::Script::Value::Helpers

  PI = number(Math::PI)
  E = number(Math::E)

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
    number(value)
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
    E
  end
  declare :e, []

  def logarithm(number, base = e )
    assert_type number, :Number
    assert_type base, :Number
    raise Sass::SyntaxError, "base to logarithm must be unitless." unless base.unitless?

    result = Math.log(number.value, base.value) rescue Math.log(number.value) / Math.log(base.value)
    number(result, number.unit_str)
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
    number(number.value**exponent.value, number.unit_str)
  end
  declare :pow, [:number, :exponent]

  private
  def trig(operation, number)
    if number.unit_str == "deg"
      number(Math.send(operation, Math::PI * number.value / 180))
    else
      number(Math.send(operation, number.value), number.unit_str)
    end
  end
end
