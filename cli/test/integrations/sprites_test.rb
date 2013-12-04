require 'test_helper'
require 'fileutils'
require 'compass'
require 'compass/logger'
require 'sass/plugin'


class SpritesTest < Test::Unit::TestCase
  
  def setup
    Compass.reset_configuration!
    @images_project_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'sprites', 'public'))
    @images_src_dir = 'images'
    @images_src_path = File.join(@images_project_path, @images_src_dir)
    @images_tmp_dir = 'images-tmp'
    @images_tmp_path = File.join(@images_project_path, @images_tmp_dir)
    @generated_images_tmp_dir = 'generated-images-tmp'
    @generated_images_tmp_path = File.join(@images_project_path, @generated_images_tmp_dir)
    ::FileUtils.cp_r @images_src_path, @images_tmp_path
    ::FileUtils.mkdir_p @generated_images_tmp_path
    file = StringIO.new(<<-CONFIG)
      project_path = "#{@images_project_path}"
      images_dir = "#{@images_tmp_dir}"
    CONFIG
    Compass.add_configuration(file, "sprite_config")
    Compass.configure_sass_plugin!
  end

  def teardown
    Compass.reset_configuration!
    ::FileUtils.rm_r @images_tmp_path
    ::FileUtils.rm_rf @generated_images_tmp_path
  end


  def map_location(file)
    map_files(file).first
  end
  
  def map_files(glob)
    Dir.glob(File.join(@images_tmp_path, glob))
  end

  def image_size(file)
    Compass::Core::SassExtensions::Functions::ImageSize::ImageProperties.new(map_location(file)).size
  end

  def image_md5(file)
    md5 = Digest::MD5.new
    md5.update IO.read(map_location(file))
    md5.hexdigest
  end

  def render(scss)
    options = Compass.sass_engine_options
    options[:line_comments] = false
    options[:style] = :expanded
    options[:syntax] = :scss
    options[:compass] ||= {}
    options[:compass][:logger] ||= Compass::NullLogger.new
    css = Sass::Engine.new(scss, options).render
    # reformat to fit result of heredoc:
    "      #{css.gsub('@charset "UTF-8";', '').gsub(/\n/, "\n      ").strip}\n"
  end
  
  def clean(string)
    string.gsub("\n", '').gsub(' ', '')
  end
  
  it "should generate sprite classes" do
    css = render <<-SCSS
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images-tmp/squares-sbbc18e2129.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -10px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
    assert_equal image_md5('squares-s*.png'), '7349a0f4e88ea80abddcf6ac2486abe3'
  end

  it "should output and serve sprite files using the generated images directory" do
    Compass.reset_configuration!
    file = StringIO.new(<<-CONFIG)
      images_path = #{@images_tmp_path.inspect}
      generated_images_path = #{@generated_images_tmp_path.inspect}
      http_generated_images_path = "/images/generated"
    CONFIG
    Compass.add_configuration(file, "sprite_config")
    Compass.configure_sass_plugin!
    css = render <<-SCSS
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_not_nil Dir.glob("#{@generated_images_tmp_path}/squares-s*.png").first
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images/generated/squares-sbbc18e2129.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -10px;
      }
    CSS
  end

  it "should generate sprite classes with dimensions" do
    css = render <<-SCSS
      $squares-sprite-dimensions: true;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images-tmp/squares-sbbc18e2129.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
        height: 10px;
        width: 10px;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -10px;
        height: 20px;
        width: 20px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
  end

  it "should provide sprite mixin" do
    css = render <<-SCSS
      @import "squares/*.png";

      .cubicle {
        @include squares-sprite("ten-by-ten");
      }

      .large-cube {
        @include squares-sprite("twenty-by-twenty", true);
      }
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .cubicle, .large-cube {
        background-image: url('/images-tmp/squares-sbbc18e2129.png');
        background-repeat: no-repeat;
      }
      
      .cubicle {
        background-position: 0 0;
      }
      
      .large-cube {
        background-position: 0 -10px;
        height: 20px;
        width: 20px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
  end

  # CUSTOMIZATIONS:

  it "should be possible to change the base class" do
    css = render <<-SCSS
      $squares-sprite-base-class: ".circles";
      @import "squares/*.png";
    SCSS
    assert_correct <<-CSS, css
      .circles {
        background-image: url('/images-tmp/squares-sbbc18e2129.png');
        background-repeat: no-repeat;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
  end

  it "should calculate the spacing between images but not before first image" do
    css = render <<-SCSS
      $squares-ten-by-ten-spacing: 33px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images-tmp/squares-s563a5e0855.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -43px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 63]
  end

  it "should calculate the spacing between images" do
    css = render <<-SCSS
      $squares-twenty-by-twenty-spacing: 33px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images-tmp/squares-s4ea353fa6d.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -43px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 63]
  end

  it "should calculate the maximum spacing between images" do
    css = render <<-SCSS
      $squares-ten-by-ten-spacing: 44px;
      $squares-twenty-by-twenty-spacing: 33px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images-tmp/squares-sf4771cb124.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -54px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 74]
  end

  it "should calculate the maximum spacing between images in reversed order" do
    css = render <<-SCSS
      $squares-ten-by-ten-spacing: 33px;
      $squares-twenty-by-twenty-spacing: 44px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images-tmp/squares-sc82d6f3cf4.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -54px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 74]
  end

  it "should calculate the default spacing between images" do
    css = render <<-SCSS
      $squares-spacing: 22px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images-tmp/squares-s2f4aa65dcf.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -32px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 52]
  end

  it "should use position adjustments in functions" do
    css = render <<-SCSS
      $squares: sprite-map("squares/*.png", $position: 100%);
      .squares-sprite {
        background-image: $squares;
        background-repeat: no-repeat;
      }

      .adjusted-percentage {
        background-position: sprite-position($squares, ten-by-ten, 100%);
      }

      .adjusted-px-1 {
        background-position: sprite-position($squares, ten-by-ten, 4px);
      }

      .adjusted-px-2 {
        background-position: sprite-position($squares, twenty-by-twenty, -3px, 2px);
      }
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite {
        background-image: url('/images-tmp/squares-sce5dc30797.png');
        background-repeat: no-repeat;
      }
      
      .adjusted-percentage {
        background-position: 100% 0;
      }
      
      .adjusted-px-1 {
        background-position: -6px 0;
      }
      
      .adjusted-px-2 {
        background-position: -3px -8px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
    assert_equal image_md5('squares-s*.png'), '9cc7ce48cfaf304381c2d08adefd2fb6'
  end

  it "should use position adjustments in mixins" do
    css = render <<-SCSS
      $squares-position: 100%;
      @import "squares/*.png";

      .adjusted-percentage {
        @include squares-sprite("ten-by-ten", $offset-x: 100%);
      }

      .adjusted-px-1 {
        @include squares-sprite("ten-by-ten", $offset-x: 4px);
      }

      .adjusted-px-2 {
        @include squares-sprite("twenty-by-twenty", $offset-x: -3px, $offset-y: 2px);
      }
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .adjusted-percentage, .adjusted-px-1, .adjusted-px-2 {
        background-image: url('/images-tmp/squares-sce5dc30797.png');
        background-repeat: no-repeat;
      }
      
      .adjusted-percentage {
        background-position: 100% 0;
      }
      
      .adjusted-px-1 {
        background-position: -6px 0;
      }
      
      .adjusted-px-2 {
        background-position: -3px -8px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
    assert_equal image_md5('squares-s*.png'), '9cc7ce48cfaf304381c2d08adefd2fb6'
  end

  it "should repeat the image" do
    css = render <<-SCSS
      $squares-repeat: repeat-x;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images-tmp/squares-s65c43cd573.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -10px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
    assert_equal image_md5('squares-s*.png'), 'a77a2fd43f04d791722b706aa7c9f1c1'
  end

  it "should allow the position of a sprite to be specified in absolute pixels" do
    css = render <<-SCSS
      $squares-ten-by-ten-position: 10px;
      $squares-twenty-by-twenty-position: 10px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background-image: url('/images-tmp/squares-sb9d9a8ca6a.png');
        background-repeat: no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: -10px 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: -10px -10px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [30, 30]
    assert_equal image_md5('squares-s*.png'), '9856ced9e8211b6b28ff782019a0d905'
  end

  it "should provide a nice errors for lemonade's old users" do
    assert_raise(Sass::SyntaxError) do
      render <<-SCSS
        .squares {
          background-image: sprite-url("squares/*.png");
          background-repeat: no-repeat;
        }
      SCSS
    end
    
    assert_raise(Sass::SyntaxError) do
      css = render <<-SCSS
        @import "squares/*.png";

        .squares {
          background-image: sprite-position("squares/twenty-by-twenty.png");
          background-repeat: no-repeat;
        }
      SCSS
    end
  end

  it "should work even if @import is missing" do
    css = render <<-SCSS
      .squares {
        background-image: sprite(sprite-map("squares/*.png"), twenty-by-twenty);
        background-repeat: no-repeat;
      }
    SCSS
    assert_correct <<-CSS, css
      .squares {
        background-image: url('/images-tmp/squares-sd817b59156.png') 0 -10px;
        background-repeat: no-repeat;
      }
    CSS
  end

  it "should import sprites with numeric filenames via #738" do
    css = render <<-SCSS
      @import "numeric/*.png";
      @include all-numeric-sprites;
    SCSS
    assert_correct <<-CSS, css
      .numeric-sprite, .numeric-200 {
        background-image: url('/images-tmp/numeric-saa92d65a89.png');
        background-repeat: no-repeat;
      }
      
      .numeric-200 {
        background-position: 0 0;
      }
    CSS
  end
 
  it "should use percentage positions when use_percentages is true" do
    css = render <<-SCSS
      @import "squares/*.png";
      $squares-use-percentages: true;
      .foo {
        @include squares-sprite-position("twenty-by-twenty");
      }
      .bar {
        @include squares-sprite-position("ten-by-ten");
        @include squares-sprite-dimensions("ten-by-ten");
      }
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite {
        background-image: url('/images-tmp/squares-sbbc18e2129.png');
        background-repeat: no-repeat;
      }
      
      .foo {
        background-position: 0 100%;
      }
      
      .bar {
        background-position: 0 0;
        height: 10px;
        width: 10px;
      }
    CSS
  end
  
  it "should use correct percentages when use_percentages is with horizontal layout" do
    css = render <<-SCSS
      $squares-layout: horizontal;
      @import "squares/*.png";
      $squares-use-percentages: true;
      .foo {
        @include squares-sprite-position("twenty-by-twenty");
      }
      .bar {
        @include squares-sprite-position("ten-by-ten");
      }
    SCSS
    assert_correct <<-CSS, css
      .squares-sprite {
        background-image: url('/images-tmp/squares-s4bd95c5c56.png');
        background-repeat: no-repeat;
      }
      
      .foo {
        background-position: 100% 0;
      }
      
      .bar {
        background-position: 0 0;
      }
    CSS
  end

  it "should use correct percentages when use_percentages is true with smart layout" do
    css = render <<-SCSS
      $image_row-layout: smart;
      @import "image_row/*.png";
      $image_row-use-percentages: true;
      .foo {
        @include image_row-sprite-position("medium");
      }
      .bar {
        @include image_row-sprite-position("large_square");
      }
    SCSS
    assert_correct <<-CSS, css
      .image_row-sprite {
        background-image: url('/images-tmp/image_row-sc5082a6b9f.png');
        background-repeat: no-repeat;
      }
      
      .foo {
        background-position: 0 50%;
      }
      
      .bar {
        background-position: 33.33333% 100%;
      }
    CSS
  end

  it "should use correct percentages when use_percentages is true" do
    css = render <<-SCSS
      $image_row-use-percentages: true;
      $image_row-sort-by : '!width';
      @import "image_row/*.png";
      @include all-image_row-sprites;
    SCSS
    assert_correct <<-CSS, css
      .image_row-sprite, .image_row-large, .image_row-large_square, .image_row-medium, .image_row-small, .image_row-tall {
        background-image: url('/images-tmp/image_row-sdf383d45a3.png');
        background-repeat: no-repeat;
      }
      
      .image_row-large {
        background-position: 0 0;
      }
      
      .image_row-large_square {
        background-position: 0 40%;
      }
      
      .image_row-medium {
        background-position: 0 16.66667%;
      }
      
      .image_row-small {
        background-position: 0 100%;
      }
      
      .image_row-tall {
        background-position: 0 80%;
      }
    CSS
  end
  
  it "should calculate corret sprite demsions when givin spacing via issue#253" do
    css = render <<-SCSS
      $squares-spacing: 10px;
      @import "squares/*.png";
      .foo {
        @include sprite-background-position($squares-sprites, "twenty-by-twenty");
      }
      .bar {
        @include sprite-background-position($squares-sprites, "ten-by-ten");
      }
    SCSS
    assert_equal image_size('squares-s*.png'), [20, 40]
    assert_correct <<-CSS, css
      .squares-sprite {
        background-image: url('/images-tmp/squares-s555875d730.png');
        background-repeat: no-repeat;
      }
      
      .foo {
        background-position: 0 -20px;
      }
      
      .bar {
        background-position: 0 0;
      }
    CSS
  end

  it "should render correct sprite with css selectors via issue#248" do
    css = render <<-SCSS
      @import "selectors/*.png";
      @include all-selectors-sprites;
    SCSS
    assert_correct <<-CSS, css
      .selectors-sprite, .selectors-ten-by-ten {
        background-image: url('/images-tmp/selectors-s7e84acb3d2.png');
        background-repeat: no-repeat;
      }
      
      .selectors-ten-by-ten {
        background-position: 0 0;
      }
      .selectors-ten-by-ten:hover, .selectors-ten-by-ten.ten-by-ten-hover {
        background-position: 0 -20px;
      }
      .selectors-ten-by-ten:target, .selectors-ten-by-ten.ten-by-ten-target {
        background-position: 0 -30px;
      }
      .selectors-ten-by-ten:active, .selectors-ten-by-ten.ten-by-ten-active {
        background-position: 0 -10px;
      }
    CSS
  end
  
  it "should honor offsets when rendering selectors via issue#449" do
    css = render <<-SCSS
      @import "selectors/*.png";
      @include all-selectors-sprites($offset-x: 20px, $offset-y: 20px);
    SCSS
    assert_correct <<-CSS, css
      .selectors-sprite, .selectors-ten-by-ten {
        background-image: url('/images-tmp/selectors-s7e84acb3d2.png');
        background-repeat: no-repeat;
      }
      
      .selectors-ten-by-ten {
        background-position: 20px 20px;
      }
      .selectors-ten-by-ten:hover, .selectors-ten-by-ten.ten-by-ten-hover {
        background-position: 20px 0;
      }
      .selectors-ten-by-ten:target, .selectors-ten-by-ten.ten-by-ten-target {
        background-position: 20px -10px;
      }
      .selectors-ten-by-ten:active, .selectors-ten-by-ten.ten-by-ten-active {
        background-position: 20px 10px;
      }
    CSS
  end

  it "should render correct sprite with css selectors via magic mixin" do
    css = render <<-SCSS
      @import "selectors/*.png";
      a {
        @include selectors-sprite(ten-by-ten)
      }
    SCSS
    assert_correct <<-CSS, css
      .selectors-sprite, a {
        background-image: url('/images-tmp/selectors-s7e84acb3d2.png');
        background-repeat: no-repeat;
      }
      
      a {
        background-position: 0 0;
      }
      a:hover, a.ten-by-ten-hover {
        background-position: 0 -20px;
      }
      a:target, a.ten-by-ten-target {
        background-position: 0 -30px;
      }
      a:active, a.ten-by-ten-active {
        background-position: 0 -10px;
      }
    CSS
  end

  
  it "should not render corret sprite with css selectors via magic mixin" do
    css = render <<-SCSS
      @import "selectors/*.png";
      a {
        $disable-magic-sprite-selectors:true !global;
        @include selectors-sprite(ten-by-ten)
      }
    SCSS
    assert_correct <<-CSS, css
      .selectors-sprite, a {
        background-image: url('/images-tmp/selectors-s7e84acb3d2.png');
        background-repeat: no-repeat;
      }
      
      a {
        background-position: 0 0;
      }
    CSS
  end

  it "should render corret sprite with css selectors via magic mixin with the correct offsets" do
    css = render <<-SCSS
      @import "selectors/*.png";
      a {
        @include selectors-sprite(ten-by-ten, false, 5, -5)
      }
    SCSS
    assert_correct <<-CSS, css
      .selectors-sprite, a {
        background-image: url('/images-tmp/selectors-s7e84acb3d2.png');
        background-repeat: no-repeat;
      }
      
      a {
        background-position: 5px -5px;
      }
      a:hover, a.ten-by-ten-hover {
        background-position: 5px -25px;
      }
      a:target, a.ten-by-ten-target {
        background-position: 5px -35px;
      }
      a:active, a.ten-by-ten-active {
        background-position: 5px -15px;
      }
    CSS
  end
  
  it "should not raise error on filenames that are invalid classnames if the selector generation is not used" do
    css = render <<-SCSS
      $prefix-sort-by : 'width';
      @import "prefix/*.png";
      a {
        @include prefix-sprite("20-by-20");
      }
    SCSS
    assert_correct <<-CSS, css
      .prefix-sprite, a {
        background-image: url('/images-tmp/prefix-s949dea513d.png');
        background-repeat: no-repeat;
      }
      
      a {
        background-position: 0 -10px;
      }
    CSS
  end

  it "should generate sprite with bad repeat-x dimensions" do
    css = render <<-SCSS
      $ko-starbg26x27-repeat: repeat-x;
      @import "ko/*.png";
      @include all-ko-sprites;
    SCSS
    assert_correct <<-CSS, css
      .ko-sprite, .ko-default_background, .ko-starbg26x27 {
        background-image: url('/images-tmp/ko-sd46dfbab4f.png');
        background-repeat: no-repeat;
      }
      
      .ko-default_background {
        background-position: 0 0;
      }
      
      .ko-starbg26x27 {
        background-position: 0 -128px;
      }
    CSS
  end
  
  it "should generate a sprite and remove the old file" do
    FileUtils.touch File.join(@images_tmp_path, "selectors-scc8834Fdd.png")
    assert_equal 1, map_files('selectors-s*.png').size
    css = render <<-SCSS
      @import "selectors/*.png";
      a {
        $disable-magic-sprite-selectors:true !global;
        @include selectors-sprite(ten-by-ten)
      }
    SCSS
    assert_equal 1, map_files('selectors-s*.png').size, "File was not removed"
  end
  
  it "should generate a sprite and NOT remove the old file" do
    FileUtils.touch File.join(@images_tmp_path, "selectors-scc8834Ftest.png")
    assert_equal 1, map_files('selectors-s*.png').size
    css = render <<-SCSS
      $selectors-clean-up: false;
      @import "selectors/*.png";
      a {
        $disable-magic-sprite-selectors:true !global;
        @include selectors-sprite(ten-by-ten)
      }
    SCSS
    assert_equal 2, map_files('selectors-s*.png').size, "File was removed"
  end
  
  it "should generate a sprite if the sprite is a bool" do
    css = render <<-SCSS
      @import "bool/*.png";
      a {
        @include bool-sprite(false);
      }
      a {
        @include bool-sprite(true);
      }
    SCSS
    assert !css.empty?
  end
  
  
  it "should generate a sprite if the sprite is a colorname" do
    css = render <<-SCSS
      @import "colors/*.png";
      a {
        @include colors-sprite(blue);
      }
    SCSS
    assert !css.empty?
  end
  
  it "should generate a sprite from nested folders" do
    css = render <<-SCSS
      @import "nested/**/*.png";
      @include all-nested-sprites;
    SCSS
    assert_correct <<-CSS, css
      .nested-sprite, .nested-ten-by-ten {
        background-image: url('/images-tmp/nested-s7b93e0b6bf.png');
        background-repeat: no-repeat;
      }
      
      .nested-ten-by-ten {
        background-position: 0 0;
      }
    CSS
  end
    
  it "should create horizontal sprite" do
    css = render <<-SCSS
      $squares-layout:horizontal;
      @import "squares/*.png";
      .foo {
        @include sprite-background-position($squares-sprites, "twenty-by-twenty");
      }
      .bar {
        @include sprite-background-position($squares-sprites, "ten-by-ten");
      }
    SCSS
    assert_equal [30, 20], image_size('squares-s*.png')
    other_css = <<-CSS
      .squares-sprite {
        background-image: url('/images-tmp/squares-s4bd95c5c56.png');
        background-repeat: no-repeat;
      }

      .foo {
        background-position: -10px 0;
      }

      .bar {
        background-position: 0 0;
      }
    CSS
    assert_correct clean(other_css), clean(css)
  end

  it "should allow use of demension functions" do
    css = render <<-SCSS
      @import "squares/*.png";
      $h: squares-sprite-height(twenty-by-twenty);
      $w: squares-sprite-width(twenty-by-twenty);
      .div {
        height:$h + 1px;
        width:$w + 2px;
      }
    SCSS
    other_css = <<-CSS
      .squares-sprite {
        background-image: url('/images-tmp/squares-sbbc18e2129.png');
        background-repeat: no-repeat;
      }
      .div {
        height:21px;
        width:22px;
      }
    CSS
    assert_correct clean(other_css), clean(css)
  end

  it "should replace text with images and dimensions using sprites" do
     css = render <<-SCSS
     @import "compass/utilities/sprites/sprite-img";
     @import "colors/*.png";
     .blue { 
       @include sprite-replace-text($colors-sprites, blue); 
     }
     .yellow {
       @include sprite-replace-text-with-dimensions($colors-sprites, yellow);
     }
     SCSS
     other_css = <<-CSS
      .colors-sprite {
        background-image:url('/images-tmp/colors-s58671cb5bb.png');
        background-repeat: no-repeat;
      }
      .blue { 
        text-indent:-119988px;
        overflow:hidden;
        text-align:left;
        text-transform: capitalize;
        background-position:0 0;
        background-image:url('/images-tmp/colors-s58671cb5bb.png');
        background-repeat:no-repeat;
      }
      
      .yellow { 
        text-indent:-119988px;
        overflow:hidden;
        text-align:left;
        text-transform: capitalize;
        background-position:0 -10px;
        height:10px;
        width:10px;
        background-image:url('/images-tmp/colors-s58671cb5bb.png');
        background-repeat:no-repeat;
        }
     CSS
     assert_correct clean(other_css), clean(css)
   end
   
   it "should inline the sprite file" do
    Compass.reset_configuration!
    file = StringIO.new(<<-CONFIG)
      images_path = #{@images_tmp_path.inspect}
      generated_images_path = #{@generated_images_tmp_path.inspect}
    CONFIG
    Compass.add_configuration(file, "sprite_config")
    Compass.configure_sass_plugin!
    css = render <<-SCSS
      $colors-inline:true;
      @import "colors/*.png";
      @include all-colors-sprites;
     SCSS
    other_css = <<-CSS
      .colors-sprite, .colors-blue, .colors-yellow {
        background-image:url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAUCAAAAACRhfOKAAAAHElEQVR42mM5wQADLP8JMRlIUIvE/IdgctLTNgCHDhEQVD4ceAAAAABJRU5ErkJggg==');
      }
      .colors-blue { 
        background-position:0 0;
      }
      .colors-yellow {
        background-position:0 -10px;
      }
    CSS
    assert_correct clean(other_css), clean(css)
   end

  it "should have a sprite_name function that returns the names of the sprites in a sass list" do
    css = render <<-SCSS
      @import "colors/*.png";
      @each $color in sprite_names($colors-sprites) {
        .\#{$color} {
          width:0px;
        }
      }
    SCSS
    other_css = <<-CSS
      .colors-sprite {
        background-image: url('/images-tmp/colors-s58671cb5bb.png');
        background-repeat: no-repeat;
      }
      .blue { 
        width:0px;
      }
      .yellow {
        width:0px;
      }
    CSS
    assert_correct clean(other_css), clean(css)

  end

  it "should respect global spacing" do
    css = render <<-SCSS
      $colors-spacing:5px;
      @import "colors/*.png";
      @include all-colors-sprites;
    SCSS
    other_css = <<-CSS
      .colors-sprite, .colors-blue, .colors-yellow {
        background-image: url('/images-tmp/colors-s747dec274e.png');
        background-repeat: no-repeat;
      }
      .colors-blue { 
        background-position:0 0;
      }
      .colors-yellow {
        background-position:0 -15px;
      }
    CSS
    assert_correct clean(other_css), clean(css)
  end

  it "should return width and height of the map" do
    css = render <<-SCSS
      @import "colors/*.png";
      .height { height : sprite_height($colors-sprites); }
      .width { width : sprite_width($colors-sprites); }
    SCSS
    other_css = <<-CSS
      .colors-sprite {
        background-image: url('/images-tmp/colors-s58671cb5bb.png');
        background-repeat: no-repeat;
      }
      .height {
        height : 20px;
      }
      .width {
        width : 10px;
      }
    CSS
    assert_correct clean(other_css), clean(css)
  end

    it "should return width and height of a sprite" do
    css = render <<-SCSS
      @import "colors/*.png";
      .height { height : sprite_height($colors-sprites, blue); }
      .width { width : sprite_width($colors-sprites, blue); }
    SCSS
    other_css = <<-CSS
      .colors-sprite {
        background-image: url('/images-tmp/colors-s58671cb5bb.png');
        background-repeat: no-repeat;
      }
      .height {
        height : 10px;
      }
      .width {
        width : 10px;
      }
    CSS
    assert_correct clean(other_css), clean(css)
  end

  it "should render correct sprite with focus selector" do
    css = render <<-SCSS
      @import "focus/*.png";
      @include all-focus-sprites;
    SCSS
    assert_correct <<-CSS, css
      .focus-sprite, .focus-ten-by-ten {
        background-image: url('/images-tmp/focus-sb5d1467be1.png');
        background-repeat: no-repeat;
      }
      
      .focus-ten-by-ten {
        background-position: 0 0;
      }
      .focus-ten-by-ten:hover, .focus-ten-by-ten.ten-by-ten-hover {
        background-position: 0 -30px;
      }
      .focus-ten-by-ten:target, .focus-ten-by-ten.ten-by-ten-target {
        background-position: 0 -40px;
      }
      .focus-ten-by-ten:active, .focus-ten-by-ten.ten-by-ten-active {
        background-position: 0 -10px;
      }
      .focus-ten-by-ten:focus, .focus-ten-by-ten.ten-by-ten-focus {
        background-position: 0 -20px;
      }
    CSS
  end

end
