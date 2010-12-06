require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "compass/sprites"
require 'digest/md5'

describe Compass::Sprites do
  
  before :each do
    @images_src_path = File.join(File.dirname(__FILE__), 'test_project', 'public', 'images')
    @images_tmp_path = File.join(File.dirname(__FILE__), 'test_project', 'public', 'images-tmp')
    FileUtils.cp_r @images_src_path, @images_tmp_path
    Compass.configuration.images_path = @images_tmp_path
    Compass.configure_sass_plugin!
  end

  after :each do
    FileUtils.rm_r @images_tmp_path
  end

  def map_location(file)
    Dir.glob(File.join(@images_tmp_path, file)).first
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
  
  # DEFAULT USAGE:

  it "should generate sprite classes" do
    css = render <<-SCSS
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background: url('/squares-161c60ad78.png') no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -10px;
      }
    CSS
    image_size('squares-*.png').should == [20, 30]
    image_md5('squares-*.png').should == 'e8cd71d546aae6951ea44cb01af35820'
  end

  it "should generate sprite classes with dimensions" do
    css = render <<-SCSS
      $squares-sprite-dimensions: true;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background: url('/squares-161c60ad78.png') no-repeat;
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
    image_size('squares-*.png').should == [20, 30]
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
    css.should == <<-CSS
      .squares-sprite, .cubicle, .large-cube {
        background: url('/squares-161c60ad78.png') no-repeat;
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
    image_size('squares-*.png').should == [20, 30]
  end
  
  # CUSTOMIZATIONS:
  
  it "should be possible to change the base class" do
    css = render <<-SCSS
      $squares-sprite-base-class: ".circles";
      @import "squares/*.png";
    SCSS
    css.should == <<-CSS
      .circles {
        background: url('/squares-161c60ad78.png') no-repeat;
      }
    CSS
    image_size('squares-*.png').should == [20, 30]
  end
  
  it "should calculate the spacing between images but not before first image" do
    css = render <<-SCSS
      $squares-ten-by-ten-spacing: 33px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background: url('/squares-89450808af.png') no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -43px;
      }
    CSS
    image_size('squares-*.png').should == [20, 63]
  end
  
  it "should calculate the spacing between images" do
    css = render <<-SCSS
      $squares-twenty-by-twenty-spacing: 33px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background: url('/squares-673837183a.png') no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -43px;
      }
    CSS
    image_size('squares-*.png').should == [20, 63]
  end
  
  it "should calculate the maximum spacing between images" do
    css = render <<-SCSS
      $squares-ten-by-ten-spacing: 44px;
      $squares-twenty-by-twenty-spacing: 33px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background: url('/squares-1cd84c9068.png') no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -54px;
      }
    CSS
    image_size('squares-*.png').should == [20, 74]
  end
  
  it "should calculate the maximum spacing between images in reversed order" do
    css = render <<-SCSS
      $squares-ten-by-ten-spacing: 33px;
      $squares-twenty-by-twenty-spacing: 44px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background: url('/squares-f25b7090ca.png') no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -54px;
      }
    CSS
    image_size('squares-*.png').should == [20, 74]
  end
  
  it "should calculate the default spacing between images" do
    css = render <<-SCSS
      $squares-spacing: 22px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background: url('/squares-d66bf24bab.png') no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -32px;
      }
    CSS
    image_size('squares-*.png').should == [20, 52]
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
    css.should == <<-CSS
      .squares-sprite {
        background: url('/squares-8e490168dd.png') no-repeat;
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
    image_size('squares-*.png').should == [20, 30]
    image_md5('squares-*.png').should == 'b61700e6d402d9df5f3820b73479f371'
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
    css.should == <<-CSS
      .squares-sprite, .adjusted-percentage, .adjusted-px-1, .adjusted-px-2 {
        background: url('/squares-8e490168dd.png') no-repeat;
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
    image_size('squares-*.png').should == [20, 30]
    image_md5('squares-*.png').should == 'b61700e6d402d9df5f3820b73479f371'
  end
  
  it "should repeat the image" do
    css = render <<-SCSS
      $squares-repeat: repeat;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-ten-by-ten, .squares-twenty-by-twenty {
        background: url('/squares-a5550fd132.png') no-repeat;
      }
      
      .squares-ten-by-ten {
        background-position: 0 0;
      }
      
      .squares-twenty-by-twenty {
        background-position: 0 -10px;
      }
    CSS
    image_size('squares-*.png').should == [20, 30]
    image_md5('squares-*.png').should == '0187306f3858136feee87d3017e7f307'
  end
  
  it "should provide a nice errors for lemonade's old users" do
    proc do
      render <<-SCSS
        .squares {
          background: sprite-url("squares/*.png") no-repeat;
        }
      SCSS
    end.should raise_error Sass::SyntaxError,
      %q(The first argument to sprite-url() must be a sprite map. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
    proc do
      render <<-SCSS
        .squares {
          background: sprite-image("squares/twenty-by-twenty.png") no-repeat;
        }
      SCSS
    end.should raise_error Sass::SyntaxError,
      %q(The sprite-image() function has been replaced by sprite(). See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
    proc do
      render <<-SCSS
        @import "squares/*.png";
        
        .squares {
          background: sprite-position("squares/twenty-by-twenty.png") no-repeat;
        }
      SCSS
    end.should raise_error Sass::SyntaxError,
      %q(The first argument to sprite-position() must be a sprite map. See http://beta.compass-style.org/help/tutorials/spriting/ for more information.)
  end
  
  it "should work even if @import is missing" do
    actual_css = render <<-SCSS
      .squares {
        background: sprite(sprite-map("squares/*.png"), twenty-by-twenty) no-repeat;
      }
    SCSS
    actual_css.should == <<-CSS
      .squares {
        background: url('/squares-145869726f.png') 0 -10px no-repeat;
      }
    CSS
  end
  
end