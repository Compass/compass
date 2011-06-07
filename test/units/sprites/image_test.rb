require 'test_helper'
require 'mocha'
require 'ostruct'
class SpritesImageTest < Test::Unit::TestCase


  def setup
    @images_src_path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'sprites', 'public', 'images')
    file = StringIO.new("images_path = #{@images_src_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    @repeat = 'no-repeat'
    @spacing = 0
    @position = 100
    @offset = 100
  end

  let(:sprite_filename) { 'squares/ten-by-ten.png' }
  let(:sprite_path) { File.join(@images_src_path, sprite_filename) }
  let(:sprite_name) { File.basename(sprite_filename, '.png') }
  
  def parent
    importer = Compass::SpriteImporter.new(:uri => "selectors/*.png", :options => options)
    @parent ||= Compass::SassExtensions::Sprites::SpriteMap.new(importer.sprite_names.map{|n| "selectors/#{n}.png"}, importer.path, importer.name, importer.sass_engine, importer.options)
  end
  
  let(:options) do
    options = {:offset => @offset}
    options.stubs(:get_var).with(anything).returns(nil)
    ::OpenStruct.any_instance.stubs(:unitless?).returns(true)
    options.stubs(:get_var).with("#{sprite_name}-repeat").returns(::OpenStruct.new(:value => @repeat))
    options.stubs(:get_var).with("#{sprite_name}-spacing").returns(::OpenStruct.new(:value => @spacing))
    options.stubs(:get_var).with("#{sprite_name}-position").returns(::OpenStruct.new(:value => @position))
    options
  end
  

  
  let(:digest) { Digest::MD5.file(sprite_path).hexdigest }


  let(:image) { Compass::SassExtensions::Sprites::Image.new(parent, File.join(sprite_filename), options)}

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

end
