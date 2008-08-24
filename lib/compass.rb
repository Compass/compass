['core_ext', 'version'].each do |file|
  require File.join(File.dirname(__FILE__), 'compass', file)
end

module Compass
  extend Compass::Version
  def base_directory
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
  module_function :base_directory
end

require File.join(File.dirname(__FILE__), 'compass', 'frameworks')
# make sure we're running inside Merb
require File.join(File.dirname(__FILE__), 'compass', 'merb') if defined?(Merb::Plugins)  

