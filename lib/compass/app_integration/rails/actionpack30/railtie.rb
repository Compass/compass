require 'compass'
require 'rails'

class Rails::Railtie::Configuration
  # Adds compass configuration accessor to the application configuration.
  #
  # If a configuration file for compass exists, it will be read in and
  # the project's configuration values will already be set on the config
  # object.
  #
  # For example:
  #
  #     module MyApp
  #       class Application < Rails::Application
  #          config.compass.line_comments = !Rails.env.production?
  #          config.compass.fonts_dir = "app/assets/fonts"
  #       end
  #     end
  #
  # It is suggested that you create a compass configuration file if you
  # want a quicker boot time when using the compass command line tool.
  #
  # For more information on available configuration options see:
  # http://compass-style.org/help/tutorials/configuration-reference/
  def compass
    @compass ||= begin
      data = if (config_file = Compass.detect_configuration_file) && (config_data = Compass.configuration_for(config_file))
        config_data
      else
        Compass::Configuration::Data.new("project")
      end
      data.project_type = :rails # Forcing this makes sure all the rails defaults will be loaded.
      data
    end
  end
end

module Compass
  class Railtie < Rails::Railtie
    initializer "compass.initialize_rails" do |app|
      # Configure compass for use within rails, and provide the project configuration
      # that came via the rails boot process.
      Compass::AppIntegration::Rails.initialize!(app.config.compass)
    end
  end
end