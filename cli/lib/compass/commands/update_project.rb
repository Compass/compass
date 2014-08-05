require 'compass/commands/project_base'
require 'compass/compiler'

module Compass
  module Commands
    module CompileProjectOptionsParser
      def set_options(opts)
        opts.banner = %Q{
          Usage: compass compile [path/to/project] [path/to/project/src/file.sass ...] [options]

          Description:
          compile project at the path specified or the current directory if not specified.

          Options:
        }.split("\n").map{|l| l.gsub(/^ */,'')}.join("\n")

        opts.on("--[no-]sourcemap", "Generate a sourcemap during compilation.") do |sm|
          self.options[:sourcemap] = sm
        end

        opts.on("--time", "Display compilation times.") do
          self.options[:time] = true
        end

        opts.on("--debug-info", "Turns on sass's debuging information") do
          self.options[:debug_info]= true
        end

        opts.on("--no-debug-info", "Turns off sass's debuging information") do
          self.options[:debug_info]= false
        end
        super
      end
    end

    class UpdateProject < ProjectBase

      register :compile

      def initialize(working_path, options)
        super
        assert_project_directory_exists!
      end

      def perform
        compiler = new_compiler_instance
        check_for_sass_files!(compiler)
        prepare_project!(compiler)
        compiler.compile!
        if compiler.error_count > 0
          compiler.logger.red do
            compiler.logger.log "Compilation failed in #{compiler.error_count} files."
          end
          failed! 
        end
      end

      def prepare_project!(compiler)
        if options[:project_name]
          Compass.configuration.project_path = File.expand_path(options[:project_name])
        end

        if config_file = new_config?(compiler)
          compiler.logger.record :modified, relativize(config_file)
          compiler.logger.record :clean, relativize(Compass.configuration.css_path)
          compiler.clean!
        end
      end

      # Determines if the configuration file is newer than any css file
      def new_config?(compiler)
        config_file = Compass.detect_configuration_file
        return false unless config_file
        config_mtime = File.mtime(config_file)
        compiler.file_list.each do |(_, css_filename, _)|
          return config_file if File.exists?(css_filename) && config_mtime > File.mtime(css_filename)
        end
        nil
      end

      def check_for_sass_files!(compiler)
        file_list = compiler.file_list
        if file_list.empty?
          message = "Compass can't find any Sass files to compile.\nIs your compass configuration correct?.\nIf you're trying to start a new project, you have left off the directory argument.\n"
          message << "Run \"compass -h\" to get help."
          raise Compass::Error, message
        elsif missing = file_list.find {|(sass_file, _, _)| !File.exist?(sass_file)}
          raise Compass::Error, "File not found: #{missing[0]}"
        end
      end

      def new_compiler_instance
        Compass::SassCompiler.new(compiler_options)
      end

      def compiler_options
        transfer_options(options, {}, :time, :debug_info, :only_sass_files, :force, :quiet)
      end

      def transfer_options(from, to, *keys)
        keys.each do |k|
          to[k] = from[k] unless from[k].nil?
        end
        to
      end

      class << self
        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(Compass::Exec::GlobalOptionsParser)
          parser.extend(Compass::Exec::ProjectOptionsParser)
          parser.extend(CompileProjectOptionsParser)
        end

        def usage
          option_parser([]).to_s
        end

        def primary; true; end

        def description(command)
          "Compile Sass stylesheets to CSS"
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
              parser.options[:only_sass_files] = absolutize(*arguments)
            end
          end
        end

        def absolutize(*paths)
          paths.map {|path| File.expand_path(path) }
        end

      end
    end
  end
end
