require 'test_helper'
require 'compass/exec'
class SpriteCommandTest < Test::Unit::TestCase
  include Compass::TestCaseHelper
  include Compass::CommandLineHelper
  include Compass::IoHelper
  
  attr_reader :test_dir
  include SpriteHelper
  def setup
    @before_dir = ::Dir.pwd
    create_temp_cli_dir
    create_sprite_temp
    @config_file = File.join(@test_dir, 'config.rb')
    File.open(@config_file, 'w') do |f|
      f << config_data
    end
  end
  
  def config_data
    return <<-CONFIG
      images_path = "#{@images_tmp_path}"
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
    compass *options
  end

  def options_to_cli(options)
    options.map.flatten!
  end

  def teardown
    ::Dir.chdir @before_dir
    clean_up_sprites
    if File.exists?(@test_dir)
      ::FileUtils.rm_r @test_dir
    end
  end

  it "should create sprite file" do
    assert_equal 0, run_compass_with_options(['sprite', "-f", 'stylesheet.scss', "squares/*.png"]).to_i
    assert File.exists?(File.join(test_dir, 'stylesheet.scss'))
  end

end