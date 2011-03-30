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

  def test_scale_lightness
    assert_equal "75%", evaluate("lightness(scale-lightness(hsl(50deg, 50%, 50%), 50%))")
    assert_equal "25%", evaluate("lightness(scale-lightness(hsl(50deg, 50%, 50%), -50%))")
  end

  def test_adjust_lightness
    assert_equal "75%", evaluate("lightness(adjust-lightness(hsl(50deg, 50%, 50%), 25%))")
    assert_equal "25%", evaluate("lightness(adjust-lightness(hsl(50deg, 50%, 50%), -25%))")
    assert_equal "100%", evaluate("lightness(adjust-lightness(hsl(50deg, 50%, 50%), 500%))")
    assert_equal "0%", evaluate("lightness(adjust-lightness(hsl(50deg, 50%, 50%), -500%))")
  end

  def test_scale_saturation
    assert_equal "75%", evaluate("saturation(scale-saturation(hsl(50deg, 50%, 50%), 50%))")
    assert_equal "25%", evaluate("saturation(scale-saturation(hsl(50deg, 50%, 50%), -50%))")
  end

  def test_adjust_saturation
    assert_equal "75%", evaluate("saturation(adjust-saturation(hsl(50deg, 50%, 50%), 25%))")
    assert_equal "25%", evaluate("saturation(adjust-saturation(hsl(50deg, 50%, 50%), -25%))")
  end

  def test_if_function
    assert_equal "no", evaluate("if(false, yes, no)")
    assert_equal "yes", evaluate("if(true, yes, no)")
  end

  def test_trig_functions
    assert_equal "0.841px", evaluate("sin(1px)")
    assert_equal "0.0", evaluate("sin(pi())")
    assert_equal "1",   evaluate("sin(pi() / 2)")
    assert_equal "1",   evaluate("sin(180deg)")
    assert_equal "-1",  evaluate("sin(3* pi() / 2)")
    assert_equal "-1", evaluate("cos(pi())")
    assert_equal "-1", evaluate("cos(360deg)")
    assert_equal "1", evaluate("cos(2*pi())")
    assert_equal "0.0",   evaluate("cos(pi() / 2)")
    assert_equal "0.0",  evaluate("cos(3* pi() / 2)")
    assert_equal "0.0",  evaluate("tan(pi())")
    assert_equal "0.0", evaluate("tan(360deg)")
    assert evaluate("tan(pi()/2 - 0.0001)").to_f > 1000, evaluate("tan(pi()/2 - 0.0001)")
    assert evaluate("tan(pi()/2 + 0.0001)").to_f < -1000, evaluate("tan(pi()/2 - 0.0001)")
  end

  def test_blank
    assert_equal "false", evaluate("blank(true)")
    assert_equal "true", evaluate("blank(false)")
    assert_equal "true", evaluate("blank('')")
    assert_equal "true", evaluate("blank(' ')")
    assert_equal "true", evaluate("blank(-compass-space-list(' '))")
  end

  def test_css2_fallback
    assert_equal "css3", evaluate("css2-fallback(css3, css2)")
    assert_equal "css2", evaluate("-css2(css2-fallback(css3, css2))")
    assert_equal "true", evaluate("prefixed(-css2, css2-fallback(css3, css2))")
  end

protected
  def evaluate(value)
    Sass::Script::Parser.parse(value, 0, 0).perform(Sass::Environment.new).to_s
  end
end
