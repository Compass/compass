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
    end
  end

  extend Configuration::Helpers
  
end
