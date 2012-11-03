require 'test_helper'
require 'compass'

class WatcherWatchTest < Test::Unit::TestCase

  test "should throw exception if given absolute path" do
    begin 
      watcher = Compass::Watcher::Watch.new('/images/*.png') do
        puts "something"
      end
    rescue Compass::Watcher::AbsolutePathError
      assert true, "Compass::Watcher::AbsolutePathError was not raised"
    end
  end

  test "should throw exception if not given a block" do
    begin 
      watcher = Compass::Watcher::Watch.new('images/*.png')
    rescue Compass::Watcher::NoCallbackError
      assert true, "Compass::Watcher::NoCallbackError was not raised"
    end
  end

  test "changed path matches glob" do
    watcher = Compass::Watcher::Watch.new('images/*.png') { }
    assert watcher.match?('images/baz.png'), "Path does not match"
  end

  test "changed path doesn't matches glob" do
    watcher = Compass::Watcher::Watch.new('images/*.png') { }
    assert !watcher.match?('foo/baz.png'), "Path does match and it shouldn't"
  end

  test "can run callback" do
    test = 0
    watcher = Compass::Watcher::Watch.new('images/*.png') { test = 1}
    watcher.run_callback(:project, :local, :action)
    assert_equal 1, test
  end


end