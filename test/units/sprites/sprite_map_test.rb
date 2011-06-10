require 'test_helper'

class SpriteMapTest < Test::Unit::TestCase
  
  def setup
    Hash.send(:include, Compass::SassExtensions::Functions::Sprites::VariableReader)
    @images_src_path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'sprites', 'public', 'images')
    @images_tmp_path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'sprites', 'public', 'images-tmp')
    FileUtils.cp_r @images_src_path, @images_tmp_path
    config = Compass::Configuration::Data.new('config')
    config.images_path = @images_tmp_path
    Compass.add_configuration(config)
    Compass.configure_sass_plugin!
    @options = {'cleanup' => Sass::Script::Bool.new(true)}
    setup_map
  end
  
  def setup_map
    @importer = Compass::SpriteImporter.new(:uri => "selectors/*.png", :options => @options)
    @base = Compass::SassExtensions::Sprites::SpriteMap.new(@importer.sprite_names.map{|n| "selectors/#{n}.png"}, @importer.path, @importer.name, @importer.sass_engine, @importer.options)
  end

  def teardown
    FileUtils.rm_r @images_tmp_path
  end
  
  it "should have the correct size" do
    assert_equal [10,40], @base.size
  end
  
  it "should have the sprite names" do
    assert_equal @importer.sprite_names, @base.sprite_names
  end
  
  it 'should have image filenames' do
    assert_equal Dir["#{@images_tmp_path}/selectors/*.png"].sort, @base.image_filenames
  end
  
  it 'should need generation' do
    assert @base.generation_required?
  end
  
  test 'uniqueness_hash' do
    assert_equal 'ef52c5c63a', @base.uniqueness_hash
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
    setup_map
    @base.generate
    assert !File.exists?(file), "Sprite file did not get removed"
  end
  
end