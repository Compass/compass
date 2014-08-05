require 'test_helper'

class EngineTest < Test::Unit::TestCase
  include SpriteHelper
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
  
  
  test "should have width of 100" do
    assert_equal 100, @engine.width
  end
  
  test "should have height of 100" do
    assert_equal 100, @engine.height
  end
  
  test "should have correct images" do
    assert_equal @images, @engine.images
  end
  
  test "raises Compass::Error when calling save" do
    begin 
      @engine.save('foo')
      assert false, '#save did not raise an exception'
    rescue Compass::Error
      assert true
    end
  end
  
  test "raises Compass::Error when calling construct_sprite" do
    begin 
      @engine.construct_sprite
      assert false, '#construct_sprite did not raise an exception'
    rescue Compass::Error
      assert true
    end
  end
end