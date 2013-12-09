class GradientTestClass
  extend Compass::Core::SassExtensions::Functions::Constants
  extend Compass::Core::SassExtensions::Functions::GradientSupport::Functions
  def self.options
    {}
  end
end

require 'test_helper'
require 'compass'

class GradientsTest < Test::Unit::TestCase
  include Sass::Script::Value::Helpers

  def klass
    GradientTestClass
  end

  test "should return correct angle" do
    assert_equal number(330, 'deg'), klass.convert_angle_from_offical(number(120, 'deg'))
  end

  test "Should convert old to new" do
    [:top => ['to', 'bottom'], :bottom => ['to', 'top'], :left => ['to', 'right'], :right => ['to', 'left']].each do |test_value|
      assert_equal list(identifier(test_value.keys.first.to_s), :space), klass.convert_angle_from_offical(
        list(identifier(test_value.values[0].first), identifier(test_value.values[0].last), :space))
    end
  end

end
