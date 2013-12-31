require 'test_helper'
require 'mocha'
require 'ostruct'

class SpritesImageTest < Test::Unit::TestCase
  include SpriteHelper

  def setup
    create_sprite_temp
  end

  def teardown
    clean_up_sprites
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

  def test_initialize
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

  def test_hover
    assert_equal 'ten-by-ten_hover', test_image.hover.name
  end

  def test_hover_should_find_image_by_underscore_or_dash_in_file_name
    map = test_map(:seperator => '-')
    map.images.each_index do |i|
      if map.images[i].name == 'ten-by-ten_hover'
        map.images[i].stubs(:name).returns('ten-by-ten-hover')
      end
    end
    test_image = map.images.first

    assert_equal 'ten-by-ten-hover', test_image.hover.name
  end

  def test_no_parent
    assert_nil test_image.parent
  end
  
  def test_image_type_is_global_should_raise_exception
    assert_raise ::Compass::SpriteException do
      image = test_image "selectors_ten_by_ten_repeat" => Sass::Script::String.new('global')
      image.repeat
    end
  end
  
  def test_image_type_is_no_repeat
    img = test_image
    assert_equal 'no-repeat', img.repeat
    assert img.no_repeat?
  end

  def test_image_repeat_x
    img = test_image "selectors_ten_by_ten_repeat" => Sass::Script::String.new('repeat-x')
    assert img.repeat_x?
  end

  def test_image_repeat_y
    img = test_image "selectors_ten_by_ten_repeat" => Sass::Script::String.new('repeat-y')
    assert img.repeat_y?
  end

  def test_image_position
    image = test_image "selectors_ten_by_ten_position" => Sass::Script::Number.new(100, ["px"])
    assert_equal 100, image.position.value
  end

  def test_image_spacing
    @spacing = 10
    image = test_image "spacing" => Sass::Script::Number.new(100, ["px"])
    assert_equal 100, image.spacing
  end
  
  def test_offset
    image = test_image "selectors_ten_by_ten_position" => Sass::Script::Number.new(100, ["px"])
    assert_equal 100, image.offset
  end

  def test_neither_uses_0
    img = test_image
    img.position.stubs(:unitless?).returns(false)
    assert_equal 0, img.offset
  end

end
