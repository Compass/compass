require 'test_helper'
require 'fileutils'
require 'compass'
require 'compass/logger'
require 'sass/plugin'


class SpritesTest < Test::Unit::TestCase
  
  def setup
    Compass.reset_configuration!
    @images_src_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'sprites', 'public', 'images')
    @images_tmp_path = File.join(File.dirname(__FILE__), '..', 'fixtures', 'sprites', 'public', 'images-tmp')
    ::FileUtils.cp_r @images_src_path, @images_tmp_path
    file = StringIO.new("images_path = #{@images_tmp_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    Compass.configure_sass_plugin!
  end

  def teardown
    Compass.reset_configuration!
    ::FileUtils.rm_r @images_tmp_path
  end


  def map_location(file)
    map_files(file).first
  end
  
  def map_files(glob)
    Dir.glob(File.join(@images_tmp_path, glob))
  end

  def image_size(file)
    IO.read(map_location(file))[0x10..0x18].unpack('NN')
  end

  def image_md5(file)
    md5 = Digest::MD5.new
    md5.update IO.read(map_location(file))
    md5.hexdigest
  end

  def render(scss)
    scss = %Q(@import "compass"; #{scss})
    options = Compass.sass_engine_options
    options[:line_comments] = false
    options[:style] = :expanded
    options[:syntax] = :scss
    css = Sass::Engine.new(scss, options).render
    # reformat to fit result of heredoc:
    "      #{css.gsub('@charset "UTF-8";', '').gsub(/\n/, "\n      ").strip}\n"
  end
  
  it "should generate sprite classes" do
    css = render <<-SCSS
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct css, <<-CSS
      .squares-sprite, .squares-twenty-by-twenty, .squares-ten-by-ten {
        background: url('/squares-sd29894e8d3.png') no-repeat;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 0;
      }
      
      .squares-ten-by-ten {
        background-position: 0 -20px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
    assert_equal image_md5('squares-s*.png'), '58ec7c496b00df61ca0f40cbf3e02567'
  end

  it "should generate sprite classes with dimensions" do
    css = render <<-SCSS
      $squares-sprite-dimensions: true;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct css, <<-CSS
      .squares-sprite, .squares-twenty-by-twenty, .squares-ten-by-ten {
        background: url('/squares-sd29894e8d3.png') no-repeat;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 0;
        height: 20px;
        width: 20px;
      }
      
      .squares-ten-by-ten {
        background-position: 0 -20px;
        height: 10px;
        width: 10px;
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
    assert_correct css, <<-CSS
      .squares-sprite, .cubicle, .large-cube {
        background: url('/squares-sd29894e8d3.png') no-repeat;
      }
      
      .cubicle {
        background-position: 0 -20px;
      }
      
      .large-cube {
        background-position: 0 0;
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
    assert_correct css, <<-CSS
      .circles {
        background: url('/squares-sd29894e8d3.png') no-repeat;
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
    assert_correct css, <<-CSS
      .squares-sprite, .squares-twenty-by-twenty, .squares-ten-by-ten {
        background: url('/squares-sb609df3b64.png') no-repeat;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 0;
      }
      
      .squares-ten-by-ten {
        background-position: 0 -53px;
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
    assert_correct css, <<-CSS
      .squares-sprite, .squares-twenty-by-twenty, .squares-ten-by-ten {
        background: url('/squares-s1277914e08.png') no-repeat;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 0;
      }
      
      .squares-ten-by-ten {
        background-position: 0 -53px;
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
    assert_correct css, <<-CSS
      .squares-sprite, .squares-twenty-by-twenty, .squares-ten-by-ten {
        background: url('/squares-s53841dbecb.png') no-repeat;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 0;
      }
      
      .squares-ten-by-ten {
        background-position: 0 -64px;
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
    assert_correct css, <<-CSS
      .squares-sprite, .squares-twenty-by-twenty, .squares-ten-by-ten {
        background: url('/squares-s99fba6c76f.png') no-repeat;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 0;
      }
      
      .squares-ten-by-ten {
        background-position: 0 -64px;
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
    assert_correct css, <<-CSS
      .squares-sprite, .squares-twenty-by-twenty, .squares-ten-by-ten {
        background: url('/squares-sca0c5004c2.png') no-repeat;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 0;
      }
      
      .squares-ten-by-ten {
        background-position: 0 -42px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 52]
  end

  it "should use position adjustments in functions" do
    css = render <<-SCSS
      $squares: sprite-map("squares/*.png", $position: 100%);
      .squares-sprite {
        background: $squares no-repeat;
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
    assert_correct css, <<-CSS
      .squares-sprite {
        background: url('/squares-sb00922e70a.png') no-repeat;
      }
      
      .adjusted-percentage {
        background-position: 100% -20px;
      }
      
      .adjusted-px-1 {
        background-position: -6px -20px;
      }
      
      .adjusted-px-2 {
        background-position: -3px 2px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
    assert_equal image_md5('squares-s*.png'), '1affac9e56fa8f4f08434f0c55553a9c'
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
    assert_correct css, <<-CSS
      .squares-sprite, .adjusted-percentage, .adjusted-px-1, .adjusted-px-2 {
        background: url('/squares-sb00922e70a.png') no-repeat;
      }
      
      .adjusted-percentage {
        background-position: 100% -20px;
      }
      
      .adjusted-px-1 {
        background-position: -6px -20px;
      }
      
      .adjusted-px-2 {
        background-position: -3px 2px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
    assert_equal image_md5('squares-s*.png'), '1affac9e56fa8f4f08434f0c55553a9c'
  end

  it "should repeat the image" do
    css = render <<-SCSS
      $squares-repeat: repeat;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct css, <<-CSS
      .squares-sprite, .squares-twenty-by-twenty, .squares-ten-by-ten {
        background: url('/squares-s96482b8f91.png') no-repeat;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 0;
      }
      
      .squares-ten-by-ten {
        background-position: 0 -20px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [20, 30]
    assert_equal image_md5('squares-s*.png'), 'ca97249386c490cd0012eca0970db681'
  end

  it "should allow the position of a sprite to be specified in absolute pixels" do
    css = render <<-SCSS
      $squares-ten-by-ten-position: 10px;
      $squares-twenty-by-twenty-position: 10px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    assert_correct css, <<-CSS
      .squares-sprite, .squares-twenty-by-twenty, .squares-ten-by-ten {
        background: url('/squares-sa26f58763e.png') no-repeat;
      }
      
      .squares-twenty-by-twenty {
        background-position: -10px 0;
      }
      
      .squares-ten-by-ten {
        background-position: -10px -20px;
      }
    CSS
    assert_equal image_size('squares-s*.png'), [30, 30]
    assert_equal image_md5('squares-s*.png'), '97d7e70e23858df5283af28cbc531fb8'
  end

  it "should provide a nice errors for lemonade's old users" do
    assert_raise(Sass::SyntaxError) do
      render <<-SCSS
        .squares {
          background: sprite-url("squares/*.png") no-repeat;
        }
      SCSS
    end
    assert_raise(Sass::SyntaxError) do
      css = render <<-SCSS
        .squares {
          background: sprite-image("squares/twenty-by-twenty.png") no-repeat;
        }
      SCSS
    end
    assert_raise(Sass::SyntaxError) do
      css = render <<-SCSS
        @import "squares/*.png";

        .squares {
          background: sprite-position("squares/twenty-by-twenty.png") no-repeat;
        }
      SCSS
    end
  end

  it "should work even if @import is missing" do
    css = render <<-SCSS
      .squares {
        background: sprite(sprite-map("squares/*.png"), twenty-by-twenty) no-repeat;
      }
    SCSS
    assert_correct css, <<-CSS
      .squares {
        background: url('/squares-s9cbcd46bcf.png') 0 0 no-repeat;
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
    assert_correct css, <<-CSS
      .squares-sprite {
        background: url('/squares-sbfc4f12162.png') no-repeat;
      }
      
      .foo {
        background-position: 0 0;
      }
      
      .bar {
        background-position: 0 -30px;
      }
    CSS
  end

  it "should render corret sprite with css selectors via issue#248" do
    css = render <<-SCSS
      @import "selectors/*.png";
      @include all-selectors-sprites;
    SCSS
    assert_correct css, <<-CSS
      .selectors-sprite, .selectors-ten-by-ten {
        background: url('/selectors-s20ec2e1305.png') no-repeat;
      }
      
      .selectors-ten-by-ten {
        background-position: 0 -30px;
      }
      .selectors-ten-by-ten:hover, .selectors-ten-by-ten.ten-by-ten_hover, .selectors-ten-by-ten.ten-by-ten-hover {
        background-position: 0 -20px;
      }
      .selectors-ten-by-ten:target, .selectors-ten-by-ten.ten-by-ten_target, .selectors-ten-by-ten.ten-by-ten-target {
        background-position: 0 -10px;
      }
      .selectors-ten-by-ten:active, .selectors-ten-by-ten.ten-by-ten_active, .selectors-ten-by-ten.ten-by-ten-active {
        background-position: 0 0;
      }
    CSS
  end

  it "should render corret sprite with css selectors via magic mixin" do
    css = render <<-SCSS
      @import "selectors/*.png";
      a {
        @include selectors-sprite(ten-by-ten)
      }
    SCSS
    assert_correct css, <<-CSS
      .selectors-sprite, a {
        background: url('/selectors-s20ec2e1305.png') no-repeat;
      }
      
      a {
        background-position: 0 -30px;
      }
      a:hover, a.ten-by-ten_hover, a.ten-by-ten-hover {
        background-position: 0 -20px;
      }
      a:target, a.ten-by-ten_target, a.ten-by-ten-target {
        background-position: 0 -10px;
      }
      a:active, a.ten-by-ten_active, a.ten-by-ten-active {
        background-position: 0 0;
      }
    CSS
  end
  
  it "should not render corret sprite with css selectors via magic mixin" do
    css = render <<-SCSS
      @import "selectors/*.png";
      a {
        $disable-magic-sprite-selectors:true;
        @include selectors-sprite(ten-by-ten)
      }
    SCSS
    assert_correct css, <<-CSS
      .selectors-sprite, a {
        background: url('/selectors-s20ec2e1305.png') no-repeat;
      }
      
      a {
        background-position: 0 -30px;
      }
    CSS
  end
  
  it "should raise error on filenames that are not valid sass syntax" do
    assert_raise(Compass::Error) do
      css = render <<-SCSS
        @import "prefix/*.png";
        a {
          @include squares-sprite(20-by-20);
        }
      SCSS
    end
  end

  it "should generate sprite with bad repeat-x dimensions" do
    css = render <<-SCSS
      $ko-starbg26x27-repeat: repeat-x;
      @import "ko/*.png";
      @include all-ko-sprites;
    SCSS
    assert_correct css, <<-CSS
      .ko-sprite, .ko-starbg26x27, .ko-default_background {
        background: url('/ko-s2da56a5d50.png') no-repeat;
      }
      
      .ko-starbg26x27 {
        background-position: 0 0;
      }
      
      .ko-default_background {
        background-position: 0 -27px;
      }
    CSS
  end
  
  it "should generate a sprite and remove the old file" do
    FileUtils.touch File.join(@images_tmp_path, "selectors-scc8834Fdd.png")
    assert_equal 1, map_files('selectors-s*.png').size
    css = render <<-SCSS
      @import "selectors/*.png";
      a {
        $disable-magic-sprite-selectors:true;
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
        $disable-magic-sprite-selectors:true;
        @include selectors-sprite(ten-by-ten)
      }
    SCSS
    assert_equal 2, map_files('selectors-s*.png').size, "File was removed"
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
    assert_correct css, <<-CSS
      .nested-sprite, .nested-ten-by-ten {
        background: url('/nested-s55a8935544.png') no-repeat;
      }
      
      .nested-ten-by-ten {
        background-position: 0 0;
      }
    CSS
  end

end
