require 'compass/watcher/watch'
require 'compass/watcher/compiler'
require 'compass/watcher/project_watcher'

module Compass
  module Watcher
    class WatcherException < Compass::Error; end
    class NoCallbackError < WatcherException; end
    class AbsolutePathError < WatcherException; end
  end
end