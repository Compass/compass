require 'test_helper'
require 'compass'
require 'stringio'

class ConfigurationTest < Test::Unit::TestCase

  setup do
    Compass.reset_configuration!
  end
  
  after do
    Compass.reset_configuration!
  end

  def test_defaults
    contents = StringIO.new(<<-CONFIG)
      project_type = :rails
    CONFIG
    config = Compass.configuration_for(contents, "config/compass.rb")

    Compass.add_project_configuration(config, :project_type => "rails")

    assert_equal 'public/images', Compass.configuration.images_dir
    assert_equal 'public/stylesheets', Compass.configuration.css_dir
    assert_equal 'public/fonts', Compass.configuration.fonts_dir

    assert_equal '/', Compass.configuration.http_path
    assert_equal '/images', Compass.configuration.http_images_path
    assert_equal '/stylesheets', Compass.configuration.http_stylesheets_path
    assert_equal '/fonts', Compass.configuration.http_fonts_path

    # Other default values must wait until I have a better idea of how to mock Sass::Util.app_geq
  end

  def test_http_path_change
    contents = StringIO.new(<<-CONFIG)
      project_type = :rails

      http_path = "/test/alternative_path"
    CONFIG
    config = Compass.configuration_for(contents, "config/compass.rb")

    Compass.add_project_configuration(config, :project_type => "rails")

    assert_equal '/test/alternative_path', Compass.configuration.http_path
    assert_equal '/test/alternative_path/images', Compass.configuration.http_images_path
    assert_equal '/test/alternative_path/stylesheets', Compass.configuration.http_stylesheets_path
    assert_equal '/test/alternative_path/fonts', Compass.configuration.http_fonts_path
  end
end
