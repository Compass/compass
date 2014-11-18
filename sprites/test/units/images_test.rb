require 'test_helper'
require 'compass/sprites/sass_extensions/images'

class ImagesTest < Test::Unit::TestCase

  def setup
    @images = Compass::Sprites::SassExtensions::Images.new
    @images << OpenStruct.new(:foo => 1, :name => 'bob', :size => 1200, :width => 10)
    @images << OpenStruct.new(:foo => 2, :name => 'bob', :size => 300, :width => 100)
    @images << OpenStruct.new(:foo => 3, :name => 'aob', :size => 120, :width => 50)
    @images << OpenStruct.new(:foo => 4, :name => 'zbob', :size => 600, :width => 55)
  end


  def test_sort_by_size
    @images.sort_by! :size
    assert_equal [3, 2, 4, 1], @images.map(&:foo)
  end

  def test_sort_by_size_with_bang
    @images.sort_by! '!size'
    assert_equal [3, 2, 4, 1].reverse, @images.map(&:foo)
  end

  def test_sort_by_name
    @images.sort_by! :name
    assert_equal [3, 2, 1, 4], @images.map(&:foo)
  end

  def test_sort_by_name_with_bang
    @images.sort_by! '!name'
    assert_equal [3, 2, 1, 4].reverse, @images.map(&:foo)
  end

  def test_sort_by_width
    @images.sort_by! :width
    assert_equal [1, 3, 4, 2], @images.map(&:foo)
  end

  def test_sort_by_width_with_bang
    @images.sort_by! '!width'
    assert_equal [1, 3, 4, 2].reverse, @images.map(&:foo)
  end

end
  