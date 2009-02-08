require File.join(File.dirname(__FILE__), 'project_base')
require File.join(Compass.lib_directory, 'compass', 'compiler')

module Compass
  module Commands
    class UpdateProject < ProjectBase
      
      def initialize(working_path, options)
        super
        assert_project_directory_exists!
      end

      def perform
        read_project_configuration
        default_options = { :style => default_output_style }
        compilation_options = default_options.merge(options).merge(:load_paths => sass_load_paths)
        Compass::Compiler.new(working_path,
                              projectize(project_src_subdirectory),
                              projectize(project_css_subdirectory),
                              compilation_options).run
      end
      
      def default_output_style
        if options[:environment] == :development
          :expanded
        else
          :compact
        end
      end

      # where to load sass files from
      def sass_load_paths
        [project_src_directory] + Compass::Frameworks::ALL.map{|f| f.stylesheets_directory}
      end
      
      # The subdirectory where the sass source is kept.
      def project_src_subdirectory
        Compass.configuration.sass_dir ||= options[:src_dir] || "src"
      end

      # The subdirectory where the css output is kept.
      def project_css_subdirectory
        Compass.configuration.css_dir ||= options[:css_dir] || "stylesheets"
      end

      # The directory where the project source files are located.
      def project_src_directory
        @project_src_directory ||= separate("#{project_directory}/#{project_src_subdirectory}")
      end

      def assert_project_directory_exists!
        if File.exists?(project_directory) && !File.directory?(project_directory)
          raise Compass::FilesystemConflict.new("#{project_directory} is not a directory.")
        elsif !File.directory?(project_directory)
          raise Compass::Error.new("#{project_directory} does not exist.")
        end
      end

    end
  end
end