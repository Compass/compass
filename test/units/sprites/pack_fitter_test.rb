require 'test_helper'
require 'compass/sass_extensions/sprites/pack_fitter'

class RowFitterTest < Test::Unit::TestCase
  include SpriteHelper
  def setup
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
  end

  def packer(images = nil)
    @packer ||= Compass::SassExtensions::Sprites::PackFitter.new(images)
  end

  def teardown
    @packer = nil
  end

  def create_images(dims)
    dims.collect { |width, height| 
      image = Compass::SassExtensions::Sprites::Image.new('blah', 'blah', {})
      image.stubs(:width => width, :height => height)
      image
    }
  end

  def basic_dims
    [
      [ 100, 10 ],
      [ 80, 10 ],
      [ 50, 10 ],
      [ 35, 10 ],
      [ 20, 10 ]
    ]
  end

  it 'should attempt to pack images' do
    images = create_images(basic_dims)
    packer(images)
    packer.pack!
    assert_equal images.length, packer.images.length

    assert_true packer.packed
    assert_equal 100, packer.width
    assert_equal 30, packer.height
  end
end
