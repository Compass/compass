require 'listen'
require 'forwardable'
module Compass
  module Watcher
    class ProjectWatcher
      include Compass::Actions
      SASS_FILTER = '*.s[ac]ss'
      ALL_CHILDREN_SASS_FILTER = File.join('**', SASS_FILTER)
      POLLING_MESSAGE = 'Compass is polling for changes'

      attr_reader :options, :project_path, :watcher_compiler, :listener, :poll, :css_dir, :watchers

      alias :working_path :project_path

      extend Forwardable
  
      def_delegators :@watcher_compiler, :compiler, :compiler
      def_delegators :@watcher_compiler, :compile, :compile

      def initialize(project_path, watches=[], options={}, poll=false)
        @poll             = poll
        @options          = options
        @project_path     = project_path
        @css_dir          = Compass.configuration.css_dir
        @watchers         = [SassWatch.new(&method(:sass_callback))] + watches
        @watcher_compiler = Compass::Watcher::Compiler.new(project_path, options)
        setup_listener
      end

      def watch!
        listener.start!
      rescue Interrupt
        logger.log "\nHappy Styling!"
        listener.stop
      end

    private #============================================================================>

      def setup_listener
        @listener = Listen::Listener.new(directories_to_watch,
                                         :relative_paths => false)
        @listener = listener.force_polling(true) if poll
        @listener = listener.polling_fallback_message(POLLING_MESSAGE)
        @listener = listener.ignore(/\.css$/)
        @listener = listener.change(&method(:listen_callback))
      end

      def directories_to_watch
        @directories_to_watch ||= begin
                                    dirs = [Compass.configuration.sass_path] +
                                      Compass.configuration.sass_load_paths.map{|p| p.directories_to_watch}
                                    dirs.flatten!
                                    dirs.compact!
                                    dirs.select {|d| File.writable?(d) }
                                  end
      end

      def listen_callback(modified_files, added_files, removed_files)
        #log_action(:info, ">>> Listen Callback fired added: #{added_files}, mod: #{modified_files}, rem: #{removed_files}", {})
        files = {:modified => modified_files,
                 :added    => added_files,
                 :removed  => removed_files}

        run_once, run_each = watchers.partition {|w| w.run_once_per_changeset?}

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

      def sass_callback(base, file, action)
        #log_action(:info, ">>> Sass Callback fired #{action}, #{file}", {})
        full_filename = File.expand_path(File.join(base,file))
        case action
        when :modified
          sass_modified(full_filename)
        when :added
          sass_added(full_filename)
        when :removed
          sass_removed(full_filename)
        else
          raise ArgumentError, "Illegal Action: #{action.inspect}"
        end
      end

      def sass_modified(file)
        log_action(:info, "#{filename_for_display(file)} was modified", options)
        compile
      end

      def sass_added(file)
        log_action(:info, "#{filename_for_display(file)} was added", options)
        compile
      end

      def sass_removed(file)
        log_action(:info, "#{filename_for_display(file)} was removed", options)
        css_file = compiler.corresponding_css_file(file)
        sourcemap_file = compiler.corresponding_sourcemap_file(file)
        compile
        remove(css_file) if File.exists?(css_file)
        remove(sourcemap_file) if File.exists?(sourcemap_file)
      end

      def local_development_locations
        @local_development_locations ||= begin
                                          r = [Compass.configuration.sass_path] + Array(Compass.configuration.additional_import_paths)
                                          r.map!{|l| File.expand_path(l) }
                                         end
      end

      def filename_for_display(f)
        if framework = Frameworks::ALL.detect {|fmwk| in_directory?(fmwk.stylesheets_directory, f) }
          "(#{framework.name}) #{relative_to(f, framework.stylesheets_directory)}"
        elsif directories_to_watch.detect{|d| in_directory?(d, f) }
          relative_to_working_directory(f)
        else
          f
        end
      end

      def in_directory?(dir, f)
        dir && (f[0...(dir.size)] == dir)
      end

      def relative_to_working_directory(f)
        relative_to(f, Dir.pwd)
      end

      def relative_to(f, dir)
        Pathname.new(f).relative_path_from(Pathname.new(dir))
      rescue ArgumentError # does not share a common path.
        f
      end
    end
  end
end
