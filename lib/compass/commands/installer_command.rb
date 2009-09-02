require File.join(Compass.lib_directory, 'compass', 'installers')

module Compass
  module Commands
    module InstallerCommand
      include Compass::Installers

      def configure!
        Compass.add_configuration(installer.default_configuration)
        Compass.add_project_configuration
        Compass.add_configuration(options)
        Compass.add_configuration(installer.completed_configuration)
        if File.exists?(Compass.configuration.extensions_path)
          Compass::Frameworks.discover(Compass.configuration.extensions_path)
        end
      end

      def installer
        project_type = options[:project_type] || Compass.configuration.project_type
        installer_class = "Compass::AppIntegration::#{camelize(project_type)}::Installer"
        @installer = eval("#{installer_class}.new *installer_args")
      end

      # Stolen from ActiveSupport
      def camelize(s)
        s.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      end

      def installer_args
        [template_directory(options[:pattern]), project_directory, options]
      end
    end
  end
end