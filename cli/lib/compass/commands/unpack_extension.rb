require 'compass/commands/project_base'
require 'fileutils'

module Compass
  module Commands
    module ExtensionOptionsParser
      def set_options(opts)
        opts.banner = %Q{
          Usage: compass unpack EXTENSION

          Description:
            Copy an extension into your extensions folder for easy access to the source code.
            This makes it easier to peruse the source in unfamiliar projects. It is not recommended
            that you change other extensions' source -- this makes it hard to take updates from
            the original author. The following extensions are available:
            
          FRAMEWORKS
            
          Options:
        }.strip.split("\n").map{|l| l.gsub(/^ {0,10}/,'')}.join("\n")
        opts.banner.gsub!(/FRAMEWORKS/,Compass::Frameworks.pretty_print(true))
        super
      end
    end

    class UnpackExtension < ProjectBase

      register :unpack

      def initialize(working_path, options)
        super
        assert_project_directory_exists!
      end

      def perform
        framework = Compass::Frameworks[options[:framework]]
        unless framework
          raise Compass::Error, "No extension named \"#{options[:framework]}\" was found."
        end
        files = Dir["#{framework.path}/**/*"]
        extension_dir = File.join(Compass.configuration.extensions_path, framework.name)
        FileUtils.rm_rf extension_dir
        FileUtils.mkdir_p extension_dir
        write_file File.join(extension_dir, "DO_NOT_MODIFY"), readme(framework)
        files.each do |f|
          next if File.directory?(f)
          ending = f[(framework.path.size+1)..-1]
          destination = File.join(extension_dir, ending)
          FileUtils.mkdir_p(File.dirname(destination))
          copy f, destination
        end
        puts "\nYou have unpacked \"#{framework.name}\""
        puts
        puts readme(framework)
      end

      def readme(framework)
        %Q{| This is a copy of the "#{framework.name}" extension.
           |
           | It now overrides the original which was found here:
           |
           | #{framework.path}
           |
           | Unpacking an extension is useful when you need to easily peruse the
           | extension's source. You might find yourself tempted to change the
           | stylesheets here. If you do this, you'll find it harder to take
           | updates from the original author. Sometimes this seems like a good
           | idea at the time, but in a few months, you'll probably regret it.
           |
           | In the future, if you take an update of this framework, you'll need to run
           |
           |     compass unpack #{framework.name}
           |
           | again or remove this unpacked extension.
           |}.gsub(/^\s*\| ?/,"")
      end

      def skip_extension_discovery?
        true
      end

      class << self

        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(Compass::Exec::GlobalOptionsParser)
          parser.extend(Compass::Exec::ProjectOptionsParser)
          parser.extend(ExtensionOptionsParser)
        end

        def usage
          option_parser([]).to_s
        end

        def description(command)
          "Copy an extension into your extensions folder."
        end

        def parse!(arguments)
          parser = option_parser(arguments)
          parser.parse!
          parse_arguments!(parser, arguments)
          parser.options
        end

        def parse_arguments!(parser, arguments)
          if arguments.size == 1
            parser.options[:framework] = arguments.shift
          elsif arguments.size == 0
            raise Compass::Error, "Please specify an extension to unpack."
          else
            raise Compass::Error, "Too many arguments were specified."
          end
        end

      end

    end
  end
end
