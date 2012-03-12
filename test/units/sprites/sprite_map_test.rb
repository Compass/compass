require 'test_helper'

class SpriteMapTest < Test::Unit::TestCase
  include SpriteHelper
  
  def setup
    Hash.send(:include, Compass::SassExtensions::Functions::Sprites::VariableReader)
    create_sprite_temp
    file = StringIO.new("images_path = #{@images_tmp_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    Compass.configure_sass_plugin!
    @options = {'cleanup' => Sass::Script::Bool.new(true), 'layout' => Sass::Script::String.new('vertical')}
    @base = sprite_map_test(@options)
  end

  def teardown
    clean_up_sprites
    @base = nil
  end
  
  it "should have the correct size" do
    assert_equal [10,40], @base.size
  end
  
  it "should have the sprite names" do
    assert_equal Compass::SpriteImporter.sprite_names(URI), @base.sprite_names
  end
  
  it 'should have image filenames' do
    assert_equal Dir["#{@images_tmp_path}/selectors/*.png"].sort, @base.image_filenames
  end
  
  it 'should need generation' do
    assert @base.generation_required?
  end
  
  test 'uniqueness_hash' do
    assert_equal '4c703bbc05', @base.uniqueness_hash
  end
  
  it 'should be outdated' do
    assert @base.outdated?
  end

  it 'should have correct filename' do
    assert_equal File.join(@images_tmp_path, "#{@base.path}-s#{@base.uniqueness_hash}.png"), @base.filename
  end
  
  it "should return the 'ten-by-ten' image" do
    assert_equal 'ten-by-ten', @base.image_for('ten-by-ten').name
    assert @base.image_for('ten-by-ten').is_a?(Compass::SassExtensions::Sprites::Image)
  end
  
  %w(target hover active).each do |selector|
    it "should have a #{selector}" do
      assert @base.send(:"has_#{selector}?", 'ten-by-ten')
    end
    
    it "should return #{selector} image class" do
      assert_equal "ten-by-ten_#{selector}", @base.image_for('ten-by-ten').send(:"#{selector}").name
    end
    
  end

  it "should generate sprite" do
    @base.generate
    assert File.exists?(@base.filename)
    assert !@base.generation_required?
    assert !@base.outdated?
  end
  
  it "should remove old sprite when generating new" do
    @base.generate
    file = @base.filename
    assert File.exists?(file), "Original file does not exist"
    file_to_remove = File.join(@images_tmp_path, 'selectors', 'ten-by-ten.png')
    FileUtils.rm file_to_remove
    assert !File.exists?(file_to_remove), "Failed to remove sprite file"
    @base = sprite_map_test(@options)
    @base.generate
    assert !File.exists?(file), "Sprite file did not get removed"
  end
  
  test "should get correct relative_name" do
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
    assert_equal 'foo/my.png', Compass::SassExtensions::Sprites::SpriteMap.relative_name(File.join(other_folder, 'foo/my.png'))
    FileUtils.rm_rf other_folder
  end
  
  test "should create map for nested" do
    base = Compass::SassExtensions::Sprites::SpriteMap.from_uri OpenStruct.new(:value => 'nested/squares/*.png'), @base.instance_variable_get(:@evaluation_context), @options
    assert_equal 'squares', base.name
    assert_equal 'nested/squares', base.path
  end
  
  test "should have correct position on ten-by-ten" do
    percent = Sass::Script::Number.new(50, ['%'])
    base = sprite_map_test(@options.merge('selectors_ten_by_ten_position' => percent))
    assert_equal percent, base.image_for('ten-by-ten').position
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
    image = Compass::SassExtensions::Sprites::Image.new(@base, "foo/my.png", {})
    assert_equal File.join(other_folder, 'foo/my.png'), image.file
    assert_equal 0, image.size
  end
  
end