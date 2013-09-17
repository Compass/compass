require 'test_helper'
require 'compass'

class ProjectWatcherTest < Test::Unit::TestCase

  FOO = ['foo.scss']

  def setup
    @working_path = File.join(fixture_path, 'stylesheets', 'valid')
    @to = File.join(@working_path, 'css')
    remove_to
    Compass.add_configuration({:sass_path => File.join(@working_path, 'sass'), :css_path => @to }, 'test')
    @project_watcher = Compass::Watcher::ProjectWatcher.new(@working_path)
  end

  test "should initalize correctly" do
    assert @project_watcher.listener.is_a?(Listen::Listener)
    assert_equal 2, @project_watcher.sass_watchers.size
  end

  test "should have 3 watchers" do
    Dir.chdir File.join(@working_path, 'sass') do
      @project_watcher = Compass::Watcher::ProjectWatcher.new(Dir.pwd)
      assert_equal 3, @project_watcher.sass_watchers.size
    end
  end

  test "compiler" do
    assert @project_watcher.compiler.is_a?(Compass::Compiler)
  end

  test "sass callback add" do
    @project_watcher.expects(:sass_added).with(FOO).once
    @project_watcher.send(:sass_callback, @working_path, FOO, :added)
  end

  test "sass callback modified" do
    @project_watcher.expects(:sass_modified).with(FOO).once
    @project_watcher.send(:sass_callback, @working_path, FOO, :modified)
  end

  test "sass callback removed" do
    @project_watcher.expects(:sass_removed).with(FOO).once
    @project_watcher.send(:sass_callback, @working_path, FOO, :removed)
  end

  SAMPLE = ['sass/sample.scss']

  test "listen callback modified" do
    @project_watcher.expects(:sass_modified).with(SAMPLE[0]).once
    @project_watcher.send(:listen_callback, SAMPLE, [], [])
  end

  test "listen callback added" do
    @project_watcher.expects(:sass_added).with(SAMPLE[0]).once
    @project_watcher.send(:listen_callback, [], SAMPLE, [])
  end

  test "listen callback removed" do
    @project_watcher.expects(:sass_removed).with(SAMPLE[0]).once
    @project_watcher.send(:listen_callback, [], [], SAMPLE)
  end

  def remove_to
    ::FileUtils.rm_r @to if File.exists?(@to)
  end

  def teardown
    remove_to
  end


end
