require 'test_helper'

class LayoutTest < Test::Unit::TestCase
  include SpriteHelper

  def setup
    Hash.send(:include, Compass::Sprites::SassExtensions::Functions::VariableReader)
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
    importer = Compass::Sprites::Importer.new
    uri = "image_row/*.png"
    path, name = Compass::Sprites::Importer.path_and_name(uri)
    sprite_names = Compass::Sprites::Importer.sprite_names(uri)
    sass_engine = Compass::Sprites::Importer.sass_engine(uri, name, importer, options)
    map = Compass::Sprites::SassExtensions::SpriteMap.new(sprite_names.map {|n| "image_row/#{n}.png"}, path, name, sass_engine, options)
    map.options = {:compass => {:logger => Compass::NullLogger.new}}

    map
  end

  def diagonal
    opts = @options.merge("layout" => Sass::Script::String.new('diagonal'))

    sprite_map_test(opts)
  end

  def horizontal(options= {}, uri=URI)
    opts = @options.merge("layout" => Sass::Script::String.new('horizontal'))
    opts.merge!(options)

    sprite_map_test(opts, uri)
  end

  # REPEAT_X

  def test_repeat_x_layout_single_image
    opts = {"repeat_x_three_repeat" => Sass::Script::String.new('repeat-x'), 'sort_by' => Sass::Script::String.new('width')}
    map = sprite_map_test(@options.merge(opts), 'repeat_x/*.png')
    assert_equal 6, map.width
    assert_equal [0, 1, 3, 6, 10, 3, 3], map.images.map(&:top)
    assert_equal [0, 0, 0, 0, 0, 0, 3], map.images.map(&:left)
  end

  def test_repeat_x_layout_multi_image
    opts = {"repeat_x_three_repeat" => Sass::Script::String.new('repeat-x'), "repeat_x_four_repeat" => Sass::Script::String.new('repeat-x')}
    map = sprite_map_test(@options.merge(opts), 'repeat_x/*.png')
    assert_equal 12, map.width
  end

  def test_repeat_y_layout_single_image
    opts = {"layout" => Sass::Script::String.new('horizontal'), "squares_ten_by_ten_repeat" => Sass::Script::String.new('repeat-y')}
    map = sprite_map_test(@options.merge(opts), 'squares/*.png')
    assert_equal 30, map.width
    assert_equal 20, map.height
    assert_equal 3, map.images.size
    assert_equal [[0,0], [0,10], [10,0]], map.images.map { |img| [img.top, img.left] }
    assert map.horizontal?
  end

  def test_repeat_y_layout_multi_image
    opts = {"layout" => Sass::Script::String.new('horizontal'), "repeat_x_three_repeat" => Sass::Script::String.new('repeat-y'), "repeat_x_four_repeat" => Sass::Script::String.new('repeat-y')}
    map = sprite_map_test(@options.merge(opts), 'repeat_x/*.png')
    assert_equal [[0, 0], [0, 5], [0, 9], [0, 10], [0, 13], [4, 5], [8, 5], [3, 10], [6, 10], [9, 10]], map.images.map { |img| [img.top, img.left] }
  end

  # VERTICAL LAYOUT

  def test_should_have_a_vertical_layout
    vert = vertical
    assert_equal [0, 10, 20, 30], vert.images.map(&:top)
    assert_equal [0, 0, 0, 0], vert.images.map(&:left)
    assert vert.vertical?
  end
  
  def test_should_have_a_vertical_layout_with_spacing
    vert = sprite_map_test(@options.merge({"spacing" => Sass::Script::Number.new(10, ['px'])}))
    assert_equal [0, 20, 40, 60], vert.images.map(&:top)
  end
  
  def test_should_layout_vertical_with_position
    vert = sprite_map_test("selectors_ten_by_ten_active_position" => Sass::Script::Number.new(10, ['px']))
    assert_equal [0, 10, 0, 0], vert.images.map(&:left)
  end

  def test_should_generate_vertical_sprites_in_decending_order
    sizes = vertical.images.map{|image| File.size(image.file) }
    assert_equal sizes.min, File.size(vertical.images.first.file)
    assert_equal sizes.max, File.size(vertical.images.last.file)
  end

  # SMART LAYOUT
  
  def test_should_have_a_smart_layout
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
  
  def test_should_generate_a_diagonal_sprite
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
  
 def test_should_have_a_horizontal_layout
    base = horizontal
    assert base.horizontal?
    assert_equal 10, base.height
    assert_equal 40, base.width
  end
  
  def test_should_layout_images_horizontaly
    base = horizontal
    assert_equal [0, 10, 20, 30], base.images.map(&:left)
    assert_equal [0, 0, 0, 0],  base.images.map(&:top)
  end
  
  def test_should_layout_horizontaly_with_spacing
    base = horizontal("spacing" => Sass::Script::Number.new(10, ['px']))
    assert_equal [0, 20, 40, 60], base.images.map(&:left)
    assert_equal [0, 0, 0, 0], base.images.map(&:top)
    assert_equal 80, base.width
  end

  def test_should_layout_horizontaly_with_spacing_and_position
    base = horizontal({"spacing" => Sass::Script::Number.new(10, ['px']), "position" => Sass::Script::Number.new(50, ['%'])}, 'squares/*.png')
    assert_equal [0, 20], base.images.map(&:left)
    assert_equal [5, 0], base.images.map(&:top)
    assert_equal 50, base.width
  end
  
 def test_should_layout_horizontaly_with_position
    base = horizontal("selectors_ten_by_ten_active_position" => Sass::Script::Number.new(10, ['px']))
    assert_equal [0, 10, 0, 0], base.images.map(&:top)
    assert_equal 40, base.width
    assert_equal 20, base.height
  end
  
 def test_should_generate_a_horrizontal_sprite
    base = horizontal
    base.generate
    assert File.exists?(base.filename)
    FileUtils.rm base.filename
  end
    
end
