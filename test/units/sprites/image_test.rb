require 'test_helper'
require 'mocha'
require 'ostruct'

class SpritesImageTest < Test::Unit::TestCase
  include SpriteHelper
  def setup
    create_sprite_temp
  end

  SPRITE_FILENAME =  'selectors/ten-by-ten.png'
  
  def sprite_path 
    File.join(@images_tmp_path, SPRITE_FILENAME)
  end
  
  def sprite_name
    File.basename(SPRITE_FILENAME, '.png')
  end
  
  def digest
    Digest::MD5.file(sprite_path).hexdigest
  end
  
  def test_map(options ={})
    options = {'cleanup' => Sass::Script::Bool.new(true), 'layout' => Sass::Script::String.new('vertical')}.merge(options)
    map = sprite_map_test(options)
  end
  
  def test_image(options ={})
    test_map(options).images.first
  end

  test 'initialize' do
    image = test_image
    assert_equal sprite_name, image.name
    assert_equal sprite_path, image.file
    assert_equal SPRITE_FILENAME, image.relative_file
    assert_equal 10, image.width
    assert_equal 10, image.height
    assert_equal digest, image.digest
    assert_equal 0, image.top
    assert_equal 0, image.left
  end

  test 'hover' do
    assert_equal 'ten-by-ten_hover', test_image.hover.name
  end

  test 'no parent' do
    assert_nil test_image.parent
  end
  
  test 'image type is "global"' do
    image = test_image "ten_by_ten_repeat" => Sass::Script::String.new('global')
    assert_equal 'global', image.repeat
  end
  
  test 'image type is "no-repeat"' do
    assert_equal 'no-repeat', test_image.repeat
  end

  test 'image position' do
    image = test_image "ten_by_ten_position" => Sass::Script::Number.new(100, ["px"])
    assert_equal 100, image.position.value
  end

  test 'image spacing' do
    @spacing = 10
    image = test_image "spacing" => Sass::Script::Number.new(100, ["px"])
    assert_equal 100, image.spacing
  end
  
  test 'offset' do
    image = test_image "ten_by_ten_position" => Sass::Script::Number.new(100, ["px"])
    assert_equal 100, image.offset
  end

  test 'neither, uses 0' do
    img = test_image
    img.position.stubs(:unitless?).returns(false)
    assert_equal 0, img.offset
  end


  test 'gets name for sprite in search path' do
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
    image = Compass::SassExtensions::Sprites::Image.new(test_map, "foo/my.png", {})
    assert_equal File.join(other_folder, 'foo/my.png'), image.file
    assert_equal 0, image.size
    FileUtils.rm_rf other_folder
  end

end
