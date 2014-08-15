# encoding: UTF-8
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
          compiler.watch!(:additional_watch_paths => additional_watch_paths, &method(:notify_watches))
          happy_styling!(compiler.logger)
        rescue Interrupt
          happy_styling!(compiler.logger)
        end
      end

      def happy_styling!(logger)
          logger.log "\n#{logger.color(:yellow)}★★★ #{logger.color(:blue)}Happy Styling!#{logger.color(:yellow)} ★★★#{logger.color(:clear)}"
      end

      def compiler_options
        super.merge(:poll => options[:poll], :full_exception => true)
      end

      def additional_watch_paths
        Compass.configuration.watches.map do |watch|
          pathname = Pathname.new(File.join(Compass.configuration.project_path, watch.glob))
          real_path = nil
          pathname.ascend do |p|
            if p.exist?
              real_path = p
              break
            end
          end
          real_path
        end.compact.uniq
      end

      def notify_watches(modified, added, removed)
        project_path = Compass.configuration.project_path
        files = {:modified => modified,
                 :added    => added,
                 :removed  => removed}

        run_once, run_each = Compass.configuration.watches.partition {|w| w.run_once_per_changeset?}

        run_once.each do |watcher|
          if file = files.values.flatten.detect{|f| watcher.match?(f) }
            action = files.keys.detect{|k| files[k].include?(file) }
            watcher.run_callback(project_path, relative_to(file, project_path), action)
          end
        end

        run_each.each do |watcher|
          files.each do |action, list|
            list.each do |file|
              if watcher.match?(file)
                watcher.run_callback(project_path, relative_to(file, project_path), action)
              end
            end
          end
        end
      end

      def relative_to(f, dir)
        Pathname.new(f).relative_path_from(Pathname.new(dir))
      rescue ArgumentError # does not share a common path.
        f
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
