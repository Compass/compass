require 'test_helper'

class SpriteCommandTest < Test::Unit::TestCase
  attr_reader :test_dir
  
  def setup
    @images_src_path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'sprites', 'public', 'images')
    @images_tmp_path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'sprites', 'public', 'images-tmp')
    @before_dir = ::Dir.pwd
    create_temp_cli_dir
    create_sprite_temp
    File.open(File.join(@test_dir, 'config.rb'), 'w') do |f|
      f << config_data
    end
  end
  
  def create_sprite_temp
    ::FileUtils.cp_r @images_src_path, @images_tmp_path
  end

  def clean_up_sprites
    ::FileUtils.rm_r @images_tmp_path
  end
  
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

  def teardown
    ::Dir.chdir @before_dir
    clean_up_sprites
    if File.exists?(@test_dir)
      ::FileUtils.rm_r @test_dir
    end
  end

  it "should create sprite file" do
    assert_equal 0, run_compass_with_options(['sprite', "-f", 'stylesheet.scss', "'#{@images_tmp_path}/*.png'"]).to_i
    assert File.exists?(File.join(test_dir, 'stylesheet.scss'))
  end

end