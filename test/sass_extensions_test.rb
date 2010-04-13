require 'test_helper'

class SassExtensionsTest < Test::Unit::TestCase
  def test_simple
    assert_equal "a b", evaluate(%Q{nest("a", "b")})
  end
  def test_left_side_expansion
    assert_equal "a c, b c", evaluate(%Q{nest("a, b", "c")})
  end
  def test_right_side_expansion
    assert_equal "a b, a c", evaluate(%Q{nest("a", "b, c")})
  end
  def test_both_sides_expansion
    assert_equal "a c, a d, b c, b d", evaluate(%Q{nest("a, b", "c, d")})
  end
  def test_three_selectors_expansion
    assert_equal "a b, a c, a d", evaluate(%Q{nest("a", "b, c, d")})
  end
  def test_third_argument_expansion
    assert_equal "a b e, a b f, a c e, a c f, a d e, a d f", evaluate(%Q{nest("a", "b, c, d", "e, f")})
  end

  def test_enumerate
    assert_equal ".grid-1, .grid-2, .grid-3", evaluate(%Q{enumerate(".grid", 1, 3, "-")})
  end
  
  def test_append_selector
    assert_equal "div.bar", evaluate(%Q{append_selector("div", ".bar")})
    assert_equal ".foo1.bar1, .foo1.bar2, .foo2.bar1, .foo2.bar2", evaluate(%Q{append_selector(".foo1, .foo2", ".bar1, .bar2")})
  end

  def test_headers
    assert_equal "h1, h2, h3, h4, h5, h6", evaluate("headers()")
    assert_equal "h1, h2, h3, h4, h5, h6", evaluate("headers(all)")
    assert_equal "h1, h2, h3, h4", evaluate("headers(4)")
    assert_equal "h2, h3", evaluate("headers(2,3)")
    assert_equal "h4, h5, h6", evaluate("headers(4,6)")
  end

protected
  def evaluate(value)
    Sass::Script::Parser.parse(value, 0, 0).perform(Sass::Environment.new).to_s
  end
end
