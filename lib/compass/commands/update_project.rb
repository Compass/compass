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
        assert_project_directory_exists! unless dry_run?
      end

      def perform
        compiler = new_compiler_instance
        check_for_sass_files!(compiler)
        compiler.clean! if compiler.new_config?
        error_count = compiler.run
        failed! if error_count > 0
      end

      def check_for_sass_files!(compiler)
        if compiler.sass_files.empty? && !dry_run?
          message = "Nothing to compile. If you're trying to start a new project, you have left off the directory argument.\n"
          message << "Run \"compass -h\" to get help."
          raise Compass::Error, message
        end
      end

      def dry_run?
        options[:dry_run]
      end

      def new_compiler_instance(additional_options = {})
        @compiler_opts ||= begin
          compiler_opts = {:sass => Compass.sass_engine_options}
          compiler_opts.merge!(options)
          compiler_opts[:sass_files] = explicit_sass_files
          compiler_opts[:cache_location] = determine_cache_location
          if options.include?(:debug_info) && options[:debug_info]
            compiler_opts[:sass][:debug_info] = options.delete(:debug_info)
          end
          compiler_opts
        end

        @memory_store ||= Sass::CacheStores::Memory.new
        @backing_store ||= compiler_opts[:cache_store]
        @backing_store ||= Sass::CacheStores::Filesystem.new(determine_cache_location)
        @cache_store ||= Sass::CacheStores::Chain.new(@memory_store, @backing_store)
        @memory_store.reset!

        Compass::Compiler.new(
          working_path,
          Compass.configuration.sass_path,
          Compass.configuration.css_path,
          @compiler_opts.merge(:cache_store => @cache_store).merge(additional_options)
        )
      end

      def explicit_sass_files
        return unless options[:sass_files]
        options[:sass_files].map do |sass_file|
          if absolute_path? sass_file
            sass_file
          else
            File.join(Dir.pwd, sass_file)
          end
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
              parser.options[:sass_files] = arguments.dup
              parser.options[:force] = true
            end
          end
        end
      end
    end
  end
end
