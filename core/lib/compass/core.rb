require "compass/core/version"

module Compass
  module Core
    class << self
      attr_accessor :module_deprecation_warning_issued
    end
    def base_directory(*subdirs)
      File.expand_path(File.join(File.dirname(__FILE__), '..', "..", *subdirs))
    end
    def lib_directory(*subdirs)
      File.expand_path(File.join(File.dirname(__FILE__), "..", *subdirs))
    end

    module_function :base_directory, :lib_directory
  end

  module HasDeprecatedConstantsFromCore
    def self.extended(base)
      new_base = base.name.sub(/^Compass/,"Compass::Core")
      base.class_eval <<-RUBY
        def self.const_missing(const_name)
          puts "cannot find \#{const_name}"
          if #{new_base}.const_defined?(const_name)
            unless Compass::Core.module_deprecation_warning_issued
              Compass::Core.module_deprecation_warning_issued = true
              Compass::Util.compass_warn(
                "DEPRECATED: #{base.name}::\#{const_name} has been moved to " +
                "#{new_base}::\#{const_name}.\\n" +
                "Please update \#{caller[0]}")
            end
            #{new_base}.const_get(const_name)
          end
        end
      RUBY
    end
  end

  extend HasDeprecatedConstantsFromCore

  module SassExtensions
    extend HasDeprecatedConstantsFromCore

    module Functions
      extend HasDeprecatedConstantsFromCore
    end
  end
end

require "sass"
require "sass/plugin"
require 'compass/util'
require "compass/core/caniuse"
require 'compass/core/sass_extensions'
require 'compass/error'
require 'compass/browser_support'
require 'compass/configuration'

if defined?(Compass::Frameworks)
  Compass::Frameworks.register(
    "compass",
    :stylesheets_directory => Compass::Core.base_directory("stylesheets"),
    :templates_directory => Compass::Core.base_directory("templates"),
    :version => Compass::Core::VERSION
  )
else
  if ENV.has_key?("SASS_PATH")
    ENV["SASS_PATH"] = ENV["SASS_PATH"] + File::PATH_SEPARATOR + Compass::Core.base_directory("stylesheets")
  else
    ENV["SASS_PATH"] = Compass::Core.base_directory("stylesheets")
  end
end
