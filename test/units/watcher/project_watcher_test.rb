require 'test_helper'
require 'compass'

class ProjectWatcherTest < Test::Unit::TestCase

  def setup
    @working_path = File.join(fixture_path, 'stylesheets', 'valid')
    @to = File.join(@working_path, 'css')
    remove_to
    Compass.add_configuration({:sass_path => File.join(@working_path, 'sass'), :css_path => @to }, 'test')
    @project_watcher = Compass::Watcher::ProjectWatcher.new(@working_path)
  end

  test "should initalize correctly" do
    assert @project_watcher.listener.is_a?(Listen::Listener)
  end

  test "compiler" do
    assert @project_watcher.compiler.is_a?(Compass::Compiler)
  end

  test "sass callback add" do
    @project_watcher.expects(:sass_added).with('foo.scss').once
    @project_watcher.send(:sass_callback, @working_path, 'foo.scss', :added)
  end

  test "sass callback modified" do
    @project_watcher.expects(:sass_modified).with('foo.scss').once
    @project_watcher.send(:sass_callback, @working_path, 'foo.scss', :modified)
  end

  test "sass callback removed" do
    @project_watcher.expects(:sass_removed).with('foo.scss').once
    @project_watcher.send(:sass_callback, @working_path, 'foo.scss', :removed)
  end


  test "listen callback modified" do
    @project_watcher.expects(:sass_modified).with('sass/sample.scss').once
    @project_watcher.send(:listen_callback, 'sass/sample.scss', nil, nil)
  end

  test "listen callback added" do
    @project_watcher.expects(:sass_added).with('sass/sample.scss').once
    @project_watcher.send(:listen_callback, nil, 'sass/sample.scss', nil)
  end

  test "listen callback removed" do
    @project_watcher.expects(:sass_removed).with('sass/sample.scss').once
    @project_watcher.send(:listen_callback, nil, nil, 'sass/sample.scss')
  end

  def remove_to
    ::FileUtils.rm_r @to if File.exists?(@to)
  end

  def teardown
    remove_to
  end


end
