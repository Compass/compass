require 'test_helper'
require 'mocha'
require 'ostruct'

class SpritesImageTest < Test::Unit::TestCase
  include SpriteHelper
  def setup
    create_sprite_temp
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    @repeat = 'no-repeat'
    @spacing = 0
    @position = 100
    @offset = 100
  end

  let(:sprite_filename) { 'squares/ten-by-ten.png' }
  let(:sprite_path) { File.join(@images_tmp_path, sprite_filename) }
  let(:sprite_name) { File.basename(sprite_filename, '.png') }
  
  
  def options
    options = {:offset => @offset}
    options.stubs(:get_var).with(anything).returns(nil)
    ::OpenStruct.any_instance.stubs(:unitless?).returns(true)
    options.stubs(:get_var).with("#{sprite_name}-repeat").returns(::OpenStruct.new(:value => @repeat))
    options.stubs(:get_var).with("#{sprite_name}-spacing").returns(::OpenStruct.new(:value => @spacing))
    options.stubs(:get_var).with("#{sprite_name}-position").returns(::OpenStruct.new(:value => @position))
    options.stubs(:get_var).with("layout").returns(::OpenStruct.new(:value => 'vertical'))
    options
  end
  

  
  let(:digest) { Digest::MD5.file(sprite_path).hexdigest }


  let(:image) { Compass::SassExtensions::Sprites::Image.new(sprite_map_test(options), File.join(sprite_filename), options)}

  test 'initialize' do
    assert_equal sprite_name, image.name
    assert_equal sprite_path, image.file
    assert_equal sprite_filename, image.relative_file
    assert_equal 10, image.width
    assert_equal 10, image.height
    assert_equal digest, image.digest
    assert_equal 0, image.top
    assert_equal 0, image.left
  end

  test 'hover' do
    assert_equal 'ten-by-ten_hover', image.hover.name
  end

  test 'no parent' do
    assert_nil image.parent
  end

  test 'image type is nil' do
    @repeat = nil
    assert_nil image.repeat
  end

  
  test 'image type is "global"' do
    @repeat = 'global'
    assert_equal @repeat, image.repeat
  end
  
  test 'image type is "no-repeat"' do
    assert_equal 'no-repeat', image.repeat
  end

  test 'image position' do
    assert_equal Sass::Script::Number.new(100, ["px"]).value, image.position.value
  end

  test 'image spacing' do
    @spacing = 10
    assert_equal @spacing, image.spacing
  end
  
  test 'offset' do
    assert_equal @offset, image.offset
  end

  test 'neither, uses 0' do
    @offset = 0
    img = image
    img.position.stubs(:unitless?).returns(false)
    assert_equal 0, img.offset
  end


  test 'gets name for sprite in search path' do
    Compass.reset_configuration!
    uri = 'foo/*.png'
    other_folder = File.join(@images_tmp_path, '../other-temp')
    FileUtils.mkdir_p other_folder
    FileUtils.mkdir_p File.join(other_folder, 'foo')
    %w(my bar).each do |file|
      FileUtils.touch(File.join(other_folder, "foo/#{file}.png"))
    end
    config = Compass::Configuration::Data.new('config')
    config.images_path = @images_tmp_path
    config.sprite_load_path = [@images_tmp_path, other_folder]
    Compass.add_configuration(config, "sprite_config")
    image = Compass::SassExtensions::Sprites::Image.new(sprite_map_test(options), "foo/my.png", options)
    assert_equal File.join(other_folder, 'foo/my.png'), image.file
    assert_equal 0, image.size
    FileUtils.rm_rf other_folder
  end

end
