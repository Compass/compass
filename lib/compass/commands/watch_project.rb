require 'fileutils'
require 'pathname'
require 'compass/commands/base'
require 'compass/commands/update_project'
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
        Signal.trap("INT") do
          puts ""
          exit 0
        end

        check_for_sass_files!(new_compiler_instance)
        recompile

        require 'fssm'


        if options[:poll]
          require "fssm/backends/polling"
          # have to silence the ruby warning about chaning a constant.
          stderr, $stderr = $stderr, StringIO.new
          FSSM::Backends.const_set("Default", FSSM::Backends::Polling)
          $stderr = stderr
        end

        action = FSSM::Backends::Default.to_s == "FSSM::Backends::Polling" ? "polling" : "watching"

        puts ">>> Compass is #{action} for changes. Press Ctrl-C to Stop."
        $stdout.flush

        begin
        FSSM.monitor do |monitor|
          Compass.configuration.sass_load_paths.each do |load_path|
            load_path = load_path.root if load_path.respond_to?(:root)
            next unless load_path.is_a? String
            monitor.path load_path do |path|
              path.glob '**/*.s[ac]ss'

              path.update &method(:recompile)
              path.delete {|base, relative| remove_obsolete_css(base,relative); recompile(base, relative)}
              path.create &method(:recompile)
            end
          end
          Compass.configuration.watches.each do |glob, callback|
            monitor.path Compass.configuration.project_path do |path|
              path.glob glob
              path.update do |base, relative|
                puts ">>> Change detected to: #{relative}"
                $stdout.flush
                callback.call(base, relative)
              end
              path.create do |base, relative|
                puts ">>> New file detected: #{relative}"
                $stdout.flush
                callback.call(base, relative)
              end
              path.delete do |base, relative|
                puts ">>> File Removed: #{relative}"
                $stdout.flush
                callback.call(base, relative)
              end
            end
          end

        end
      rescue FSSM::CallbackError => e
        # FSSM catches exit? WTF.
        if e.message =~ /exit/
          exit
        end
      end
      end

      def remove_obsolete_css(base = nil, relative = nil)
        compiler = new_compiler_instance(:quiet => true)
        sass_files = compiler.sass_files
        deleted_sass_files = (last_sass_files || []) - sass_files
        deleted_sass_files.each do |deleted_sass_file|
          css_file = compiler.corresponding_css_file(deleted_sass_file)
          remove(css_file) if File.exists?(css_file)
        end
        self.last_sass_files = sass_files
      end

      def recompile(base = nil, relative = nil)
        @memory_cache.reset! if @memory_cache
        compiler = new_compiler_instance(:quiet => true, :loud => [:identical, :overwrite, :create])
        if file = compiler.out_of_date?
          begin
            puts ">>> Change detected at "+Time.now.strftime("%T")+" to: #{relative || compiler.relative_stylesheet_name(file)}"
            $stdout.flush
            compiler.run
            GC.start
          rescue StandardError => e
            ::Compass::Exec::Helpers.report_error(e, options)
          end
        end
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
