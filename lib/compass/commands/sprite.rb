require 'compass/commands/project_base'
require 'compass/commands/update_project'

module Compass
  module Commands
    module SpriteOptionsParser
      def set_options(opts)
        opts.on("-f SPRITE_FILE") do |output_file|
          self.options[:output_file] = output_file
        end
        opts.on("--skip-overrides", "Skip the generation of sprite overrides") do |skip_overrides|
          self.options[:skip_overrides] = skip_overrides
        end
        opts.banner = %Q{
          Usage: compass sprite [options] "images/path/to/sprites/*.png"

          Description:
            Generate a sprite import based on the given sprite directory.
            Alternatively, you can simply do this in your sass files:

                @import "sprite-folder/*.png"

            And a magical, custom made sprite file will be imported.

          Options:
        }.strip.split("\n").map{|l| l.gsub(/^ {0,10}/,'')}.join("\n")

        super
      end
    end
    class Sprite < ProjectBase

      register :sprite

      def initialize(working_path, options)
        super
        assert_project_directory_exists!
      end

      def perform
        relative_uri = options[:uri].gsub(/^#{Compass.configuration.images_dir}\//, '')
        name = Compass::SpriteImporter.sprite_name(relative_uri)
        sprites = Compass::SpriteImporter.new
        options[:output_file] ||= File.join(Compass.configuration.sass_path, "sprites", "_#{name}.#{Compass.configuration.preferred_syntax}")
        options[:skip_overrides] ||= false
        contents = Compass::SpriteImporter.content_for_images(relative_uri, name, options[:skip_overrides])
        if options[:output_file][-4..-1] != "scss"
          contents = Sass::Engine.new(contents, Compass.sass_engine_options.merge(:syntax => :scss)).to_tree.to_sass
        end
        directory File.dirname(options[:output_file])
        write_file options[:output_file], contents
      end

      class << self

        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(Compass::Exec::GlobalOptionsParser)
          parser.extend(Compass::Exec::ProjectOptionsParser)
          parser.extend(SpriteOptionsParser)
        end

        def usage
          option_parser([]).to_s
        end

        def description(command)
          "Generate an import for your sprites."
        end

        def parse!(arguments)
          parser = option_parser(arguments)
          parser.parse!
          parse_arguments!(parser, arguments)
          parser.options
        end

        def parse_arguments!(parser, arguments)
          parser.options[:uri] = arguments.shift
          unless arguments.size == 0
            raise Compass::Error, "Please specify at least one image to sprite."
          end
        end

      end

    end
  end
end
