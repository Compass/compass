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
        src_dir = options[:src_dir] || "src"
        css_dir = options[:css_dir] || "stylesheets"
        directory src_dir, options.merge(:force => true)
        directory css_dir, options.merge(:force => true)
        template 'project/screen.sass', "#{src_dir}/screen.sass", options
        template 'project/print.sass',  "#{src_dir}/print.sass", options
        template 'project/ie.sass',     "#{src_dir}/ie.sass", options
        UpdateProject.new(working_directory, options).perform
      end

    end
  end
end