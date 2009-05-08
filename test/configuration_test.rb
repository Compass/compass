require  File.dirname(__FILE__)+'/test_helper'
require 'compass'

class ConfigurationTest < Test::Unit::TestCase

  def setup
    Compass.configuration.reset!
  end

  def test_parse_and_serialize
    contents = <<-CONFIG
      require 'compass'
      # Require any additional compass plugins here.

      project_type = :stand_alone
      css_dir = "css"
      sass_dir = "sass"
      images_dir = "img"
      javascripts_dir = "js"
      output_style = :nested
      # To enable relative image paths using the images_url() function:
      # http_images_path = :relative
      http_images_path = "/images"
    CONFIG

    Compass.configuration.parse_string(contents, "test_parse")

    assert_equal 'sass', Compass.configuration.sass_dir
    assert_equal 'css', Compass.configuration.css_dir
    assert_equal 'img', Compass.configuration.images_dir
    assert_equal 'js', Compass.configuration.javascripts_dir

    expected_lines = contents.split("\n").map{|l|l.strip}
    actual_lines = Compass.configuration.serialize.split("\n").map{|l|l.strip}
    assert_equal expected_lines, actual_lines
  end

end