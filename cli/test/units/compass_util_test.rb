require 'test_helper'

class CompassUtilTest < Test::Unit::TestCase
  def test_warn
    $stderr, old_err = StringIO.new, $stderr
    Compass::Util.compass_warn("this is a warning")
    assert_match(/this is a warning/, $stderr.string)
  ensure
    $stderr = old_err
  end
end
