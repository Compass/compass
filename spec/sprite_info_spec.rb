require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sass::Script::SpriteInfo do

  def sprite_info(*args)
    Sass::Script::SpriteInfo.new(*args).to_s
  end

  ##

  it "should output the position for the first sprite" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']), :index => 0 }
    x = Sass::Script::Number.new(10, ['px'])
    sprite_info(:position, sprite, sprite_item, x).should == "10px 0"
  end

  it "should output the position for the second+ sprite" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']), :index => 1 }
    x = Sass::Script::Number.new(10, ['px'])
    sprite_info(:position, sprite, sprite_item, x).should == 
      "10px <%= Lemonade.sprites['sprites.png'][:images][1][:y].unary_minus %>"
  end

  it "should output the position with y shift" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']), :index => 1 }
    x = Sass::Script::Number.new(10, ['px'])
    y_shift = Sass::Script::Number.new(3, ['px'])
    sprite_info(:position, sprite, sprite_item, x, y_shift).should == 
      "10px <%= Lemonade.sprites['sprites.png'][:images][1][:y].unary_minus.plus(Sass::Script::Number.new(3, ['px'])) %>"
  end

  it "should output the position with percentage" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']), :index => 2 }
    x = Sass::Script::Number.new(100, ['%'])
    sprite_info(:position, sprite, sprite_item, x).should == 
      "100% <%= Lemonade.sprites['sprites.png'][:images][2][:y].unary_minus %>"
  end

  it "should output the url" do
    sprite = { :file => "sprites.png" }
    sprite_item = { }
    sprite_info(:url, sprite, sprite_item).should == "url('/sprites.png')"
  end

end