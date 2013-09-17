require 'fileutils'
require 'pathname'
require 'compass/commands/base'
require 'compass/commands/update_project'
require 'compass/watcher'
require 'sass/plugin'

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
        # '.' assumes you are in the executing directory. so get the full path to the directory
        if options[:project_name] == '.'
          Compass.configuration.project_path = Dir.pwd
        end
        
        project_watcher = Compass::Watcher::ProjectWatcher.new(Compass.configuration.project_path, Compass.configuration.watches, options, options[:poll])

        puts ">>> Compass is watching for changes. Press Ctrl-C to Stop."
        $stdout.flush
        
        project_watcher.compile
        project_watcher.watch!


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
