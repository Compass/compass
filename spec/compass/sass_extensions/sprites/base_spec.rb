require 'spec_helper'
describe Compass::SassExtensions::Sprites::Base do
  
  before :each do
    @images_src_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'test_project', 'public', 'images')
    @images_tmp_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'test_project', 'public', 'selectors-images-tmp')
    #FileUtils.mkdir_p @images_src_path
    #FileUtils.mkdir_p @images_tmp_path
    FileUtils.cp_r @images_src_path, @images_tmp_path
    file = StringIO.new("images_path = #{@images_tmp_path.inspect}\n")
    Compass.add_configuration(file, "sprite_config")
    Compass.configure_sass_plugin!
    rels = Dir["#{@images_src_path}/selectors/*.png"].sort.map { |f| f.split('/')[-2..-1].join('/') }
    Compass::SassExtensions::Sprites::Base.new(rels, @images_src_path, 'selectors', self, options)
  end

  after :each do
    FileUtils.rm_r @images_tmp_path
  end
  
  it "should" do
    "foo"
  end
  
  
  
  
  
end