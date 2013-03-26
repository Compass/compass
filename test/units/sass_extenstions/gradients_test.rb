class GradientTestClass
  extend Compass::SassExtensions::Functions::Constants
  extend Compass::SassExtensions::Functions::GradientSupport::Functions
end

require 'test_helper'
require 'compass'

class GradientsTest < Test::Unit::TestCase
  
  def klass
    GradientTestClass
  end

  def sass_string(s)
    Sass::Script::String.new(s)
  end

  def sass_list(array)
    Sass::Script::List.new(array, :space)
  end

  test "should return correct angle" do
    assert_equal Sass::Script::Number.new(330, ['deg']), klass.convert_angle_from_offical(Sass::Script::Number.new(120, ['deg']))
  end

  test "Should convert old to new" do
    [:top => ['to', 'bottom'], :bottom => ['to', 'top'], :left => ['to', 'right'], :right => ['to', 'left']].each do |test_value|
      assert_equal sass_string(test_value.keys.first.to_s), klass.convert_angle_from_offical(sass_list([sass_string(test_value.values[0].first), sass_string(test_value.values[0].last)]))
    end
  end

end