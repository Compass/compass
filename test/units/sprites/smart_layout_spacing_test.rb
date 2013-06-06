require 'test_helper'
require 'compass/sass_extensions/sprites/layout'
require 'compass/sass_extensions/sprites/layout/smart'

class SmartLayoutSpacingTest < Test::Unit::TestCase
  include SpriteHelper

  def setup
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
  end


  def create_images_with_spacing(dims)
    dims.collect { |width, height, spacing|
      image = Compass::SassExtensions::Sprites::Image.new('blah', 'blah', {"spacing" => Sass::Script::Number.new(10, ['px'])})
      image.stubs(:width => width, :height => height)
      image 
    }
  end

  def spacing_dims
    [
      [ 100, 10, 10 ],
      [ 80, 10, 20 ],
      [ 50, 10, 20 ],
      [ 35, 10, 10 ],
      [ 20, 10, 10 ]
    ]
  end

  it 'should correctly space the images according to the spacing' do
  	images = create_images_with_spacing(spacing_dims)

  	computed_images, width, height = Compass::SassExtensions::Sprites::Layout::Smart.new(images, nil).properties

  	assert_equal 110, width
  	assert_equal 90, height
  end
end