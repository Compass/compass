require 'test_helper'
require 'compass/sass_extensions/sprites/images'

class ImagesTest < Test::Unit::TestCase

  def setup
    @images = Compass::SassExtensions::Sprites::Images.new
    @images << OpenStruct.new(:foo => 1, :name => 'bob', :size => 1200, :width => 10)
    @images << OpenStruct.new(:foo => 2, :name => 'bob', :size => 300, :width => 100)
    @images << OpenStruct.new(:foo => 3, :name => 'aob', :size => 120, :width => 50)
    @images << OpenStruct.new(:foo => 4, :name => 'zbob', :size => 600, :width => 55)
  end


  test "sort by size" do
    @images.sort_by! :size
    assert_equal [3, 2, 4, 1], @images.map(&:foo)
  end

  test "sort by !size" do
    @images.sort_by! '!size'
    assert_equal [3, 2, 4, 1].reverse, @images.map(&:foo)
  end

  test "sort by name" do
    @images.sort_by! :name
    assert_equal [3, 2, 1, 4], @images.map(&:foo)
  end

  test "sort by !name" do
    @images.sort_by! '!name'
    assert_equal [3, 2, 1, 4].reverse, @images.map(&:foo)
  end

  test "sort by width" do
    @images.sort_by! :width
    assert_equal [1, 3, 4, 2], @images.map(&:foo)
  end

    test "sort by !width" do
    @images.sort_by! '!width'
    assert_equal [1, 3, 4, 2].reverse, @images.map(&:foo)
  end

end
  