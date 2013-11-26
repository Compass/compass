lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(lib_dir) unless $:.include?(lib_dir)
test_dir = File.dirname(__FILE__)
$:.unshift(test_dir) unless $:.include?(test_dir)

require 'compass'
require 'test/unit'
require 'true'


class String
  def name
    to_s
  end
end

%w(command_line diff io rails test_case).each do |helper|
  require "helpers/#{helper}"
end


class Test::Unit::TestCase
  include Compass::Diff
  include Compass::TestCaseHelper
  include Compass::IoHelper
  extend Compass::TestCaseHelper::ClassMethods
  
  def fixture_path
    File.join(File.expand_path('../', __FILE__), 'fixtures')
  end

end 

module SpriteHelper
  URI = "selectors/*.png"
  
  def init_sprite_helper
    @images_proj_path = File.join(File.expand_path('../', __FILE__), 'fixtures', 'sprites', 'public')
    @images_src_dir = 'images'
    @images_src_path = File.join(@images_proj_path, @images_src_dir)
    @images_tmp_dir = 'images-tmp'
    @images_tmp_path = File.join(@images_proj_path, @images_tmp_dir)
  end
  
  def sprite_map_test(options, uri = URI)
    importer = Compass::SpriteImporter.new
    path, name = Compass::SpriteImporter.path_and_name(uri)
    sprite_names = Compass::SpriteImporter.sprite_names(uri)
    sass_engine = Compass::SpriteImporter.sass_engine(uri, name, importer, options)
    map = Compass::SassExtensions::Sprites::SpriteMap.new(sprite_names.map{|n| uri.gsub('*', n)}, path, name, sass_engine, options)
    map.options = {:compass => {:logger => Compass::NullLogger.new}}
    map
  end
  
  def create_sprite_temp
     init_sprite_helper
    ::FileUtils.cp_r @images_src_path, @images_tmp_path
  end

  def clean_up_sprites
    init_sprite_helper
    ::FileUtils.rm_r @images_tmp_path   
  rescue Errno::ENOENT
    #pass
  end
  
end
