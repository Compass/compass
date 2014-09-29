require 'test_helper'
require 'compass/sprites/sass_extensions/pack_fitter'

class PackFitterTest < Test::Unit::TestCase
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
    dims.collect { |width, height, spacing| 
      image = Compass::Sprites::SassExtensions::Image.new('blah', 'blah', {})
      image.stubs(:width => width, :height => height, :spacing => spacing)
      image
    }
  end

  def basic_dims
    [
      [ 100, 10, 0 ],
      [ 80, 10, 0 ],
      [ 50, 10, 0 ],
      [ 35, 10, 10 ],
      [ 20, 10, 20 ]
    ]
  end

  it 'should attempt to pack images' do
    images = create_images(basic_dims)
    packer(images)
    packer.pack!
    assert_equal images.length, packer.images.length

    assert packer.packed
    assert_equal 150, packer.width
    assert_equal 100, packer.height
  end
end
