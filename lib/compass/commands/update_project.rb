require File.join(File.dirname(__FILE__), 'project_base')

module Compass
  module Commands
    class UpdateProject < ProjectBase
      
      Base::ACTIONS << :compile
      Base::ACTIONS << :overwrite

      def perform
        read_project_configuration
        Dir.glob(separate("#{project_src_directory}/**/[^_]*.sass")).each do |sass_file|
          stylesheet_name = sass_file[("#{project_src_directory}/".length)..-6]
          compile "#{project_src_subdirectory}/#{stylesheet_name}.sass", "#{project_css_subdirectory}/#{stylesheet_name}.css", options
        end
      end

      # Compile one Sass file
      def compile(sass_filename, css_filename, options)
        sass_filename = projectize(sass_filename)
        css_filename = projectize(css_filename)
        if !File.directory?(File.dirname(css_filename))
          directory basename(File.dirname(css_filename)), options.merge(:force => true) unless options[:dry_run]
        end
        print_action :compile, basename(sass_filename)
        if File.exists?(css_filename)
          print_action :overwrite, basename(css_filename)
        else
          print_action :create, basename(css_filename)
        end
        unless options[:dry_run]
          engine = ::Sass::Engine.new(open(sass_filename).read,
                                      :filename => sass_filename,
                                      :line_comments => options[:environment] == :development,
                                      :style => output_style,
                                      :css_filename => css_filename,
                                      :load_paths => sass_load_paths)
          output = open(css_filename,'w')
          output.write(engine.render)
          output.close
        end
      end
      
      def output_style
        @output_style ||= options[:style] || if options[:environment] == :development
          :expanded
        else
          :compact
        end
      end

      # where to load sass files from
      def sass_load_paths
        @sass_load_paths ||= [project_src_directory] + Compass::Frameworks::ALL.map{|f| f.stylesheets_directory}
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

    end
  end
end