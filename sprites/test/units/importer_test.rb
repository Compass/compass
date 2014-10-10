require 'test_helper'

class ImporterTest < Test::Unit::TestCase
  include Compass::Sprites::Test::SpriteHelper

  def setup
    create_sprite_temp
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    @importer = Compass::Sprites::Importer.new
  end

  def teardown
    Compass.reset_configuration!
  end

  def options
    {:foo => 'bar'}
  end

  def test_should_use_search_path_to_find_sprites
    Compass.reset_configuration!
    uri = 'foo/*.png'
    other_folder = File.join(@images_tmp_path, '../other-temp')
    FileUtils.mkdir_p other_folder
    FileUtils.mkdir_p File.join(other_folder, 'foo')
    %w(my bar).each do |file|
      FileUtils.touch(File.join(other_folder, "foo/#{file}.png"))
    end
    config = Compass::Configuration::Data.new('config')
    config.images_path = @images_tmp_path
    config.sprite_load_path = [@images_tmp_path, other_folder]
    Compass.add_configuration(config, "sprite_config")
    importer = Compass::Sprites::Importer.new
    assert_equal 2, Compass.configuration.sprite_load_path.compact.size
    assert Compass.configuration.sprite_load_path.include?(other_folder)
    assert_equal ["bar", "my"], Compass::Sprites::Importer.sprite_names(uri)
  ensure
    FileUtils.rm_rf other_folder
  end

  def test_name_should_return_the_sprite_name
    assert_equal 'selectors', Compass::Sprites::Importer.sprite_name(URI)
  end

  def test_path_should_return_the_sprite_path
    assert_equal 'selectors',  Compass::Sprites::Importer.path(URI)
  end

  def test_should_return_all_the_sprite_names
    assert_equal ["ten-by-ten", "ten-by-ten_active", "ten-by-ten_hover", "ten-by-ten_target"], Compass::Sprites::Importer.sprite_names(URI)
  end

  def test_should_have_correct_mtime
    thirtydays = Time.now.to_i + (60*60*24*30)
    file = Dir[File.join(@images_src_path, URI)].sort.first
    File.utime(thirtydays, thirtydays, file)
    assert_equal thirtydays, File.mtime(file).to_i
    assert_equal thirtydays, @importer.mtime(URI, {}).to_i
  end

  def test_should_return_sass_engine_on_find
    assert @importer.find(URI, {}).is_a?(Sass::Engine)
  end

  def test_sass_options_should_contain_options
    opts = Compass::Sprites::Importer.sass_options('foo', @importer, options)
    assert_equal 'bar', opts[:foo]
  end

 def test_verify_that_the_sass_engine_passes_the_correct_filename
    importer = Compass::Sprites::Importer.new
    engine = Compass::Sprites::Importer.sass_engine(URI, 'foo', importer, options)
    assert_equal engine.options[:filename], URI
  end

  def test_should_fail_given_bad_sprite_extensions
    @images_src_path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'sprites', 'public', 'images')
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    importer = Compass::Sprites::Importer.new
    uri = "bad_extensions/*.jpg"
    begin
      Compass::Sprites::Importer.sass_engine(uri, Compass::Sprites::Importer.sprite_name(uri), importer, {})
      assert false, "An invalid sprite file made it past validation."
    rescue Compass::Error => e
      assert e.message.include?("invalid sprite path")
    end
  end
end