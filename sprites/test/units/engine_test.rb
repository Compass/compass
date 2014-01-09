require 'test_helper'

class EngineTest < Test::Unit::TestCase
  include Compass::Sprite::Test::SpriteHelper
  def setup
    create_sprite_temp
    sprite_filename = 'squares/ten-by-ten.png'
    @images = [
       Compass::SassExtensions::Sprites::Image.new(nil, File.join(sprite_filename), {}) 
      ]
    @engine = Compass::SassExtensions::Sprites::Engine.new(100, 100, @images)
  end

  def taredown
    clean_up_sprites
  end
  
  
  def test_should_have_width_of_100
    assert_equal 100, @engine.width
  end
  
  def test_should_have_height_of_100
    assert_equal 100, @engine.height
  end
  
  def test_should_have_correct_images
    assert_equal @images, @engine.images
  end
  
  def test_raises_compass_error_when_calling_save
    begin 
      @engine.save('foo')
      assert false, '#save did not raise an exception'
    rescue Compass::Error
      assert true
    end
  end
  
  def test_raises_compass_error_when_calling_construct_sprite
    begin 
      @engine.construct_sprite
      assert false, '#construct_sprite did not raise an exception'
    rescue Compass::Error
      assert true
    end
  end
end