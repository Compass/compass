require 'test_helper'

class ImageRowTest < Test::Unit::TestCase
  include Compass::Sprites::Test::SpriteHelper
  def setup
    clean_up_sprites
    create_sprite_temp
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    @filenames = %w(large.png large_square.png medium.png tall.png small.png)
    @image_files = Dir["#{@images_src_path}/image_row/*.png"].sort
    @images = @image_files.map do |img|
      img.gsub!("#{@images_src_path}/", '')
      Compass::SassExtensions::Sprites::Image.new(nil, img, {})
    end
    image_row(1000)
  end
  
  def teardown
    clean_up_sprites
  end
  
  def image_row(max)
    @image_row = Compass::SassExtensions::Sprites::ImageRow.new(max)
  end
  
  def populate_row
    @images.each do |image|
      assert @image_row.add(image)
    end
  end
  
  def test_should_return_false_if_image_will_not_fit_in_row
    image_row(100)
    img = Compass::SassExtensions::Sprites::Image.new(nil, File.join('image_row', 'large.png'), {})
    assert !@image_row.add(img)
  end
  
  def test_should_have_5_images
    populate_row
    assert_equal 5, @image_row.images.size
  end
  
  def test_should_return_max_image_width
    populate_row
    assert_equal 400, @image_row.width
  end
  
  def test_should_return_max_image_height
    populate_row
    assert_equal 40, @image_row.height
  end
  
  def test_should_have_an_efficiency_rating
    populate_row
    assert_equal 1 - (580.0 / 1000.0), @image_row.efficiency
  end
end