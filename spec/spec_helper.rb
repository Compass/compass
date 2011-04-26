$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'compass'
require 'rspec'
require 'rspec/autorun'
require 'mocha'

module CompassGlobalInclude
  class << self
    def included(klass)
      klass.instance_eval do
        let(:images_src_path) { File.join(File.dirname(__FILE__), 'test_project', 'public', 'images') }
      end
    end
  end
end

module CompassSpriteHelpers
  def create_sprite_temp
    ::FileUtils.cp_r @images_src_path, @images_tmp_path
  end

  def clean_up_sprites
    ::FileUtils.rm_r @images_tmp_path
  end
end

RSpec.configure do |config|
  config.include(CompassGlobalInclude)
  config.include(CompassSpriteHelpers)
  config.before :each do
    @images_src_path = File.join(File.dirname(__FILE__), 'test_project', 'public', 'images')
    @images_tmp_path = File.join(File.dirname(__FILE__), 'test_project', 'public', 'images-tmp')
  end
  config.mock_with :mocha
end