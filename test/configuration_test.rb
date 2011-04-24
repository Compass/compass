require 'test_helper'
require 'compass'
require 'stringio'

class ConfigurationTest < Test::Unit::TestCase
  include Compass::IoHelper

  def setup
    Compass.reset_configuration!
  end

  def test_parse_and_serialize
    contents = StringIO.new(<<-CONFIG)
      require 'compass'
      # Require any additional compass plugins here.

      project_type = :stand_alone
      # Set this to the root of your project when deployed:
      http_path = "/"
      css_dir = "css"
      sass_dir = "sass"
      images_dir = "img"
      javascripts_dir = "js"
      output_style = :nested
      # To enable relative paths to assets via compass helper functions. Uncomment:
      # relative_assets = true
      # To disable debugging comments that display the original location of your selectors. Uncomment:
      # line_comments = false
      
      # If you prefer the indented syntax, you might want to regenerate this
      # project again passing --syntax sass, or you can uncomment this:
      # preferred_syntax = :sass
      # and then run:
      # sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
    CONFIG

    Compass.add_configuration(contents, "test_parse")

    assert_equal 'sass', Compass.configuration.sass_dir
    assert_equal 'css', Compass.configuration.css_dir
    assert_equal 'img', Compass.configuration.images_dir
    assert_equal 'js', Compass.configuration.javascripts_dir

    expected_lines = contents.string.split("\n").map{|l|l.strip}
    actual_lines = Compass.configuration.serialize.split("\n").map{|l|l.strip}
    assert_equal expected_lines, actual_lines
  end

  def test_serialization_warns_with_asset_host_set
    contents = StringIO.new(<<-CONFIG)
      asset_host do |path|
        "http://example.com"
      end
    CONFIG

    Compass.add_configuration(contents, "test_serialization_warns_with_asset_host_set")

    warning = capture_warning do
      Compass.configuration.serialize
    end
    assert_equal "WARNING: asset_host is code and cannot be written to a file. You'll need to copy it yourself.\n", warning
  end

  def test_serialization_warns_with_asset_cache_buster_set
    contents = StringIO.new(<<-CONFIG)
      asset_cache_buster do |path|
        "http://example.com"
      end
    CONFIG

    Compass.add_configuration(contents, "test_serialization_warns_with_asset_cache_buster_set")

    warning = capture_warning do
      Compass.configuration.serialize
    end
    assert_equal "WARNING: asset_cache_buster is code and cannot be written to a file. You'll need to copy it yourself.\n", warning
  end

  def test_additional_import_paths
    contents = StringIO.new(<<-CONFIG)
      http_path = "/"
      project_path = "/home/chris/my_compass_project"
      css_dir = "css"
      additional_import_paths = ["../foo"]
      add_import_path "/path/to/my/framework"
    CONFIG

    Compass.add_configuration(contents, "test_additional_import_paths")

    engine_opts = Compass.configuration.to_sass_engine_options

    load_paths = load_paths_as_strings(engine_opts[:load_paths])

    plugin_opts = Compass.configuration.to_sass_plugin_options

    assert load_paths.include?("/home/chris/my_compass_project/../foo")
    assert load_paths.include?("/path/to/my/framework"), load_paths.inspect
    assert_equal "/home/chris/my_compass_project/css/framework", plugin_opts[:template_location].find{|s,c| s == "/path/to/my/framework"}[1]
    assert_equal "/home/chris/my_compass_project/css/foo", plugin_opts[:template_location].find{|s,c| s == "/home/chris/my_compass_project/../foo"}[1]

    expected_serialization = <<EXPECTED
# Require any additional compass plugins here.
project_path = "/home/chris/my_compass_project"
# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "css"
# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
additional_import_paths = ["../foo", "/path/to/my/framework"]
# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false
EXPECTED
    assert_equal "/", Compass.configuration.http_path
    assert_equal expected_serialization.split("\n"), Compass.configuration.serialize.split("\n")
  end

  def test_config_with_pathname
    contents = StringIO.new(<<-CONFIG)
      http_path = "/"
      project_path = Pathname.new("/home/chris/my_compass_project")
      css_dir = "css"
      additional_import_paths = ["../foo"]
      add_import_path "/path/to/my/framework"
    CONFIG

    Compass.add_configuration(contents, "test_additional_import_paths")

    load_paths = load_paths_as_strings(Compass.configuration.to_sass_engine_options[:load_paths])

    assert load_paths.include?("/home/chris/my_compass_project/../foo")
    assert load_paths.include?("/path/to/my/framework"), load_paths.inspect
    assert_equal "/home/chris/my_compass_project/css/framework", Compass.configuration.to_sass_plugin_options[:template_location].find{|s,c| s == "/path/to/my/framework"}[1]
    assert_equal "/home/chris/my_compass_project/css/foo", Compass.configuration.to_sass_plugin_options[:template_location].find{|s,c| s == "/home/chris/my_compass_project/../foo"}[1]

    expected_serialization = <<EXPECTED
# Require any additional compass plugins here.
project_path = "/home/chris/my_compass_project"
# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "css"
# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
additional_import_paths = ["../foo", "/path/to/my/framework"]
# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false
EXPECTED
    assert_equal "/", Compass.configuration.http_path
    assert_equal expected_serialization.split("\n"), Compass.configuration.serialize.split("\n")
  end

    def test_sass_options
      contents = StringIO.new(<<-CONFIG)
        sass_options = {:foo => 'bar'}
      CONFIG

      Compass.add_configuration(contents, "test_sass_options")

      assert_equal 'bar', Compass.configuration.to_sass_engine_options[:foo]
      assert_equal 'bar', Compass.configuration.to_sass_plugin_options[:foo]

      expected_serialization = <<EXPECTED
# Require any additional compass plugins here.
# Set this to the root of your project when deployed:
http_path = "/"
# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
sass_options = {:foo=>"bar"}
# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false
EXPECTED

      assert_equal expected_serialization, Compass.configuration.serialize
    end

  def test_strip_trailing_directory_separators
    contents = StringIO.new(<<-CONFIG)
      css_dir = "css/"
      sass_dir = "sass/"
      images_dir = "images/"
      javascripts_dir = "js/"
      fonts_dir = "fonts/"
      extensions_dir = "extensions/"
      css_path = "css/"
      sass_path = "sass/"
      images_path = "images/"
      javascripts_path = "js/"
      fonts_path = "fonts/"
      extensions_path = "extensions/"
    CONFIG

    Compass.add_configuration(contents, "test_strip_trailing_directory_separators")

    assert_equal "css", Compass.configuration.css_dir
    assert_equal "sass", Compass.configuration.sass_dir
    assert_equal "images", Compass.configuration.images_dir
    assert_equal "js", Compass.configuration.javascripts_dir
    assert_equal "fonts", Compass.configuration.fonts_dir
    assert_equal "extensions", Compass.configuration.extensions_dir
  end

  def test_custom_configuration_properties
    # Add a configuration property to compass.
    Compass::Configuration.add_configuration_property(:foobar, "this is a foobar") do
      if environment == :production
        "foo"
      else
        "bar"
      end
    end

    contents = StringIO.new(<<-CONFIG)
      foobar = "baz"
    CONFIG

    Compass.add_configuration(contents, "test_strip_trailing_directory_separators")

    assert_equal "baz", Compass.configuration.foobar
    expected_serialization = <<EXPECTED
# Require any additional compass plugins here.
# Set this to the root of your project when deployed:
http_path = "/"
# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false
# this is a foobar
foobar = "baz"
EXPECTED
    assert_equal expected_serialization, Compass.configuration.serialize
    Compass.reset_configuration!
    Compass.configuration.environment = :production
    assert_equal "foo", Compass.configuration.foobar
    Compass.configuration.environment = :development
    assert_equal "bar", Compass.configuration.foobar
  ensure
    Compass::Configuration.remove_configuration_property :foobar
  end

  def load_paths_as_strings(load_paths)
    load_paths.map do |path|
      case path
      when Sass::Importers::Filesystem
        path.root
      when String, Pathname
        path.to_s
      end
    end.compact
  end


end
