module Compass
  module Configuration
    # The helpers are available as methods on the Compass module. E.g. Compass.configuration
    module Helpers
      def configuration
        @configuration ||= default_configuration
        if block_given?
          yield @configuration
        end
        @configuration
      end

      def default_configuration
        Data.new.extend(Defaults).extend(Comments)
      end

      def add_configuration(config, filename = nil)
        return if config.nil?
        data = if config.is_a?(Compass::Configuration::Data)
          config
        elsif config.respond_to?(:read)
          Compass::Configuration::Data.new_from_string(config.read, filename)
        elsif config.is_a?(Hash)
          Compass::Configuration::Data.new(config)
        elsif config.is_a?(String)
          Compass::Configuration::Data.new_from_file(config)
        else
          raise "I don't know what to do with: #{config.inspect}"
        end
        data.inherit_from!(configuration)
        data.on_top!
        @configuration = data
      end

      # Support for testing.
      def reset_configuration!
        @configuration = nil
      end

      def sass_plugin_configuration
        configuration.to_sass_plugin_options
      end

      def configure_sass_plugin!
        @sass_plugin_configured = true
        Sass::Plugin.options.merge!(sass_plugin_configuration)
      end

      def sass_plugin_configured?
        @sass_plugin_configured
      end

      def sass_engine_options
        configuration.to_sass_engine_options
      end

      # Read the configuration file for this project
      def add_project_configuration(configuration_file_path = nil)
        configuration_file_path ||= detect_configuration_file
        Compass.add_configuration(configuration_file_path) if configuration_file_path
      end

      # Returns a full path to the relative path to the project directory
      def projectize(path, project_path = nil)
        project_path ||= configuration.project_path
        File.join(project_path, *path.split('/'))
      end

      def deprojectize(path, project_path = nil)
        project_path ||= configuration.project_path
        if path[0..(project_path.size - 1)] == project_path
          path[(project_path.size + 1)..-1]
        else
          path
        end
      end

      # TODO: Deprecate the src/config.rb location.
      KNOWN_CONFIG_LOCATIONS = ['config/compass.rb', ".compass/config.rb", "config/compass.config", "config.rb", "src/config.rb"]

      # Finds the configuration file, if it exists in a known location.
      def detect_configuration_file(project_path = nil)
        possible_files = KNOWN_CONFIG_LOCATIONS.map{|f| projectize(f, project_path) }
        possible_files.detect{|f| File.exists?(f)}
      end

    end
  end

  extend Configuration::Helpers
  
end
