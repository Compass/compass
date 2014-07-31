require 'test_helper'
require 'compass'

class CanIUseTest < Test::Unit::TestCase

  def caniuse
    Compass::Core::CanIUse.instance
  end

  DEFAULT_CAPABILITY_OPTIONS = [{:full_support => true}, {:partial_support => true}]

  def test_unknown_browsers
    assert_equal "unknown", Compass::Core::CanIUse::PUBLIC_BROWSER_NAMES["unknown"]
    assert_equal "unknown", Compass::Core::CanIUse::CAN_I_USE_NAMES["unknown"]
  end

  def test_browser_names
    assert_equal Compass::Core::CanIUse::PUBLIC_BROWSER_NAMES.values.sort, caniuse.browsers
  end

  def test_prefixes
    assert_equal %w(-moz -ms -o -webkit), caniuse.prefixes
    assert_equal %w(-moz -webkit), caniuse.prefixes(%w(chrome firefox safari))
  end

  def test_prefix
    assert_equal "-webkit", caniuse.prefix("chrome")
    assert_equal "-webkit", caniuse.prefix("safari")
    assert_equal "-ms", caniuse.prefix("ie")
    assert_equal "-webkit", caniuse.prefix("opera")
    assert_equal "-o", caniuse.prefix("opera", "12.1")
  end

  def test_browsers_with_prefix
    assert_equal %w(android android-chrome blackberry chrome ios-safari opera opera-mobile safari),
      caniuse.browsers_with_prefix("-webkit").sort
    assert_equal %w(android-firefox firefox),
      caniuse.browsers_with_prefix("-moz").sort
  end

  def test_capabilities
    # This is meant to break if a capability goes away or arrives
    # So that we can think about what that means for compass

    assert_equal [
      "background-img-opts",
      "border-image",
      "border-radius",
      "calc",
      "css-animation",
      "css-appearance",
      "css-backgroundblendmode",
      "css-boxshadow",
      "css-canvas",
      "css-counters",
      "css-featurequeries",
      "css-filters",
      "css-fixed",
      "css-gencontent",
      "css-gradients",
      "css-grid",
      "css-hyphens",
      "css-image-orientation",
      "css-masks",
      "css-mediaqueries",
      "css-mixblendmode",
      "css-opacity",
      "css-placeholder",
      "css-reflections",
      "css-regions",
      "css-repeating-gradients",
      "css-resize",
      "css-sel2",
      "css-sel3",
      "css-selection",
      "css-shapes",
      "css-sticky",
      "css-table",
      "css-textshadow",
      "css-transitions",
      "css-variables",
      "css3-boxsizing",
      "css3-colors",
      "css3-cursors",
      "css3-tabsize",
      "flexbox",
      "font-feature",
      "fontface",
      "getcomputedstyle",
      "inline-block",
      "intrinsic-width",
      "kerning-pairs-ligatures",
      "minmaxwh",
      "multibackgrounds",
      "multicolumn",
      "object-fit",
      "outline",
      "pointer-events",
      "rem",
      "style-scoped",
      "svg-css",
      "text-decoration",
      "text-overflow",
      "text-size-adjust",
      "text-stroke",
      "transforms2d",
      "transforms3d",
      "ttf",
      "user-select-none",
      "viewport-units",
      "word-break",
      "wordwrap"],
    caniuse.capabilities
  end

  def test_usage
    total = 0
    caniuse.browsers.each do |browser|
      caniuse.versions(browser).each do |version|
        usage = caniuse.usage(browser, version)
        if usage.nil?
          puts "nil usage for #{browser} at version #{version}"
          next
        end
        total += usage
      end
    end
    # all browsers add up to about 94%. that's... unfortunate.
    assert total > 90 && total < 100
  end

  def test_prefixed_usage
    assert 0 < caniuse.prefixed_usage("-webkit", "border-radius", DEFAULT_CAPABILITY_OPTIONS)
    assert_equal 0, caniuse.prefixed_usage("-webkit", "outline", DEFAULT_CAPABILITY_OPTIONS)
    assert_raises ArgumentError do
      caniuse.prefixed_usage("-webkit", "unknown", DEFAULT_CAPABILITY_OPTIONS)
    end
  end

  def test_requires_prefix
    assert_raises ArgumentError do
      caniuse.requires_prefix("chrome", "3", "border-radius", DEFAULT_CAPABILITY_OPTIONS)
    end
    assert_equal "-webkit", caniuse.requires_prefix("chrome", "4", "border-radius", DEFAULT_CAPABILITY_OPTIONS)
    assert_equal nil, caniuse.requires_prefix("chrome", "5", "border-radius", DEFAULT_CAPABILITY_OPTIONS)
    assert_equal nil, caniuse.requires_prefix("chrome", "30", "border-radius", DEFAULT_CAPABILITY_OPTIONS)
    assert_equal "-webkit", caniuse.requires_prefix("opera", "16", "css-filters", DEFAULT_CAPABILITY_OPTIONS)
  end

  def test_browser_ranges_only_prefixed
    mins = caniuse.browser_ranges("border-radius", "-webkit", false)
    expected = {
      "android"=>["2.1", "2.1"],
      "chrome"=>["4", "4"],
      "ios-safari"=>["3.2", "3.2"],
      "safari"=>["3.1", "4"]
    }
    assert_equal(expected, mins)
  end

  def test_ranges_are_empty_when_prefix_doesnt_exit
    mins = caniuse.browser_ranges("css-filters", "-o")
    expected = {}
    assert_equal(expected, mins)
  end

  def test_browser_ranges_including_unprefixed
    mins = caniuse.browser_ranges("border-radius", "-webkit")
    expected = {
      "android"=>["2.1", "4.4.3"],
      "chrome"=>["4", "39"],
      "ios-safari"=>["3.2", "8"],
      "safari"=>["3.1", "8"]
    }
    assert_equal(expected, mins)
  end

  def test_capability_matches
    assert caniuse.capability_matches(
      caniuse.browser_support("chrome", "10", "flexbox"),
      [{:full_support => true}, {:partial_support => true, :spec_versions => [1]}])
    assert !caniuse.capability_matches(
      caniuse.browser_support("chrome", "10", "flexbox"),
      [{:full_support => true}, {:partial_support => true, :spec_versions => [3]}])
  end

  def test_omitted_usage
    assert_equal 0, caniuse.omitted_usage("chrome", "4")
    assert_equal caniuse.usage("chrome", "4"), caniuse.omitted_usage("chrome", "5")
    assert_equal caniuse.usage("chrome", "4"), caniuse.omitted_usage("chrome", "4", "4")
    assert_equal caniuse.usage("chrome", "4") + caniuse.usage("chrome", "5"),
                 caniuse.omitted_usage("chrome", "4", "5")
  end
end
