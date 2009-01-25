require 'fileutils'
require File.join(File.dirname(__FILE__), 'base')
require File.join(File.dirname(__FILE__), 'update_project')

module Compass
  module Commands
    class CreateProject < ProjectBase
      
      def initialize(working_directory, options)
        super(working_directory, options)
      end
      
      # all commands must implement perform
      def perform
        begin
          directory nil, options
        rescue Compass::Exec::DirectoryExistsError
          msg = "Project directory already exists. Run with -u to update or --force to force creation."
          raise ::Compass::Exec::DirectoryExistsError.new(msg)
        end
        src_dir = options[:src_dir] || "src"
        css_dir = options[:css_dir] || "stylesheets"
        directory src_dir, options.merge(:force => true)
        directory css_dir, options.merge(:force => true)
        framework_templates.each do |t|
          template "project/#{t}", "#{src_dir}/#{t}", options
        end
        UpdateProject.new(working_directory, options).perform
      end

      def framework_templates
        framework_project_dir = File.join(templates_directory, "project")
        Dir.chdir(framework_project_dir) do
          Dir.glob("*")
        end
      end

      def skip_project_directory_assertion?
        true
      end

    end
  end
end