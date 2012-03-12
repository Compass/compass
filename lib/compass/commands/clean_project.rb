require 'compass/commands/project_base'
require 'compass/compiler'

module Compass
  module Commands
    module CleanProjectOptionsParser
      def set_options(opts)
        opts.banner = %Q{
          Usage: compass clean [path/to/project] [options]

          Description:
          Remove generated files and the sass cache.

          Options:
        }.split("\n").map{|l| l.gsub(/^ */,'')}.join("\n")

        super
      end
    end

    class CleanProject < UpdateProject

      register :clean

      def initialize(working_path, options)
        super
        assert_project_directory_exists!
      end

      def perform
        compiler = new_compiler_instance
        compiler.clean!
        Compass::SpriteImporter.find_all_sprite_map_files(Compass.configuration.generated_images_path).each do |sprite|
          remove sprite
        end
      end

      def determine_cache_location
        Compass.configuration.cache_path || Sass::Plugin.options[:cache_location] || File.join(working_path, ".sass-cache")
      end

      class << self
        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(Compass::Exec::GlobalOptionsParser)
          parser.extend(Compass::Exec::ProjectOptionsParser)
          parser.extend(CleanProjectOptionsParser)
        end

        def usage
          option_parser([]).to_s
        end

        def primary; true; end

        def description(command)
          "Remove generated files and the sass cache"
        end

        def parse!(arguments)
          parser = option_parser(arguments)
          parser.parse!
          parse_arguments!(parser, arguments)
          parser.options
        end

        def parse_arguments!(parser, arguments)
          if arguments.size > 0
            parser.options[:project_name] = arguments.shift if File.directory?(arguments.first)
            unless arguments.empty?
              parser.options[:sass_files] = arguments.dup
              parser.options[:force] = true
            end
          end
        end
      end
    end
  end
end
