module Compass
end

%w(dependencies util browser_support sass_extensions version errors quick_cache logger).each do |lib|
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
  def shared_extension_paths
    @shared_extension_paths ||= begin
      if ENV["HOME"] && File.directory?(ENV["HOME"])
        [File.expand_path("~/.compass/extensions")]
      else
        []
      end
    end
  end
  module_function :base_directory, :lib_directory, :shared_extension_paths
  extend QuickCache
end

%w(configuration frameworks app_integration actions compiler).each do |lib|
  require "compass/#{lib}"
end
