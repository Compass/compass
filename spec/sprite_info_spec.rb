require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Compass::SassExtensions::Functions::Sprites::SpriteInfo do

  def sprite_info(*args)
    Compass::SassExtensions::Functions::Sprites::SpriteInfo.new(*args)
  end

  ##

  it "should output the position for the first sprite" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']), :index => 0 }
    x = Sass::Script::Number.new(10, ['px'])
    sprite_info(sprite, sprite_item, x).position.should == "10px 0"
  end

  it "should output the position for the second+ sprite" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']), :index => 1 }
    x = Sass::Script::Number.new(10, ['px'])
    sprite_info(sprite, sprite_item, x).position.should == 
      "10px <%= Compass::Sprites.sprites['sprites.png'][:images][1][:y].unary_minus %>"
  end

  it "should output the position with y shift" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']), :index => 1 }
    x = Sass::Script::Number.new(10, ['px'])
    y_shift = Sass::Script::Number.new(3, ['px'])
    sprite_info(sprite, sprite_item, x, y_shift).position.should == 
      "10px <%= Compass::Sprites.sprites['sprites.png'][:images][1][:y].unary_minus.plus(Sass::Script::Number.new(3, ['px'])) %>"
  end

  it "should output the position with percentage" do
    sprite = { :file => "sprites.png" }
    sprite_item = { :y => Sass::Script::Number.new(20, ['px']), :index => 2 }
    x = Sass::Script::Number.new(100, ['%'])
    sprite_info(sprite, sprite_item, x).position.should == 
      "100% <%= Compass::Sprites.sprites['sprites.png'][:images][2][:y].unary_minus %>"
  end

end