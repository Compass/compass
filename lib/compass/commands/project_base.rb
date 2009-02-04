require 'rubygems'
require 'sass'
require 'fileutils'
require 'pathname'
require File.join(File.dirname(__FILE__), 'base')

module Compass
  module Commands
    class ProjectBase < Base
      attr_accessor :project_directory, :project_name, :options

      def initialize(working_directory, options = {})
        super(working_directory, options)
        self.project_name = determine_project_name(working_directory, options)
        Compass.configuration.project_path = determine_project_directory(working_directory, options)
        assert_project_directory_exists!
      end
      
      protected

      def directory(subdir, options = nil)
        subdir ||= project_directory
        subdir = projectize(subdir) unless absolute_path?(subdir)
        super(subdir, options)
      end

      def template(from, to, options)
        to = projectize(to) unless absolute_path?(to)
        super(from, to, options)
      end

      def write_file(path, contents)
        path = projectize(path) unless absolute_path?(path)
        super(path, contents)
      end

      def projectize(path)
        File.join(project_directory, separate(path))
      end

      def project_directory
        Compass.configuration.project_path
      end

      def project_css_subdirectory
        Compass.configuration.css_dir
      end
      def project_src_subdirectory
        Compass.configuration.sass_dir
      end
      # Read the configuration file for this project
      def read_project_configuration
        if File.exists?(projectize('config.rb'))
          Compass.configuration.parse(projectize('config.rb'))
        elsif File.exists?(projectize('src/config.rb'))
          Compass.configuration.parse(projectize('src/config.rb'))
        end
      end

      private
      
      def determine_project_name(working_directory, options)
        if options[:project_name]
          File.basename(strip_trailing_separator(options[:project_name]))
        else
          File.basename(working_directory)
        end
      end

      def determine_project_directory(working_directory, options)
        if options[:project_name]
          if absolute_path?(options[:project_name])
            options[:project_name]
          else
            File.join(working_directory, options[:project_name])
          end
        else
          working_directory          
        end
      end

      def assert_project_directory_exists!
        if File.exists?(project_directory) && !File.directory?(project_directory)
          raise Compass::Exec::ExecError.new("#{project_directory} is not a directory.")
        elsif !File.directory?(project_directory) && !skip_project_directory_assertion?
          raise ::Compass::Exec::ExecError.new("#{project_directory} does not exist.")
        end
      end

      def skip_project_directory_assertion?
        options[:force] || options[:dry_run]
      end

      def strip_trailing_separator(path)
        (path[-1..-1] == File::SEPARATOR) ? path[0..-2] : path
      end
    end
  end
end