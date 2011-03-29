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
    ::Dir.chdir @test_dir do
      output = Compass::Exec::SubCommandUI.new(options).run!
    end
    output
  end
  
  def options_to_cli(options)
    options.map.flatten!
  end
  
  let(:test_dir) { @test_dir }  
  before :each do
    create_temp_cli_dir
    create_sprite_temp
    File.open(File.join(@test_dir, 'config.rb'), 'w') do |f|
      f << config_data
    end
  end
  after :each do
    clean_up_sprites
    FileUtils.rm_r @test_dir if File.exists?(@test_dir)
  end
  
  it "should create sprite file" do
    puts run_compass_with_options(['sprite', "-f", "stylesheet.scss", "'#{@images_tmp_path}/*.png'"]).inspect
    File.exists?(File.join(test_dir, 'stylesheet.scss')).should be_true
  end
  
  
end