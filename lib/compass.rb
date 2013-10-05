module Compass
end

%w(dependencies util browser_support sass_extensions version errors quick_cache logger actions).each do |lib|
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
        [File.join(ENV["HOME"], ".compass", "extensions")]
      else
        []
      end
    rescue ArgumentError # If HOME is relative
      []
    end
  end
  module_function :base_directory, :lib_directory, :shared_extension_paths
  extend QuickCache
end

%w(watcher configuration frameworks app_integration compiler).each do |lib|
  require "compass/#{lib}"
end


extension_paths    = Sass::Util.glob(File.join(Compass.shared_extension_paths, '**'))
extension_paths    = extension_paths + Sass::Util.glob(File.join(Compass.shared_extension_paths, '**', 'lib'))
absolute_ext_path = File.expand_path(Compass.configuration.extensions_path, Compass.configuration.project_path)
extension_paths    = extension_paths + Sass::Util.glob(File.join(absolute_ext_path, '**'))
extension_paths    = extension_paths + Sass::Util.glob(File.join(absolute_ext_path, '**', 'lib'))
# Add compass extension paths to the ruby load paths
extension_paths.each { |path| $: << path }
# for rails upgrade warnings in 0.12
require 'compass/app_integration/rails'
