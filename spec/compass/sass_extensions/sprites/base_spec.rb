require 'spec_helper'
describe Compass::SassExtensions::Sprites::Base do
  
  before :each do
    @images_src_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'test_project', 'public', 'images')
    @images_tmp_path = File.join(File.dirname(__FILE__), '..', '..', '..', 'test_project', 'public', 'images-tmp')
    FileUtils.cp_r @images_src_path, @images_tmp_path
    config = Compass::Configuration::Data.new('config')
    config.images_path = @images_tmp_path
    Compass.add_configuration(config)
    Compass.configure_sass_plugin!
    #fix this eww
    options = Compass.sass_engine_options.extend Compass::SassExtensions::Functions::Sprites::VariableReader
    @map = Compass::SpriteMap.new("selectors/*.png", options)
    @base = Compass::SassExtensions::Sprites::Base.new(@map.sprite_names.map{|n| "selectors/#{n}.png"}, @map.path, 'selectors', @map.sass_engine, @map.options)
  end

  after :each do
    FileUtils.rm_r @images_tmp_path
  end
  
  subject { @base }
  
  its(:size) { should == [10,40] }
  its(:sprite_names) { should ==  @map.sprite_names }
  its(:image_filenames) { should == Dir["#{@images_tmp_path}/selectors/*.png"].sort }
  its(:generation_required?) { should be_true }
  its(:uniqueness_hash) { should == 'ef52c5c63a'}
  its(:outdated?) { should be_true }
  its(:filename) { should == File.join(@images_tmp_path, "#{@base.path}-#{@base.uniqueness_hash}.png")}
  
  it "should return the 'ten-by-ten' image" do
    subject.image_for('ten-by-ten').name.should == 'ten-by-ten'
    subject.image_for('ten-by-ten').should be_a Compass::SassExtensions::Sprites::Image
  end
  
  %w(target hover active).each do |selector|
    it "should have a #{selector}" do
      subject.send(:"has_#{selector}?", 'ten-by-ten').should be_true
    end
    
    it "should return #{selector} image class" do
      subject.image_for('ten-by-ten').send(:"#{selector}").name.should == "ten-by-ten_#{selector}"
    end
    
  end
  context "#generate" do
    before { @base.generate }
    it "should generate sprite" do
      File.exists?(@base.filename).should be_true
    end
    
    its(:generation_required?) { should be_false }
    its(:outdated?) { should be_false }
  end
  
end