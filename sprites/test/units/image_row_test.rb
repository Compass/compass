require 'test_helper'

class ImageRowTest < Test::Unit::TestCase
  include SpriteHelper
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
  
  it "should return false if image will not fit in row" do
    image_row(100)
    img = Compass::SassExtensions::Sprites::Image.new(nil, File.join('image_row', 'large.png'), {})
    assert !@image_row.add(img)
  end
  
  it "should have 5 images" do
    populate_row
    assert_equal 5, @image_row.images.size
  end
  
  it "should return max image width" do
    populate_row
    assert_equal 400, @image_row.width
  end
  
  it "should return max image height" do
    populate_row
    assert_equal 40, @image_row.height
  end
  
  it "should have an efficiency rating" do
    populate_row
    assert_equal 1 - (580.0 / 1000.0), @image_row.efficiency
  end
end