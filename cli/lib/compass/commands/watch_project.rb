require 'fileutils'
require 'pathname'
require 'compass/commands/update_project'
require "compass/sass_compiler"

module Compass
  module Commands
    module WatchProjectOptionsParser
      def set_options(opts)
        super

        opts.banner = %Q{
          Usage: compass watch [path/to/project] [path/to/project/src/file.sass ...] [options]

          Description:
          watch the project for changes and recompile when they occur.

          Options:
        }.split("\n").map{|l| l.gsub(/^ */,'')}.join("\n")

        opts.on("--poll", :NONE, "Check periodically if there's been changes.") do
          self.options[:poll] = 1 # check every 1 second.
        end

      end
    end

    class WatchProject < UpdateProject

      register :watch

      attr_accessor :last_update_time, :last_sass_files

      def perform
        compiler = new_compiler_instance
        compiler.logger.time = true if options[:time]
        prepare_project!(compiler)
        compiler.logger.log ">>> #{compiler.logger.color(:green)}Compass is watching for changes.#{compiler.logger.color(:clear)} #{compiler.logger.color(:red)}Press Ctrl-C to Stop.#{compiler.logger.color(:clear)}"
        begin
          compiler.watch!
        rescue Interrupt
          compiler.logger.log "Happy Styling!"
        end
      end

      def compiler_options
        super.merge(:poll => options[:poll])
      end

      class << self
        def description(command)
          "Compile Sass stylesheets to CSS when they change"
        end

        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(Compass::Exec::GlobalOptionsParser)
          parser.extend(Compass::Exec::ProjectOptionsParser)
          parser.extend(CompileProjectOptionsParser)
          parser.extend(WatchProjectOptionsParser)
        end
      end
    end
  end
end
