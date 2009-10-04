require 'fileutils'
require 'compass/commands/stamp_pattern'

module Compass
  module Commands
    module CreateProjectOptionsParser
      def set_options(opts)

        opts.banner = %q{
          Usage: compass create path/to/project [options]

          Description:
          Create a new compass project at the path specified.
        }.split("\n").map{|l| l.gsub(/^ */,'')}.join("\n")

        opts.on("--using FRAMEWORK", "Framework to use when creating the project.") do |framework|
          framework = framework.split('/', 2)
          self.options[:framework] = framework[0]
          self.options[:pattern] = framework[1]
        end

        super
      end
    end

    class CreateProject < StampPattern

      register :create
      register :init

      class << self
        def parse!(arguments)
          parser = parse_options!(arguments)
          parse_arguments!(parser, arguments)
          set_default_arguments(parser)
          parser.options
        end

        def parse_init!(arguments)
          parser = parse_options!(arguments)
          if arguments.size > 0
            parser.options[:project_type] = arguments.shift.to_sym
          end
          parse_arguments!(parser, arguments)
          set_default_arguments(parser)
          parser.options
        end

        def parse_options!(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(Compass::Exec::GlobalOptionsParser)
          parser.extend(Compass::Exec::ProjectOptionsParser)
          parser.extend(CreateProjectOptionsParser)
          parser.parse!
          parser
        end

        def parse_arguments!(parser, arguments)
          if arguments.size == 1
            parser.options[:project_name] = arguments.shift
          elsif arguments.size == 0
            raise Compass::Error, "Please specify a path to the project."
          else
            raise Compass::Error, "Too many arguments were specified."
          end
        end

        def set_default_arguments(parser)
          parser.options[:framework] ||= :compass
          parser.options[:pattern] ||= "project"
        end
      end

      def is_project_creation?
        true
      end

    end
  end
end
