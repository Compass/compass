require 'test_helper'
require 'compass'

class WatcherCompilerTest < Test::Unit::TestCase

  def setup
    @working_path = File.join(fixture_path, 'stylesheets', 'valid')
    @to = File.join(@working_path, 'css')
    remove_to
    Compass.add_configuration({:sass_path => File.join(@working_path, 'sass'), :css_path => @to }, 'test')
  end

  test "it sould create a new instance of a compass compiler" do
    watch_compiler = Compass::Watcher::Compiler.new(@working_path, {})
    assert watch_compiler.compiler.is_a?(Compass::Compiler)
  end

  test "debug info gets passed into sass options" do
    watch_compiler = Compass::Watcher::Compiler.new(@working_path, {:debug_info => true})
    assert watch_compiler.compiler_options[:sass][:debug_info]
  end
  
  test "should run compiler" do
    watch_compiler = Compass::Watcher::Compiler.new(@working_path, {})
    watch_compiler.compiler.expects(:reset_staleness_checker!).once
    watch_compiler.compiler.expects(:run).once
    watch_compiler.expects(:log_action).once
    watch_compiler.compile
  end

  def remove_to
    ::FileUtils.rm_r @to if File.exists?(@to)
  end

  def teardown
    remove_to
  end

end