require 'compass/commands/project_base'
require 'compass/commands/update_project'

module Compass
  module Commands
    module StructureOptionsParser
      def set_options(opts)
        opts.banner = %Q{
          Usage: compass structure [path/to/project] [options]

          Description:
            Display the import structure of your stylesheets.

          Options:
        }.strip.split("\n").map{|l| l.gsub(/^ {0,10}/,'')}.join("\n")

        super
      end
    end
    class ProjectStats < UpdateProject

      register :structure

      def initialize(working_path, options)
        super
        assert_project_directory_exists!
      end

      def perform
        @compiler = new_compiler_instance
        (options[:sass_files] || sorted_sass_files).each do |sass_file|
          print_tree(Compass.projectize(sass_file))
        end
      end

      def print_tree(file, depth = 0, importer = @compiler.importer)
        puts ((depth > 0 ? "|  " : "   ") * depth) + "+- " + Compass.deprojectize(file)
        @compiler.staleness_checker.send(:compute_dependencies, file, importer).each do |(dep, dep_importer)|
          print_tree(dep, depth + 1, dep_importer)# unless Compass.deprojectize(dep)[0...1] == "/"
        end
      end

      def sorted_sass_files
        sass_files = @compiler.sass_files
        sass_files.map! do |s| 
          filename = Compass.deprojectize(s, File.join(Compass.configuration.project_path, Compass.configuration.sass_dir))
          [s, File.dirname(filename), File.basename(filename)]
        end
        sass_files = sass_files.sort_by do |s,d,f|
          File.join(d, f[0] == ?_ ? f[1..-1] : f)
        end
        sass_files.map!{|s,d,f| s}
      end

      class << self

        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(Compass::Exec::GlobalOptionsParser)
          parser.extend(Compass::Exec::ProjectOptionsParser)
          parser.extend(StructureOptionsParser)
        end

        def usage
          option_parser([]).to_s
        end

        def description(command)
          "Report statistics about your stylesheets"
        end

        def primary; false; end

        def parse!(arguments)
          parser = option_parser(arguments)
          parser.parse!
          parse_arguments!(parser, arguments)
          parser.options
        end

        def parse_arguments!(parser, arguments)
          if arguments.size > 0
            parser.options[:project_name] = arguments.shift if File.directory?(arguments.first)
            parser.options[:sass_files] = arguments
          end
        end

      end

    end
  end
end

