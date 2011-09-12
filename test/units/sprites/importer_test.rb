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
  
  test "name should return the sprite path and name" do
    assert_equal ['selectors', 'selectors'], @importer.path_and_name(URI)
  end
  
  test "should return all the sprite names" do
    assert_equal ["ten-by-ten", "ten-by-ten_active", "ten-by-ten_hover", "ten-by-ten_target"], @importer.sprite_names(URI)
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
  
  test "should fail given bad sprite extensions" do
    @images_src_path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'sprites', 'public', 'images')
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    importer = Compass::SpriteImporter.new
    begin
      importer.sass_engine('bad_extensions/*.jpg', options)
      assert false, "An invalid sprite file made it past validation."
    rescue Compass::Error => e
      assert e.message.include?('.png')
    end
  end
  
end
