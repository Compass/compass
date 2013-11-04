require "compass/core/version"

module Compass
  module Core
    def base_directory(*subdirs)
      File.expand_path(File.join(File.dirname(__FILE__), '..', "..", *subdirs))
    end
    def lib_directory(*subdirs)
      File.expand_path(File.join(File.dirname(__FILE__), "..", *subdirs))
    end

    module_function :base_directory, :lib_directory
  end
end

require "sass"
require "sass/plugin"
require "compass/core/caniuse"
require 'compass/core/sass_extensions'
require 'compass/error'
require 'compass/browser_support'
require 'compass/configuration'

if defined?(Compass::Frameworks)
  Compass::Frameworks.register(
    "compass",
    :stylesheets_directory => Compass::Core.base_directory("stylesheets"),
    :templates_directory => Compass::Core.base_directory("templates")
  )
end
