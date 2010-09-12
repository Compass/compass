require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sass::Script::Functions do

  before :each do
    Compass::Sprites.reset
    FileUtils.cp_r File.dirname(__FILE__) + '/images', IMAGES_TMP_PATH
  end

  after :each do
    FileUtils.rm_r IMAGES_TMP_PATH
  end

  def image_size(file)
    IO.read(IMAGES_TMP_PATH + '/' + file)[0x10..0x18].unpack('NN')
  end

  def evaluate(*values)
    sass = 'div' + values.map{ |value| "\n  background: #{value}" }.join
    css = Sass::Engine.new(sass, :syntax => :sass).render
    # find rendered CSS values
    # strip selectors, porperty names, semicolons and whitespace
    css = css.gsub(/div \{\s*background: (.+?);\s*\}\s*/m, '\\1').split(/;\s*background: /)
    css = css.first if css.length == 1
    return css
  end

  ###

  it "should return the sprite file name" do
    evaluate('sprite-image("sprites/30x30.png")').should == "url('/sprites.png')"
  end

  it "should also work with `sprite-img`" do
    evaluate('sprite-img("sprites/30x30.png")').should == "url('/sprites.png')"
  end

  it "should work in folders with dashes and underscores" do
    evaluate('sprite-image("other_images/more-images/sprites/test.png")').should ==
      "url('/other_images/more-images/sprites.png')"
  end

  it "should not work without any folder" do
    lambda { evaluate('sprite-image("test.png")') }.should raise_exception(Sass::SyntaxError)
  end

  it "should set the background position" do
    evaluate('sprite-image("sprites/30x30.png") sprite-image("sprites/150x10.png")').should ==
      "url('/sprites.png') url('/sprites.png') 0 -30px"
    image_size('sprites.png').should == [150, 40]
  end

  it "should use the X position" do
    evaluate('sprite-image("sprites/30x30.png", 5px, 0)').should == "url('/sprites.png') 5px 0"
    image_size('sprites.png').should == [30, 30]
  end

  it "should include the Y position" do
    evaluate('sprite-image("sprites/30x30.png", 0, 3px) sprite-image("sprites/150x10.png", 0, -6px)').should ==
      "url('/sprites.png') 0 3px url('/sprites.png') 0 -36px"
  end

  it "should calculate 20px empty space between sprites" do
    # Resulting sprite should look like (1 line = 10px height, X = placed image):

    # X
    #
    #
    # XX
    # XX
    #
    #
    # XXX
    # XXX
    # XXX

    evaluate(
      'sprite-image("sprites/10x10.png")',
      'sprite-image("sprites/20x20.png", 0, 0, 20px)',
      'sprite-image("sprites/30x30.png", 0, 0, 20px)'
    ).should == [
      "url('/sprites.png')",
      "url('/sprites.png') 0 -30px",
      "url('/sprites.png') 0 -70px"
    ]
    image_size('sprites.png').should == [30, 100]
  end

  it "should calculate empty space between sprites and combine space like CSS margins" do
    # Resulting sprite should look like (1 line = 10px height, X = placed image):

    # X
    #
    #
    #
    # XX
    # XX
    #
    # XXX
    # XXX
    # XXX

    evaluate(
      'sprite-image("sprites/10x10.png", 0, 0, 0, 30px)',
      'sprite-image("sprites/20x20.png", 0, 0, 20px, 5px)',
      'sprite-image("sprites/30x30.png", 0, 0, 10px)'
    ).should == [
      "url('/sprites.png')",
      "url('/sprites.png') 0 -40px",
      "url('/sprites.png') 0 -70px"
    ]
    image_size('sprites.png').should == [30, 100]
  end

  it "should calculate empty space correctly when 2 output images are uses" do
    evaluate(
      'sprite-image("sprites/10x10.png", 0, 0, 0, 30px)',
      'sprite-image("other_images/test.png")',
      'sprite-image("sprites/20x20.png", 0, 0, 20px, 5px)'
    ).should == [
      "url('/sprites.png')",
      "url('/other_images.png')",
      "url('/sprites.png') 0 -40px"
    ]
  end

  it "should allow % for x positions" do
    # Resulting sprite should look like (1 line = 10px height, X = placed image):

    # XXXXXXXXXXXXXXX
    #               X

    evaluate(
      'sprite-image("sprites/150x10.png")',
      'sprite-image("sprites/10x10.png", 100%)'
    ).should == [
      "url('/sprites.png')",
      "url('/sprites.png') 100% -10px"
    ]
  end

  it "should not compose the same image twice" do
    evaluate(
      'sprite-image("sprites/10x10.png")',
      'sprite-image("sprites/20x20.png")',
      'sprite-image("sprites/20x20.png")'  # reuse image from line above
    ).should == [
      "url('/sprites.png')",
      "url('/sprites.png') 0 -10px",
      "url('/sprites.png') 0 -10px"
    ]
    image_size('sprites.png').should == [20, 30]
  end

  it "should calculate the maximum spacing between images" do
    evaluate(
      'sprite-image("sprites/10x10.png")',
      'sprite-image("sprites/20x20.png", 0, 0, 10px)',
      'sprite-image("sprites/20x20.png", 0, 0, 99px)' # 99px > 10px
    ).should == [
      "url('/sprites.png')",
      "url('/sprites.png') 0 -109px", # use 99px spacing
      "url('/sprites.png') 0 -109px"
    ]
    image_size('sprites.png').should == [20, 129]
  end

  it "should calculate the maximum spacing between images for margin bottom" do
    evaluate(
      'sprite-image("sprites/10x10.png", 0, 0, 0, 10px)',
      'sprite-image("sprites/10x10.png", 0, 0, 0, 99px)', # 99px > 10px
      'sprite-image("sprites/20x20.png")'
    ).should == [
      "url('/sprites.png')",
      "url('/sprites.png')",
      "url('/sprites.png') 0 -109px" # use 99px spacing
    ]
    image_size('sprites.png').should == [20, 129]
  end

  it "should output the background-position" do
    evaluate(
      'sprite-position("sprites/10x10.png")',
      'sprite-position("sprites/20x20.png")'
    ).should == [
      "0 0",
      "0 -10px"
    ]
  end

  it "should output the background-image URL" do
    evaluate('sprite-url("sprites")').should == "url('/sprites.png')"
    evaluate('sprite-url("sprites/10x10.png")').should == "url('/sprites.png')"
    evaluate('sprite-url("sprites/20x20.png")').should == "url('/sprites.png')"
    evaluate('sprite-url("other_images/test.png")').should == "url('/other_images.png')"
  end

  it "should count the PNG files in a folder" do
    evaluate('sprite-files-in-folder("sprites")').to_i.should == 4
  end

  it "should output the n-th file in a folder" do
    evaluate('sprite-file-from-folder("sprites", 0)').should == "sprites/10x10.png"
    evaluate('sprite-file-from-folder("sprites", 1)').should == "sprites/150x10.png"
  end

  it "should output the filename without extention for the sprite" do
    evaluate('sprite-name("sprites")').should == "sprites"
    evaluate('sprite-name("sprites/10x10.png")').should == "sprites"
  end

  it "should output the filename without extention for the sprite item" do
    evaluate('image-basename("sprites/10x10.png")').should == "10x10"
  end

end
