require 'test_helper'

class SassExtensionsTest < Test::Unit::TestCase
  def test_simple
    assert_equal "a b", nest("a", "b")
  end
  def test_left_side_expansion
    assert_equal "a c, b c", nest("a, b", "c")
  end
  def test_right_side_expansion
    assert_equal "a b, a c", nest("a", "b, c")
  end
  def test_both_sides_expansion
    assert_equal "a c, a d, b c, b d", nest("a, b", "c, d")
  end
  def test_three_selectors_expansion
    assert_equal "a b, a c, a d", nest("a", "b, c, d")
  end
  def test_third_argument_expansion
    assert_equal "a b e, a b f, a c e, a c f, a d e, a d f", nest("a", "b, c, d", "e, f")
  end

  def test_enumerate
    assert_equal ".grid-1, .grid-2, .grid-3", enumerate(".grid", 1, 3, "-")
  end
  
  def test_append_selector
    assert_equal "div.bar", append_selector("div", ".bar")
    assert_equal ".foo1.bar1, .foo1.bar2, .foo2.bar1, .foo2.bar2", append_selector(".foo1, .foo2", ".bar1, .bar2")
  end

protected
  def evaluation_content(options)
    Sass::Script::Functions::EvaluationContext.new(options)
  end
  def nest(*arguments)
    options = arguments.last.is_a?(Hash) ? arguments.pop : Hash.new
    evaluation_content(options).nest(*arguments.map{|a| Sass::Script::String.new(a, :string)}).to_s
  end
  def enumerate(prefix, from, through, separator = "-", options = {})
    prefix = Sass::Script::String.new(prefix, :string)
    from = Sass::Script::Number.new(from)
    through = Sass::Script::Number.new(through)
    separator = Sass::Script::String.new(separator, :string)
    evaluation_content(options).enumerate(prefix, from, through, separator).to_s
  end
  def append_selector(*arguments)
    options = arguments.last.is_a?(Hash) ? arguments.pop : Hash.new
    evaluation_content(options).append_selector(*arguments.map{|a| Sass::Script::String.new(a, :string)}).to_s
  end
end
