require 'test_helper'

class ImporterTest < Test::Unit::TestCase
  include SpriteHelper
  
  def setup
    create_sprite_temp
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    @importer = Compass::SpriteImporter.new
  end

  def teardown
    Compass.reset_configuration!
  end
  
  def options
    {:foo => 'bar'}
  end
  
  test "should use search path to find sprites" do
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
    importer = Compass::SpriteImporter.new
    assert_equal 2, Compass.configuration.sprite_load_path.compact.size
    assert Compass.configuration.sprite_load_path.include?(other_folder)
    assert_equal ["bar", "my"], Compass::SpriteImporter.sprite_names(uri)
    
    FileUtils.rm_rf other_folder
  end
  
  test "name should return the sprite name" do
    assert_equal 'selectors', Compass::SpriteImporter.sprite_name(URI)
  end
  
  test "path should return the sprite path" do
    assert_equal 'selectors',  Compass::SpriteImporter.path(URI)
  end
  
  test "should return all the sprite names" do
    assert_equal ["ten-by-ten", "ten-by-ten_active", "ten-by-ten_hover", "ten-by-ten_target"], Compass::SpriteImporter.sprite_names(URI)
  end
  
  test "should have correct mtime" do
    thirtydays = Time.now.to_i + (60*60*24*30)
    file = Dir[File.join(@images_src_path, URI)].sort.first
    File.utime(thirtydays, thirtydays, file)
    assert_equal thirtydays, File.mtime(file).to_i
    assert_equal thirtydays, @importer.mtime(URI, {}).to_i
  end
  
  test "should return sass engine on find" do
    assert @importer.find(URI, {}).is_a?(Sass::Engine)
  end
  
  test "sass options should contain options" do
    opts = Compass::SpriteImporter.sass_options('foo', @importer, options)
    assert_equal 'bar', opts[:foo]
  end
  
  test "verify that the sass_engine passes the correct filename" do
    importer = Compass::SpriteImporter.new
    engine = Compass::SpriteImporter.sass_engine(URI, 'foo', importer, options)
    assert_equal engine.options[:filename], URI
  end
  
  test "should fail given bad sprite extensions" do
    @images_src_path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'sprites', 'public', 'images')
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    importer = Compass::SpriteImporter.new
    uri = "bad_extensions/*.jpg"
    begin
      Compass::SpriteImporter.sass_engine(uri, Compass::SpriteImporter.sprite_name(uri), importer, {})
      assert false, "An invalid sprite file made it past validation."
    rescue Compass::Error => e
      assert e.message.include?("invalid sprite path")
    end
  end
  
end