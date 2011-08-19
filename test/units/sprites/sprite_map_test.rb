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
    @base = sprite_map_test(@options)
    @base.generate
    assert !File.exists?(file), "Sprite file did not get removed"
  end

  it "should have a vertical layout" do
    assert_equal [0, 10, 20, 30], @base.images.map(&:top)
    assert_equal [0, 0, 0, 0], @base.images.map(&:left)
  end
  
  it "should have a vertical layout with spacing" do
    base = sprite_map_test(@options.merge({"spacing" => Sass::Script::Number.new(10, ['px'])}))
    assert_equal [0, 20, 40, 60], base.images.map(&:top)
  end
  
  it "should layout vertical with position" do
    base = sprite_map_test("ten_by_ten_active_position" => Sass::Script::Number.new(10, ['px']))
    assert_equal [0, 10, 0, 0], base.images.map(&:left)
  end
  
  def smart
    options = @options.merge("layout" => Sass::Script::String.new('smart'))
    importer = Compass::SpriteImporter.new
    uri = "image_row/*.png"
    path, name = Compass::SpriteImporter.path_and_name(uri)
    sprite_names = Compass::SpriteImporter.sprite_names(uri)
    sass_engine = Compass::SpriteImporter.sass_engine(uri, name, importer, options)
    Compass::SassExtensions::Sprites::SpriteMap.new(sprite_names.map {|n| "image_row/#{n}.png"}, path, name, sass_engine, options)
  end
  
  it "should have a smart layout" do
    base = smart
    base.generate
    assert_equal 400, base.width
    assert_equal 60, base.height
    assert_equal [[0, 0], [20, 120], [20, 20], [20, 0], [20, 160]], base.images.map {|i| [i.top, i.left]}
    assert File.exists?(base.filename)
    FileUtils.rm base.filename
  end

  def diagonal
    opts = @options.merge("layout" => Sass::Script::String.new('diagonal'))
    sprite_map_test(opts)
  end
  
  it "should generate a diagonal sprite" do
    base = diagonal
    base.generate
    assert_equal 40, base.width
    assert_equal 40, base.height
    assert_equal [[0,0], [10,10], [20,20], [30,30]], base.images.map {|i| [i.top, i.left]}
    assert File.exists?(base.filename)
    FileUtils.rm base.filename
  end

  # Horizontal tests
  def horizontal(options= {})
    opts = @options.merge("layout" => Sass::Script::String.new('horizontal'))
    opts.merge!(options)
    sprite_map_test(opts)
  end
  
  it "should have a horizontal layout" do
    base = horizontal
    assert_equal 10, base.height
    assert_equal 40, base.width
  end
  
  it "should layout images horizontaly" do
    base = horizontal
    assert_equal [0, 10, 20, 30], base.images.map(&:left)
    assert_equal [0, 0, 0, 0], base.images.map(&:top)
  end
  
  it "should layout horizontaly with spacing" do
    base = horizontal("spacing" => Sass::Script::Number.new(10, ['px']))
    assert_equal [0, 20, 40, 60], base.images.map(&:left)
    assert_equal [0, 0, 0, 0], base.images.map(&:top)
    assert_equal 80, base.width
  end
  
  it "should layout horizontaly with position" do
    base = horizontal("ten_by_ten_active_position" => Sass::Script::Number.new(10, ['px']))
    assert_equal [0, 10, 0, 0], base.images.map(&:top)
  end
  
  it "should generate a horrizontal sprite" do
    base = horizontal
    base.generate
    assert File.exists?(base.filename)
    FileUtils.rm base.filename
  end
    
  it "should generate vertical sprites in decending order" do
    sizes = @base.images.map{|image| File.size(image.file) }
    assert_equal sizes.min, File.size(@base.images.first.file)
    assert_equal sizes.max, File.size(@base.images.last.file)
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
  
  
end