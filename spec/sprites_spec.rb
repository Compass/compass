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
    Compass::Sprites.reset
  end

  after :each do
    FileUtils.rm_r @images_tmp_path
  end

  def image_size(file)
    IO.read(File.join(@images_tmp_path, file))[0x10..0x18].unpack('NN')
  end

  def image_md5(file)
    md5 = Digest::MD5.new
    md5.update IO.read(File.join(@images_tmp_path, file))
    md5.hexdigest
  end
  
  def render(scss)
    scss = %Q(@import "compass"; #{scss})
    options = Compass.sass_engine_options
    options[:line_comments] = false
    options[:style] = :expanded
    options[:syntax] = :scss
    options[:load_paths] << Compass::Sprites.new
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
      .squares-sprite, .squares-10x10, .squares-20x20 {
        background: url('/squares.png') no-repeat;
      }
      
      .squares-10x10 {
        background-position: 0 0;
      }
      
      .squares-20x20 {
        background-position: 0 -10px;
      }
    CSS
    image_size('squares.png').should == [20, 30]
    image_md5('squares.png').should == 'ac68084abb8f43794a75c5fb28bd62fe'
  end

  it "should generate sprite classes with dimensions" do
    css = render <<-SCSS
      $squares-sprite-dimensions: true;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-10x10, .squares-20x20 {
        background: url('/squares.png') no-repeat;
      }
      
      .squares-10x10 {
        background-position: 0 0;
        height: 10px;
        width: 10px;
      }
      
      .squares-20x20 {
        background-position: 0 -10px;
        height: 20px;
        width: 20px;
      }
    CSS
    image_size('squares.png').should == [20, 30]
  end
  
  it "should provide sprite mixin" do
    css = render <<-SCSS
      @import "squares/*.png";
      
      .cubicle {
        @include squares-sprite("10x10");
      }
      
      .large-cube {
        @include squares-sprite("20x20", true);
      }
    SCSS
    css.should == <<-CSS
      .squares-sprite, .cubicle, .large-cube {
        background: url('/squares.png') no-repeat;
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
    image_size('squares.png').should == [20, 30]
  end
  
  # CUSTOMIZATIONS:
  
  it "should be possible to change the base class" do
    css = render <<-SCSS
      $squares-sprite-base-class: ".circles";
      @import "squares/*.png";
    SCSS
    css.should == <<-CSS
      .circles {
        background: url('/squares.png') no-repeat;
      }
    CSS
    image_size('squares.png').should == [20, 30]
  end
  
  it "should calculate the spacing between images but not before first image" do
    css = render <<-SCSS
      $squares-10x10-spacing: 33px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-10x10, .squares-20x20 {
        background: url('/squares.png') no-repeat;
      }
      
      .squares-10x10 {
        background-position: 0 0;
      }
      
      .squares-20x20 {
        background-position: 0 -43px;
      }
    CSS
    image_size('squares.png').should == [20, 63]
  end
  
  it "should calculate the spacing between images" do
    css = render <<-SCSS
      $squares-20x20-spacing: 33px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-10x10, .squares-20x20 {
        background: url('/squares.png') no-repeat;
      }
      
      .squares-10x10 {
        background-position: 0 0;
      }
      
      .squares-20x20 {
        background-position: 0 -43px;
      }
    CSS
    image_size('squares.png').should == [20, 63]
  end
  
  it "should calculate the maximum spacing between images" do
    css = render <<-SCSS
      $squares-10x10-spacing: 44px;
      $squares-20x20-spacing: 33px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-10x10, .squares-20x20 {
        background: url('/squares.png') no-repeat;
      }
      
      .squares-10x10 {
        background-position: 0 0;
      }
      
      .squares-20x20 {
        background-position: 0 -54px;
      }
    CSS
    image_size('squares.png').should == [20, 74]
  end
  
  it "should calculate the maximum spacing between images in reversed order" do
    css = render <<-SCSS
      $squares-10x10-spacing: 33px;
      $squares-20x20-spacing: 44px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-10x10, .squares-20x20 {
        background: url('/squares.png') no-repeat;
      }
      
      .squares-10x10 {
        background-position: 0 0;
      }
      
      .squares-20x20 {
        background-position: 0 -54px;
      }
    CSS
    image_size('squares.png').should == [20, 74]
  end
  
  it "should calculate the default spacing between images" do
    css = render <<-SCSS
      $squares-spacing: 22px;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-10x10, .squares-20x20 {
        background: url('/squares.png') no-repeat;
      }
      
      .squares-10x10 {
        background-position: 0 0;
      }
      
      .squares-20x20 {
        background-position: 0 -32px;
      }
    CSS
    image_size('squares.png').should == [20, 52]
  end
  
  it "should use position adjustments in functions" do
    css = render <<-SCSS
      $squares-position: 100%;
      @import "squares/*.png";
      
      .adjusted-percentage {
        background-position: sprite-position("squares/10x10.png", 100%);
      }
      
      .adjusted-px-1 {
        background-position: sprite-position("squares/10x10.png", 4px);
      }
      
      .adjusted-px-2 {
        background-position: sprite-position("squares/20x20.png", -3px, 2px);
      }
    SCSS
    css.should == <<-CSS
      .squares-sprite {
        background: url('/squares.png') no-repeat;
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
    image_size('squares.png').should == [20, 30]
    image_md5('squares.png').should == 'e274a620ff44c14774fa470d0a9020a1'
  end
  
  it "should use position adjustments in mixins" do
    css = render <<-SCSS
      $squares-position: 100%;
      @import "squares/*.png";
      
      .adjusted-percentage {
        @include squares-sprite("10x10", $x: 100%);
      }
      
      .adjusted-px-1 {
        @include squares-sprite("10x10", $x: 4px);
      }
      
      .adjusted-px-2 {
        @include squares-sprite("20x20", $x: -3px, $y: 2px);
      }
    SCSS
    css.should == <<-CSS
      .squares-sprite, .adjusted-percentage, .adjusted-px-1, .adjusted-px-2 {
        background: url('/squares.png') no-repeat;
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
    image_size('squares.png').should == [20, 30]
    image_md5('squares.png').should == 'e274a620ff44c14774fa470d0a9020a1'
  end
  
end