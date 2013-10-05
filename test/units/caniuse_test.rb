require 'test_helper'
require 'compass'

class CanIUseTest < Test::Unit::TestCase

  def caniuse
    Compass::CanIUse.instance
  end

  def test_unknown_browsers
    assert_equal "unknown", Compass::CanIUse::PUBLIC_BROWSER_NAMES["unknown"]
    assert_equal "unknown", Compass::CanIUse::CAN_I_USE_NAMES["unknown"]
  end

  def test_browser_names
    assert_equal Compass::CanIUse::PUBLIC_BROWSER_NAMES.values.sort, caniuse.browsers
  end

  def test_prefixes
    assert_equal %w(-moz -ms -o -webkit), caniuse.prefixes
    assert_equal %w(-moz -webkit), caniuse.prefixes(%w(chrome firefox safari))
  end

  def test_prefix
    assert_equal "-webkit", caniuse.prefix("chrome")
    assert_equal "-webkit", caniuse.prefix("safari")
    assert_equal "-ms", caniuse.prefix("ie")
    assert_equal "-o", caniuse.prefix("opera")
  end

  def test_browsers_with_prefix
    assert_equal %w(android android-chrome blackberry chrome ios-safari safari),
      caniuse.browsers_with_prefix("-webkit").sort
    assert_equal %w(android-firefox firefox),
      caniuse.browsers_with_prefix("-moz").sort
  end
  
  def test_capabilities
    # This is meant to break if a capability goes away or arrives
    # So that we can think about what that means for compass
    assert_equal ["background-img-opts", "border-image", "border-radius", "calc",
                  "css-animation", "css-boxshadow", "css-canvas", "css-counters",
                  "css-featurequeries", "css-filters", "css-fixed", "css-gencontent",
                  "css-gradients", "css-grid", "css-hyphens", "css-masks",
                  "css-mediaqueries", "css-opacity", "css-reflections", "css-regions",
                  "css-repeating-gradients", "css-resize", "css-sel2", "css-sel3",
                  "css-selection", "css-table", "css-textshadow", "css-transitions",
                  "css3-boxsizing", "css3-colors", "css3-tabsize", "flexbox",
                  "font-feature", "fontface", "getcomputedstyle", "inline-block",
                  "intrinsic-width", "minmaxwh", "multibackgrounds", "multicolumn",
                  "object-fit", "outline", "pointer-events", "rem", "style-scoped",
                  "svg-css", "text-overflow", "text-stroke", "transforms2d",
                  "transforms3d", "ttf", "user-select-none", "viewport-units",
                  "word-break", "wordwrap"],
                 caniuse.capabilities
  end

  def test_usage
    total = 0
    caniuse.browsers.each do |browser|
      caniuse.versions(browser).each do |version|
        total += caniuse.usage(browser, version)
      end
    end
    # all browsers add up to about 94%. that's... unfortunate.
    assert total > 90 && total < 100
  end

  def test_prefixed_usage
    assert 0 < caniuse.prefixed_usage("-webkit", "border-radius")
    assert_equal 0, caniuse.prefixed_usage("-webkit", "outline")
    assert_raises ArgumentError do
      caniuse.prefixed_usage("-webkit", "unknown")
    end
  end

  def test_requires_prefix
    assert_raises ArgumentError do
      caniuse.requires_prefix("chrome", "3", "border-radius")
    end
    assert_equal true, caniuse.requires_prefix("chrome", "4", "border-radius")
    assert_equal false, caniuse.requires_prefix("chrome", "5", "border-radius")
    assert_equal false, caniuse.requires_prefix("chrome", "30", "border-radius")
  end
end
