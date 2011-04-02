%w(configuration_defaults installer).each do |lib|
  require "compass/app_integration/rails/#{lib}"
end

require 'compass/app_integration/rails/runtime' if defined?(ActionController::Base)


module Compass
  module AppIntegration
    module Rails

      extend self

      def booted!
        Compass::AppIntegration::Rails.const_set(:BOOTED, true)
      end

      def booted?
        defined?(Compass::AppIntegration::Rails::BOOTED) && Compass::AppIntegration::Rails::BOOTED
      end

      def installer(*args)
        Installer.new(*args)
      end

      def configuration
        Compass::Configuration::Data.new('rails').
          extend(ConfigurationDefaults)
      end

      def env
        env_production? ? :production : :development
      end

      def env_production?
        if defined?(::Rails) && ::Rails.respond_to?(:env)
          ::Rails.env.production?
        elsif defined?(RAILS_ENV)
          RAILS_ENV == "production"
        end
      end

      def root
        if defined?(::Rails) && ::Rails.respond_to?(:root)
          ::Rails.root
        elsif defined?(RAILS_ROOT)
          RAILS_ROOT
        end
      end

      def initialize!(config = nil)
        if booted?
          Compass::Util.compass_warn("Warning: Compass was booted twice. Compass has a Railtie now; please remove your intializer.")
        else
          booted!
        end
        config ||= Compass.detect_configuration_file(root)
        Compass.add_project_configuration(config, :project_type => :rails)
        Compass.discover_extensions!
        Compass.configure_sass_plugin!
        Compass.handle_configuration_change!
      end
    end
  end
end

