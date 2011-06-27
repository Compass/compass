require 'test_helper'
require 'timecop'
class ImporterTest < Test::Unit::TestCase
  URI = "selectors/*.png"
  
  def setup
    @images_src_path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'sprites', 'public', 'images')
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