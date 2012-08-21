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

  def test_shade
    assert_equal evaluate("mix(black, #ff0, 25%)"), evaluate("shade(#ff0, 25%)")
    assert_equal evaluate("mix(black, #ff0, 0%)"), evaluate("shade(#ff0, 0%)")
  end

  def test_tint
    assert_equal evaluate("mix(white, #ff0, 75%)"), evaluate("tint(#ff0, 75%)")
    assert_equal evaluate("mix(white, #ff0, 100%)"), evaluate("tint(#ff0, 100%)")
  end

  def test_if_function
    assert_equal "no", evaluate("if(false, yes, no)")
    assert_equal "yes", evaluate("if(true, yes, no)")
  end

  def test_math_functions
    assert_equal "0.84147", evaluate("sin(1)")
    assert_equal "0.84147px", evaluate("sin(1px)")
    assert_equal "0.0", evaluate("sin(pi())")
    assert_equal "1",   evaluate("sin(pi() / 2)")
    assert_equal "0.0",   evaluate("sin(180deg)")
    assert_equal "-1",  evaluate("sin(3* pi() / 2)")
    assert_equal "-1", evaluate("cos(pi())")
    assert_equal "1", evaluate("cos(360deg)")
    assert_equal "-0.17605", evaluate("sin(270)")
    assert_equal "1", evaluate("cos(2*pi())")
    assert_equal "0.0",   evaluate("cos(pi() / 2)")
    assert_equal "0.0",  evaluate("cos(3* pi() / 2)")
    assert_equal "0.0",  evaluate("tan(pi())")
    assert_equal "0.0", evaluate("tan(360deg)")
    assert_equal "0.95892", evaluate("sin(360)")
    assert evaluate("tan(pi()/2 - 0.0001)").to_f > 1000, evaluate("tan(pi()/2 - 0.0001)")
    assert evaluate("tan(pi()/2 + 0.0001)").to_f < -1000, evaluate("tan(pi()/2 - 0.0001)")
    assert_equal "0.69315px", evaluate("logarithm(2px)")
    assert_equal "0", evaluate("logarithm(1)")
    assert_equal "1", evaluate("logarithm(e())")
    assert_equal "1", evaluate("logarithm($number: e())")
    assert_equal "1", evaluate("logarithm(10, $base: 10)")
    assert_equal "5px", evaluate("sqrt(25px)")
    assert_equal "5px", evaluate("sqrt($number: 25px)")
    assert_equal "5px", evaluate("square-root(25px)")
    assert_equal "5px", evaluate("square-root($number: 25px)")
    assert_equal "25px", evaluate("pow(5px, 2)")
    assert_equal "25px", evaluate("pow($number: 5px, $exponent: 2)")
    assert_equal "79.43236px", evaluate("pow(5px, e())")
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

  def test_font_files
    assert_equal '', evaluate('font_files()')
    assert_equal "url(/font/name.woff) format('woff'), url(/fonts/name.ttf) format('truetype'), url(/fonts/name.svg#fontpath) format('svg')", evaluate("font-files('/font/name.woff', woff, '/fonts/name.ttf', truetype, '/fonts/name.svg#fontpath', svg)")

    assert_equal "url(/font/with/right_ext.woff) format('woff')", evaluate("font_files('/font/with/right_ext.woff')")
    assert_equal "url(/font/with/wrong_ext.woff) format('svg')", evaluate("font_files('/font/with/wrong_ext.woff', 'svg')")
    assert_equal "url(/font/with/no_ext) format('opentype')", evaluate("font_files('/font/with/no_ext', 'otf')")
    assert_equal "url(/font/with/weird.ext) format('truetype')", evaluate("font_files('/font/with/weird.ext', 'ttf')")

    assert_equal "url(/font/with/right_ext.woff) format('woff'), url(/font/with/right_ext_also.otf) format('opentype')", evaluate("font_files('/font/with/right_ext.woff', '/font/with/right_ext_also.otf')")
    assert_equal "url(/font/with/wrong_ext.woff) format('truetype'), url(/font/with/right_ext.otf) format('opentype')", evaluate("font_files('/font/with/wrong_ext.woff', 'ttf', '/font/with/right_ext.otf')")

    assert_nothing_raised Sass::SyntaxError do
      evaluate("font-files('/font/name.woff')")
    end

    assert_nothing_raised Sass::SyntaxError do
      evaluate("font-files('/font/name.svg#fontId')")
    end

    assert_nothing_raised Sass::SyntaxError do
      evaluate("font-files('/font/name.eot?#iefix')")
    end

    assert_nothing_raised Sass::SyntaxError do
      evaluate("font-files('/font/name.svg?mightbedynamic=something%20+escaped#fontId')")
    end

    assert_raises Sass::SyntaxError do
      evaluate("font-files('/font/name.ext')")
    end

    assert_raises Sass::SyntaxError do
      evaluate("font-files('/font/name.ext', 'nonsense')")
    end
  end

  %w(stylesheet_url font_url image_url generated_image_url).each do |helper|
    class_eval %Q{
      def test_#{helper}_helper_defers_to_existing_helper
        c = Class.new do
          def #{helper}(*args)
            :original
          end
        end
        c.send(:include, Compass::SassExtensions::Functions::Urls)
        assert_equal :original, c.new.#{helper}("logo.png")
      end
    }
  end

  def test_inline_font_files
    Compass.configuration.fonts_path = File.expand_path "../fixtures/fonts", File.dirname(__FILE__)
    base64_string = File.read(File.join(Compass.configuration.fonts_path, "bgrove.base64.txt")).chomp
    assert_equal "url('data:font/truetype;base64,#{base64_string}') format('truetype')", evaluate("inline_font_files('bgrove.ttf', truetype)")
  end


  def test_image_size_should_respond_to_to_path
    object = mock()
    object.expects(:to_path).returns('foo.jpg')
    object.expects(:respond_to?).with(:to_path).returns(true)

    Compass::SassExtensions::Functions::ImageSize::ImageProperties.new(object)
  end

  def test_reject
    assert_equal "b d", evaluate("reject(a b c d, a, c)")
    assert_equal "a b c d", evaluate("reject(a b c d, e)")
  end

protected
  def evaluate(value)
    Sass::Script::Parser.parse(value, 0, 0).perform(Sass::Environment.new).to_s
  end
end
