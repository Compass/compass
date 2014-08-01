require 'test_helper'
require 'compass'
require 'stringio'

class ConfigurationTest < Test::Unit::TestCase

  setup do
    Compass.reset_configuration!
    @original_wd = Dir.pwd
    FileUtils.rm_rf "test_tmp"
    FileUtils.mkdir_p "test_tmp/images"
    FileUtils.mkdir_p "test_tmp/fonts"
    Dir.chdir "test_tmp"
  end
  
  after do
    Compass.reset_configuration!
    Dir.chdir @original_wd
    FileUtils.rm_rf "test_tmp"
  end

  def test_parse_and_serialize
    contents = StringIO.new(<<-CONFIG)
      require 'compass'
      require 'compass/import-once/activate'
      # Require any additional compass plugins here.

      project_type = :stand_alone
      
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
    assert_correct expected_lines, actual_lines
  end

  def test_custom_watch
    contents = StringIO.new(<<-CONFIG)
      watch 'img/**/*' do
        puts 'foobar'
      end
    CONFIG
    Compass.add_configuration(contents, 'test_watch_config')
    watch = Compass.configuration.watches.first
    assert_equal 'img/**/*', watch.glob
    assert watch.is_a?(Compass::Configuration::Watch)
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

  class TestData < Compass::Configuration::FileData
    def initialize
      super(:test)
    end
    inherited_array :stuff, :clobbers => true
    inherited_array :accumulated
  end

  def test_accumulated_array_does_not_clobber
    data1 = TestData.new
    data1.accumulated = [:a]
    data2 = TestData.new
    data2.accumulated = [:b]
    data2.inherit_from!(data1)
    assert_equal [:b, :a], data2.accumulated.to_a
  end

  def test_inherited_array_can_clobber
    data1 = TestData.new
    data1.stuff = [:a]
    data2 = TestData.new
    data2.stuff = [:b]
    data2.inherit_from!(data1)
    assert_equal [:b], data2.stuff.to_a
  end

  def test_inherited_array_can_append
    data1 = TestData.new
    data1.stuff = [:a]
    data2 = TestData.new
    data2.stuff << :b
    data2.inherit_from!(data1)
    assert_equal [:b, :a], data2.stuff.to_a
  end

  def test_inherited_array_can_append_2
    data1 = TestData.new
    data1.stuff = [:a]
    data2 = TestData.new
    data2.stuff << :b
    data2.inherit_from!(data1)
    data3 = TestData.new
    data3.stuff << :c
    data3.inherit_from!(data2)
    assert_equal [:c, :b, :a], data3.stuff.to_a
  end

  def test_inherited_array_can_remove
    data1 = TestData.new
    data1.stuff = [:a]
    data2 = TestData.new
    data2.stuff >> :a
    data2.inherit_from!(data1)
    assert_equal [], data2.stuff.to_a
  end

  def test_inherited_array_combined_augmentations
    data1 = TestData.new
    data1.stuff = [:a]
    data2 = TestData.new
    data2.stuff >> :a
    data2.stuff << :b
    data2.inherit_from!(data1)
    assert_equal [:b], data2.stuff.to_a
  end

  def test_inherited_array_long_methods
    data1 = TestData.new
    data1.stuff = [:a]
    data2 = TestData.new
    data2.remove_from_stuff(:a)
    data2.add_to_stuff(:b)
    data2.inherit_from!(data1)
    assert_equal [:b], data2.stuff.to_a
  end

  def test_inherited_array_augmentations_can_be_clobbered
    data1 = TestData.new
    data1.stuff = [:a]
    data2 = TestData.new
    data2.stuff >> :a
    data2.stuff << :b
    data2.stuff = [:c]
    data2.inherit_from!(data1)
    assert_equal [:c], data2.stuff.to_a
  end

  def test_inherited_array_augmentations_after_clobbering
    data1 = TestData.new
    data1.stuff = [:a]
    data2 = TestData.new
    data2.stuff >> :a
    data2.stuff << :b
    data2.stuff = [:c, :d]
    data2.stuff << :e
    data2.stuff >> :c
    data2.inherit_from!(data1)
    assert_equal [:d, :e], data2.stuff.to_a
  end

  def test_serialization_warns_with_asset_cache_buster_set
    contents = StringIO.new(<<-CONFIG)
      asset_cache_buster do |path|
        "http://example.com"
      end
    CONFIG

    Compass.add_configuration(contents, "test_serialization_warns_with_asset_cache_buster_set")

    assert_kind_of Proc, Compass.configuration.asset_cache_buster_without_default
    assert_equal "http://example.com", Compass.configuration.asset_cache_buster_without_default.call("whatever")
    warning = capture_warning do
      Compass.configuration.serialize
    end
    assert_equal "WARNING: asset_cache_buster is code and cannot be written to a file. You'll need to copy it yourself.\n", warning
  end

  def test_cache_buster_file_not_passed_when_the_file_does_not_exist
    config = Compass::Configuration::Data.new("test_cache_buster_file_not_passed_when_the_file_does_not_exist")
    the_file = nil
    was_called = nil
    config.asset_cache_buster do |path, file|
      was_called = true
      the_file = file
      "busted=true"
    end

    Compass.add_configuration(config)


    sass = Sass::Engine.new(<<-SCSS, Compass.configuration.to_sass_engine_options.merge(:syntax => :scss))
      .foo { background: image-url("asdf.gif") }
    SCSS
    sass.render
    assert was_called
    assert_nil the_file
  end

  def test_cache_buster_file_is_closed
    config = Compass::Configuration::Data.new("test_cache_buster_file_is_closed")
    the_file = nil
    was_called = nil
    FileUtils.touch "images/asdf.gif"
    config.asset_cache_buster do |path, file|
      was_called = true
      the_file = file
      "busted=true"
    end

    Compass.add_configuration(config)

    sass = Sass::Engine.new(<<-SCSS, Compass.configuration.to_sass_engine_options.merge(:syntax => :scss))
      .foo { background: image-url("asdf.gif") }
    SCSS
    sass.render
    assert was_called
    assert_kind_of File, the_file
    assert the_file.closed?
  end

  def test_cache_buster_handles_id_refs_for_images
    config = Compass::Configuration::Data.new("test_cache_buster_file_is_closed")
    the_file = nil
    was_called = nil
    FileUtils.touch "images/asdf.svg"
    config.asset_cache_buster do |path, file|
      was_called = true
      the_file = file
      "busted=true"
    end

    Compass.add_configuration(config)

    sass = Sass::Engine.new(<<-SCSS, Compass.configuration.to_sass_engine_options.merge(:syntax => :scss))
      .foo { background: image-url("asdf.svg#image-1") }
    SCSS
    result = sass.render
    assert was_called
    assert_kind_of File, the_file
    assert the_file.closed?
     assert_equal <<CSS, result
/* line 1 */
.foo {
  background: url('/images/asdf.svg?busted=true#image-1');
}
CSS
  end

  def test_default_cache_buster_handles_id_refs_for_images
    FileUtils.touch "images/asdf.svg"
    sass = Sass::Engine.new(<<-SCSS, Compass.configuration.to_sass_engine_options.merge(:syntax => :scss))
      .foo { background: image-url("asdf.svg#image-1") }
    SCSS
    result = sass.render
     assert_equal <<CSS, result
/* line 1 */
.foo {
  background: url('/images/asdf.svg?#{File.mtime("images/asdf.svg").to_i}#image-1');
}
CSS
  end

  def test_cache_buster_handles_id_refs_for_fonts
    config = Compass::Configuration::Data.new("test_cache_buster_file_is_closed")
    the_file = nil
    was_called = nil
    FileUtils.touch "fonts/asdf.ttf"
    config.asset_cache_buster do |path, file|
      was_called = true
      the_file = file
      "busted=true"
    end

    Compass.add_configuration(config)

    sass = Sass::Engine.new(<<-SCSS, Compass.configuration.to_sass_engine_options.merge(:syntax => :scss))
      .foo { background: font-url("asdf.ttf#iefix") }
    SCSS
    result = sass.render
    assert was_called
    assert_kind_of File, the_file
    assert the_file.closed?
     assert_equal <<CSS, result
/* line 1 */
.foo {
  background: url('/fonts/asdf.ttf?busted=true#iefix');
}
CSS
  end


  def test_inherited_arrays_augmentations_serialize
    inherited = TestData.new
    inherited.stuff << :a
    d = TestData.new
    d.stuff << :b
    d.stuff >> :c
    assert_equal <<CONFIG, d.serialize_property(:stuff, d.stuff)
stuff << :b
stuff >> :c
CONFIG
  end
  def test_inherited_arrays_clobbering_with_augmentations_serialize
    inherited = TestData.new
    inherited.stuff << :a
    d = TestData.new
    d.stuff << :b
    d.stuff = [:c, :d]
    d.stuff << :e
    assert_equal <<CONFIG, d.serialize_property(:stuff, d.stuff)
stuff = [:c, :d, :e]
CONFIG
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

    assert load_paths.include?("/home/chris/foo"), "Expected to find /home/chris/foo in #{load_paths.inspect}"
    assert load_paths.include?("/path/to/my/framework"), load_paths.inspect

    expected_serialization = <<EXPECTED
require 'compass/import-once/activate'
# Require any additional compass plugins here.
project_path = "/home/chris/my_compass_project"

http_path = "/"
css_dir = "css"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
additional_import_paths = ["../foo", "/path/to/my/framework"]
EXPECTED
    assert_equal "/", Compass.configuration.http_path
    assert_correct expected_serialization, Compass.configuration.serialize
  end

  def test_additional_import_paths_can_be_importers
    contents = StringIO.new(<<-CONFIG)
      http_path = "/"
      project_path = "/home/chris/my_compass_project"
      css_dir = "css"
      preferred_syntax = :scss
      additional_import_paths = ["../foo"]
      add_import_path Sass::Importers::Filesystem.new("/tmp/foo")
    CONFIG

    Compass.add_configuration(contents, "test_additional_import_paths")

    assert Compass.configuration.sass_load_paths.find{|p| p.is_a?(Sass::Importers::Filesystem) && p.root == "/tmp/foo"}
    assert Compass.configuration.to_sass_plugin_options[:load_paths].find{|p| p.is_a?(Sass::Importers::Filesystem) && p.root == "/tmp/foo"}
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

    assert load_paths.include?("/home/chris/foo"), "Expected to find /home/chris/foo in #{load_paths.inspect}"
    assert load_paths.include?("/path/to/my/framework"), load_paths.inspect

    expected_serialization = <<EXPECTED
require 'compass/import-once/activate'
# Require any additional compass plugins here.
project_path = "/home/chris/my_compass_project"

http_path = "/"
css_dir = "css"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
additional_import_paths = ["../foo", "/path/to/my/framework"]
EXPECTED
    assert_equal "/", Compass.configuration.http_path
    assert_correct expected_serialization.split("\n"), Compass.configuration.serialize.split("\n")
  end

    def test_sass_options
      contents = StringIO.new(<<-CONFIG)
        sass_options = {:foo => 'bar'}
      CONFIG

      Compass.add_configuration(contents, "test_sass_options")

      assert_equal 'bar', Compass.configuration.to_sass_engine_options[:foo]
      assert_equal 'bar', Compass.configuration.to_sass_plugin_options[:foo]

      expected_serialization = <<EXPECTED
require 'compass/import-once/activate'
# Require any additional compass plugins here.

# Set this to the root of your project when deployed:
http_path = \"/\"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true\nsass_options = {:foo=>\"bar\"}

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
EXPECTED

      assert_correct(expected_serialization, Compass.configuration.serialize)
    end

    def test_sprite_load_path_clobbers
      contents = StringIO.new(<<-CONFIG)
        sprite_load_path = ["/Users/chris/Projects/my_compass_project/images/sprites"]
      CONFIG

      Compass.add_configuration(contents, "test_sass_options")

      assert_equal ["/Users/chris/Projects/my_compass_project/images/sprites"], Compass.configuration.sprite_load_path.to_a

      expected_serialization = <<EXPECTED
require 'compass/import-once/activate'
# Require any additional compass plugins here.

# Set this to the root of your project when deployed:
http_path = "/"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
sprite_load_path = ["/Users/chris/Projects/my_compass_project/images/sprites"]
EXPECTED

      assert_correct(expected_serialization, Compass.configuration.serialize)
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
require 'compass/import-once/activate'
# Require any additional compass plugins here.

# Set this to the root of your project when deployed:
http_path = "/"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass

# this is a foobar
foobar = "baz"
EXPECTED
    assert_correct(expected_serialization, Compass.configuration.serialize)
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
