require 'test_helper'
require 'compass'
require 'compass/exec'
require 'stringio'

class RegressionsTest < Test::Unit::TestCase
  include SpriteHelper
  include Compass::CommandLineHelper

  def setup
    create_sprite_temp
    Compass.reset_configuration!
  end
  
  def teardown
    clean_up_sprites
    Compass.reset_configuration!
  end

  def test_issue911_sprites_with_globbing_and_line_comments
    within_tmp_directory do
      compass "create --bare issue911"
      FileUtils.mkdir_p "issue911/images/sprites/a"
      FileUtils.mkdir_p "issue911/images/sprites/b"
      FileUtils.cp File.join(@images_tmp_path, 'nested/squares/ten-by-ten.png'), "issue911/images/sprites/a/foo.png"
      FileUtils.cp File.join(@images_tmp_path, 'nested/squares/ten-by-ten.png'), "issue911/images/sprites/a/bar.png"
      Dir.chdir "issue911" do
        result = compile_for_project(<<-SCSS)
          @import "sprites/**/*.png";
        SCSS
        Sass::Engine.new(result, :syntax => :scss).render # raises an error if we generated invalid css
      end
    end
  end
end
