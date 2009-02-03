require 'fileutils'
require File.join(File.dirname(__FILE__), 'base')
require File.join(File.dirname(__FILE__), 'update_project')
require File.join(Compass.lib_directory, 'compass', 'installers')

module Compass
  module Commands
    class CreateProject < ProjectBase

      include Compass::Installers

      def initialize(working_directory, options)
        super(working_directory, options)
      end
      
      # all commands must implement perform
      def perform
        installer.run(:skip_finalization => true)
        UpdateProject.new(working_directory, options).perform if installer.compilation_required?
        installer.finalize(:create => true)
      end

      def installer
        @installer ||= StandAloneInstaller.new(project_template_directory, project_directory, options)
      end

      def project_template_directory
        File.join(framework.templates_directory, "project")
      end

      def skip_project_directory_assertion?
        true
      end

    end
  end
end