require 'fileutils'
require File.join(File.dirname(__FILE__), 'base')
require File.join(File.dirname(__FILE__), 'update_project')

module Compass
  module Commands
    class CreateProject < Base
      
      attr_accessor :project_directory, :project_name

      def initialize(working_directory, options)
        super(working_directory, options)
        self.project_name = options[:project_name]
        self.project_directory = File.expand_path File.join(working_directory, project_name)
      end
      
      # all commands must implement perform
      def perform
        directory nil, options
        directory 'stylesheets', options.merge(:force => true)
        directory 'src', options.merge(:force => true)
        template 'project/screen.sass', 'src/screen.sass', options
        template 'project/print.sass',  'src/print.sass', options
        template 'project/ie.sass',     'src/ie.sass', options
        UpdateProject.new(working_directory, options).perform
      end

    end
  end
end