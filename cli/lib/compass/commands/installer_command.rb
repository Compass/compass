require 'compass/installers'

module Compass
  module Commands
    module InstallerCommand
      include Compass::Installers

      def configure!
        add_project_configuration
        Compass.add_configuration(options, 'command_line')
        Compass.discover_extensions!
        Compass.add_configuration(installer.completed_configuration, 'installer')
      end

      def app
        @app ||= Compass::AppIntegration.lookup(Compass.configuration.project_type)
      end

      def installer
        @installer ||= if options[:bare]
          Compass::Installers::BareInstaller.new(*installer_args)
        else
          app.installer(*installer_args)
        end
      end

      def installer_args
        [template_directory(options[:pattern] || "project"), project_directory, options]
      end
    end
  end
end
