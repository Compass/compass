require 'test_helper'
require 'compass'
require 'compass/exec'
require 'stringio'

class RegressionsTest < Test::Unit::TestCase
  include Compass::CommandLineHelper
  setup do
    Compass.reset_configuration!
  end
  
  after do
    Compass.reset_configuration!
  end

  def test_issue911_sprites_with_globbing_and_line_comments
    within_tmp_directory do
      compass "create --bare issue911"
      FileUtils.mkdir_p "issue911/images/sprites/a"
      FileUtils.mkdir_p "issue911/images/sprites/b"
      open "issue911/images/sprites/a/foo.png", "wb" do |f|
        f.write(Compass::PNG.new(5,10, [255,0,255]).to_blob)
      end
      open "issue911/images/sprites/b/bar.png", "wb" do |f|
        f.write(Compass::PNG.new(5,10, [255,255,0]).to_blob)
      end
      Dir.chdir "issue911" do
        result = compile_for_project(<<-SCSS)
          @import "sprites/**/*.png";
        SCSS
        Sass::Engine.new(result, :syntax => :scss).render # raises an error if we generated invalid css
      end
    end
  end
end
