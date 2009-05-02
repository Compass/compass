require File.join(File.dirname(__FILE__), 'project_base')

module Compass
  module Commands
    class WriteConfiguration < ProjectBase
      
      include InstallerCommand

      def initialize(working_path, options)
        super
        assert_project_directory_exists!
      end

      def perform
        installer.write_configuration_files
      end

      def installer_args
        [nil, project_directory, options]
      end

    end
  end
end