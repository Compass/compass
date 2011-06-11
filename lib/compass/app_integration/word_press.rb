%w(configuration_defaults installer).each do |lib|
  require "compass/app_integration/word_press/#{lib}"
end

module Compass
  module AppIntegration
    module WordPress

      extend self

      def installer(*args)
        Installer.new(*args)
      end

      def configuration
        Compass::Configuration::Data.new('word_press').
          extend(ConfigurationDefaults)
      end

    end
  end
end
