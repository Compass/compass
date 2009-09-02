module Compass
  module Installers
    class Base
    end
  end

  module AppIntegration
    module StandAlone
      class Installer < Compass::Installers::Base

        def init
          directory targetize("")
          super
        end

        def write_configuration_files(config_file = nil)
          config_file ||= targetize('config.rb')
          write_file config_file, config_contents
        end

        def config_files_exist?
          File.exists? targetize('config.rb')
        end

        def config_contents
          project_path, Compass.configuration.project_path = Compass.configuration.project_path, nil
          Compass.configuration.serialize
        ensure
          Compass.configuration.project_path = project_path
        end

        def prepare
          write_configuration_files unless config_files_exist? || !@manifest.generate_config?
        end

        def default_configuration
          Compass::Configuration::Data.new.extend(Compass::AppIntegration::StandAlone::ConfigurationDefaults)
        end

        def completed_configuration
          nil
        end

        def finalize(options = {})
          if options[:create]
            puts <<-NEXTSTEPS

  Congratulations! Your compass project has been created.
  You must recompile your sass stylesheets when they change.
  This can be done in one of the following ways:
    1. From within your project directory run:
       compass
    2. From any directory run:
       compass -u path/to/project
    3. To monitor your project for changes and automatically recompile:
       compass --watch [path/to/project]
  NEXTSTEPS
          end
          if manifest.has_stylesheet?
            puts "\nTo import your new stylesheets add the following lines of HTML (or equivalent) to your webpage:"
            puts stylesheet_links
          end
        end

        def compilation_required?
          @manifest.compile?
        end
      end
    end
  end
end
