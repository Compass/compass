module Compass
end

%w(core
   deprecation
   dependencies
   sass_extensions
   version
   errors
   quick_cache
   logger
   actions
).each do |lib|
  require "compass/#{lib}"
end

require 'sass/callbacks'

module Compass
  def base_directory
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
  def lib_directory
    File.expand_path(File.join(File.dirname(__FILE__)))
  end
  module_function :base_directory, :lib_directory
  extend QuickCache
end

%w(configuration/helpers
   configuration/comments
   configuration/serialization
   configuration/file_data
   app_integration
   compiler
   sprite_importer
).each do |lib|
  require "compass/#{lib}"
end
