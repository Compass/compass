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
        config = Compass::Configuration::Data.new('rails')
        config.extend(ConfigurationDefaults)
        config.extend(ConfigurationDefaultsWithAssetPipeline) if Sass::Util.ap_geq?('3.1.0') || Sass::Util.ap_geq?('3.1.0.rc') || Sass::Util.ap_geq?('3.1.0.beta')
        config
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

      def check_for_double_boot!
        if booted?
          Compass::Util.compass_warn("Warning: Compass was booted twice. Compass has a Railtie now; please remove your initializer.")
        else
          booted!
        end
      end

      def sass_plugin_enabled?
        unless Sass::Util.ap_geq?('3.1.0.beta')
          defined?(Sass::Plugin) && !Sass::Plugin.options[:never_update]
        end
      end

      def rails_compilation_enabled?
        Sass::Util.ap_geq?('3.1.0.beta') && defined?(Sass::Rails) # XXX check if there's some other way(s) to disable the asset pipeline.
      end

      # Rails 2.x projects use this in their compass initializer.
      def initialize!(config = nil)
        check_for_double_boot!
        config ||= Compass.detect_configuration_file(root)
        Compass.add_project_configuration(config, :project_type => :rails)
        Compass.discover_extensions!
        Compass.configure_sass_plugin!
        Compass.handle_configuration_change! if sass_plugin_enabled? || rails_compilation_enabled?
      end
    end
  end
end

