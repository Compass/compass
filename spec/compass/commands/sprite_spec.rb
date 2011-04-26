require 'spec_helper'
require 'compass/commands'
require 'compass/exec'
require 'compass/commands/sprite'
describe Compass::Commands::Sprite do
  def config_data
    return <<-CONFIG
      images_path = #{@images_tmp_path.inspect}
    CONFIG
  end
  
  def create_temp_cli_dir
    directory = File.join(File.expand_path('../', __FILE__), 'test')
    ::FileUtils.mkdir_p directory
     @test_dir = directory
  end
  
  def run_compass_with_options(options)
    output = 'foo'
    ::Dir.chdir @test_dir
    %x{compass #{options.join(' ')}}
  end
  
  def options_to_cli(options)
    options.map.flatten!
  end
  
  let(:test_dir) { @test_dir }  
  before :each do
    @before_dir = ::Dir.pwd
    create_temp_cli_dir
    create_sprite_temp
    File.open(File.join(@test_dir, 'config.rb'), 'w') do |f|
      f << config_data
    end
  end
  after :each do
    ::Dir.chdir @before_dir
    clean_up_sprites
    if File.exists?(@test_dir)
      ::FileUtils.rm_r @test_dir
    end
  end
  
  it "should create sprite file" do
    run_compass_with_options(['sprite', "-f", "stylesheet.scss", "'#{@images_tmp_path}/*.png'"]).to_i.should == 0
    File.exists?(File.join(test_dir, 'stylesheet.scss')).should be_true
  end
  
  it "should fail gracfuly when giving bad arguments" do
    pending
  end
  
  
end