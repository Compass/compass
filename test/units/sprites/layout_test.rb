require 'test_helper'

class LayoutTest < Test::Unit::TestCase
  include SpriteHelper

  def setup
    Hash.send(:include, Compass::SassExtensions::Functions::Sprites::VariableReader)
    clean_up_sprites
    create_sprite_temp
    file = StringIO.new("images_path = #{@images_tmp_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    Compass.configure_sass_plugin!
    @options = {'cleanup' => Sass::Script::Bool.new(true), 'layout' => Sass::Script::String.new('vertical')}
  end

  def teardown
    clean_up_sprites
  end
    
  # HELPERS
  
  def vertical
    opts = @options.merge("layout" => Sass::Script::String.new('vertical'))

    sprite_map_test(opts)
  end

  def smart
    options = @options.merge("layout" => Sass::Script::String.new('smart'))
    importer = Compass::SpriteImporter.new
    uri = "image_row/*.png"
    path, name = Compass::SpriteImporter.path_and_name(uri)
    sprite_names = Compass::SpriteImporter.sprite_names(uri)
    sass_engine = Compass::SpriteImporter.sass_engine(uri, name, importer, options)
    map = Compass::SassExtensions::Sprites::SpriteMap.new(sprite_names.map {|n| "image_row/#{n}.png"}, path, name, sass_engine, options)
    map.options = {:compass => {:logger => Compass::NullLogger.new}}

    map
  end

  def diagonal
    opts = @options.merge("layout" => Sass::Script::String.new('diagonal'))

    sprite_map_test(opts)
  end

  def horizontal(options= {})
    opts = @options.merge("layout" => Sass::Script::String.new('horizontal'))
    opts.merge!(options)

    sprite_map_test(opts)
  end

  # REPEAT_X

  test 'repeat-x layout single image' do
    opts = {"repeat_x_three_repeat" => Sass::Script::String.new('repeat-x')}
    map = sprite_map_test(@options.merge(opts), 'repeat_x/*.png')
    assert_equal 6, map.width
    assert_equal [0, 4, 7, 9, 14, 4, 4], map.images.map(&:top)
    assert_equal [0, 0, 0, 0, 0, 0, 3], map.images.map(&:left)
  end

  test 'repeat-x layout multi image' do
    opts = {"repeat_x_three_repeat" => Sass::Script::String.new('repeat-x'), "repeat_x_four_repeat" => Sass::Script::String.new('repeat-x')}
    map = sprite_map_test(@options.merge(opts), 'repeat_x/*.png')
    assert_equal 12, map.width
  end

  # VERTICAL LAYOUT

  it "should have a vertical layout" do
    vert = vertical
    assert_equal [0, 10, 20, 30], vert.images.map(&:top)
    assert_equal [0, 0, 0, 0], vert.images.map(&:left)
    assert vert.vertical?
  end
  
  it "should have a vertical layout with spacing" do
    vert = sprite_map_test(@options.merge({"spacing" => Sass::Script::Number.new(10, ['px'])}))
    assert_equal [0, 20, 40, 60], vert.images.map(&:top)
  end
  
  it "should layout vertical with position" do
    vert = sprite_map_test("selectors_ten_by_ten_active_position" => Sass::Script::Number.new(10, ['px']))
    assert_equal [0, 10, 0, 0], vert.images.map(&:left)
  end

  it "should generate vertical sprites in decending order" do
    sizes = vertical.images.map{|image| File.size(image.file) }
    assert_equal sizes.min, File.size(vertical.images.first.file)
    assert_equal sizes.max, File.size(vertical.images.last.file)
  end

  # SMART LAYOUT
  
  it "should have a smart layout" do
    base = smart
    base.generate
    assert base.smart?
    assert_equal 400, base.width
    assert_equal 60, base.height
    assert_equal [[0, 0], [20, 120], [20, 0], [20, 100], [20, 160]], base.images.map {|i| [i.top, i.left]}
    assert File.exists?(base.filename)
    FileUtils.rm base.filename
  end

  # DIAGONAL LAYOUT
  
  it "should generate a diagonal sprite" do
    base = diagonal
    base.generate
    assert base.diagonal?
    assert_equal 40, base.width
    assert_equal 40, base.height
    assert_equal [[30, 0], [20, 10], [10, 20], [0, 30]], base.images.map {|i| [i.top, i.left]}
    assert File.exists?(base.filename)
    FileUtils.rm base.filename
  end

  # HORIZONTAL LAYOUT
  
  it "should have a horizontal layout" do
    base = horizontal
    assert base.horizontal?
    assert_equal 10, base.height
    assert_equal 40, base.width
  end
  
  it "should layout images horizontaly" do
    base = horizontal
    assert_equal [0, 10, 20, 30], base.images.map(&:left)
    assert_equal [0, 0, 0, 0],  base.images.map(&:top)
  end
  
  it "should layout horizontaly with spacing" do
    base = horizontal("spacing" => Sass::Script::Number.new(10, ['px']))
    assert_equal [0, 20, 40, 60], base.images.map(&:left)
    assert_equal [0, 0, 0, 0], base.images.map(&:top)
    assert_equal 80, base.width
  end
  
  it "should layout horizontaly with position" do
    base = horizontal("selectors_ten_by_ten_active_position" => Sass::Script::Number.new(10, ['px']))
    assert_equal [0, 10, 0, 0], base.images.map(&:top)
  end
  
  it "should generate a horrizontal sprite" do
    base = horizontal
    base.generate
    assert File.exists?(base.filename)
    FileUtils.rm base.filename
  end
    
end