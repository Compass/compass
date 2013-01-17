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
    module MemoryDebugger
      def report_on_instances(type, options = {})
        @@runs ||= 0
        @@runs += 1
        @@object_id_tracker ||= {}
        @@object_id_tracker[type] ||= []
        GC.start
        sleep options.fetch(:gc_pause, 1)
        count = ObjectSpace.each_object(type) do |obj|
          if options.fetch(:verbose, true)
            if @@runs > 2
              if !@@object_id_tracker[type].include?(obj.object_id)
                begin
                  puts obj.inspect
                rescue
                end
                puts "#{obj.class.name}:#{obj.object_id}"
              end
            end
            @@object_id_tracker[type] << obj.object_id
          end
        end
        puts "#{type}: #{count} instances."
      end
    end
    class WatchProject < UpdateProject

      register :watch

      attr_accessor :last_update_time, :last_sass_files

      include MemoryDebugger

      def perform

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
