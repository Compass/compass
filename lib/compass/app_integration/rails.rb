%w(configuration_defaults installer).each do |lib|
  require "compass/app_integration/rails/#{lib}"
end

require 'compass/app_integration/rails/runtime' if defined?(ActionController::Base)


module Compass
  module AppIntegration
    module Rails

      extend self

      def installer(*args)
        Installer.new(*args)
      end

      def configuration
        Compass::Configuration::Data.new('rails').
          extend(ConfigurationDefaults)
      end

      def env
        if rails_env = (defined?(::Rails) ? ::Rails.env : (defined?(RAILS_ENV) ? RAILS_ENV : nil))
          rails_env.production? ? :production : :development
        end
      end

    end
  end
end

