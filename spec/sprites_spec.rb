require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "compass/sprites"

describe Compass::Sprites do
  
  before :each do
    Compass.configuration.images_path = File.dirname(__FILE__) + "/test_project/public/images"
    Compass.configure_sass_plugin!
    Compass::Sprites.reset
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

  it "should generate sprite classes" do
    css = render <<-SCSS
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-10x10, .squares-20x20 {
        background: url('/squares.png') no-repeat; }
      
      .squares-10x10 {
        background-position: 0 0; }
      
      .squares-20x20 {
        background-position: 0 -10px; }
    CSS
  end

  it "should generate sprite classes with dimensions" do
    css = render <<-SCSS
      $squares-sprite-dimensions: true;
      @import "squares/*.png";
      @include all-squares-sprites;
    SCSS
    css.should == <<-CSS
      .squares-sprite, .squares-10x10, .squares-20x20 {
        background: url('/squares.png') no-repeat; }
      
      .squares-10x10 {
        background-position: 0 0;
        height: 10px;
        width: 10px; }
      
      .squares-20x20 {
        background-position: 0 -10px;
        height: 20px;
        width: 20px; }
    CSS
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
        background: url('/squares.png') no-repeat; }
      
      .cubicle {
        background-position: 0 0;
      }
      
      .large-cube {
        background-position: 0 -10px;
        height: 20px;
        width: 20px;
      }
    CSS
    
  end
  
end