require "test_helper"

class CompassModuleTest < Test::Unit::TestCase

  def setup
    Compass.reset_configuration!
    Compass.instance_variable_set("@shared_extension_paths", nil)
    @original_home = ENV["HOME"]
  end

  def teardown
    ENV["HOME"] = @original_home
    Compass.reset_configuration!
  end

  def test_shared_extension_paths_with_valid_home
    ENV["HOME"] = "/"
    assert_equal ["/.compass/extensions"], Compass.shared_extension_paths
  end

  def test_shared_extension_paths_with_nil_home
    ENV["HOME"] = nil
    assert_equal [], Compass.shared_extension_paths
  end

  def test_shared_extension_paths_with_file_home
    ENV["HOME"] = __FILE__
    assert_equal [], Compass.shared_extension_paths
  end

  def test_shared_extension_paths_with_relative_home
    ENV["HOME"] = "."
    assert_equal ["./.compass/extensions"], Compass.shared_extension_paths
  end

end
