require 'test_helper'
require 'compass/sprites/sass_extensions/row_fitter'

class RowFitterTest < Test::Unit::TestCase
  include SpriteHelper
  def setup
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
  end

  def row_fitter(images = nil)
    @row_fitter ||= Compass::SassExtensions::Sprites::RowFitter.new(images)
  end

  def teardown
    @row_fitter = nil
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

  def test_should_use_the_fast_placement_algorithm
    images = create_images(basic_dims)

    row_fitter(images)
    assert_equal 100, row_fitter.width

    row_fitter.fit!(:fast)

    assert_equal 4, row_fitter.rows.length

    assert_equal [ images[0] ], row_fitter[0].images
    assert_equal [ images[1] ], row_fitter[1].images
    assert_equal [ images[2] ], row_fitter[2].images
    assert_equal [ images[3], images[4] ], row_fitter[3].images
  end

  def test_should_use_the_scan_placement_algorithm
    images = create_images(basic_dims)

    row_fitter(images)

    row_fitter.fit!(:scan)

    assert_equal 4, row_fitter.rows.length

    assert_equal [ images[0] ], row_fitter[0].images
    assert_equal [ images[1] ], row_fitter[1].images
    assert_equal [ images[2] ], row_fitter[2].images
    assert_equal [ images[3], images[4] ], row_fitter[3].images
  end
end
