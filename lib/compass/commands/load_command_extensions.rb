module Compass
  module Commands
    class CommandExtensionLoader

      def self.load_extensions_in_config
        Compass.add_project_configuration(nil, :defaults => Compass.configuration_for({}, "cli_defaults"))
        command_extensions = Compass.configuration.command_extensions

        if command_extensions.is_a?(Array)
          command_extensions.each do |command|
            load_extension(get_extension_name(command))
          end
        else
          load_extension(get_extension_name(command_extensions))
        end
      end

      private

      def self.get_extension_name(name)
        if name.start_with?('compass-')
          return name
        else
          return 'compass-' + name
        end
      end

      def self.load_extension(gem_name)
        require gem_name
        rescue LoadError => e
          puts e.message
          puts "\nPlease either install it:\n\nsudo gem install #{gem_name}\n\nor remove the reference to it on the command_extensions line of your config.rb file\n\n"
          raise Compass::MissingDependency
      end

    end
  end
end