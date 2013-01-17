require 'listen'
require 'forwardable'
module Compass
  module Watcher
    class ProjectWatcher
      include Compass::Actions
      SASS_FILTER = '*.s[ac]ss'
      ALL_CHILDREN_SASS_FILTER = File.join('**', SASS_FILTER)
      POLLING_MESSAGE = 'Compass is polling for changes'

      attr_reader :options, :project_path, :watcher_compiler, :listener, :poll, :css_dir, :sass_watchers

      alias :working_path :project_path

      extend Forwardable
  
      def_delegators :@watcher_compiler, :compiler, :compiler
      def_delegators :@watcher_compiler, :compile, :compile

      def initialize(project_path, watches=[], options={}, poll=false)
        @poll             = poll
        @options          = options
        @project_path     = project_path
        @css_dir          = Compass.configuration.css_dir
        @sass_watchers    = create_sass_watchers + watches
        @watcher_compiler = Compass::Watcher::Compiler.new(project_path, options)
        setup_listener
      end

      def watch!
        listener.start
      rescue Interrupt
        log_action(:info, "Good bye!", options)
        listener.stop
      end

    private #============================================================================>

      def setup_listener
        @listener = Listen.to(@project_path, :relative_paths => true)
        if poll
          @listener = listener.force_polling(true)
        end
        @listener = listener.polling_fallback_message(POLLING_MESSAGE)
        @listener = listener.ignore(/\.css$/)
        @listener = listener.change(&method(:listen_callback))
      end

      def create_sass_watchers
        watches = []
        Compass.configuration.sass_load_paths.map do |load_path|
          load_path = load_path.root if load_path.respond_to?(:root)
          next unless load_path.is_a? String
          next unless load_path.include? project_path
          load_path = Pathname.new(load_path).relative_path_from(Pathname.new(project_path))
          filter = File.join(load_path, SASS_FILTER)
          children = File.join(load_path, ALL_CHILDREN_SASS_FILTER)
          watches << Watcher::Watch.new(filter, &method(:sass_callback))
          watches << Watcher::Watch.new(children, &method(:sass_callback))
        end
        watches.compact
      end

      def listen_callback(modified_file, added_file, removed_file)
        #log_action(:info, ">>> Listen Callback fired", {})
        action = nil
        action ||= :modified unless modified_file.empty?
        action ||= :added unless added_file.empty?
        action ||= :removed unless removed_file.empty?

        files = modified_file + added_file + removed_file
        # run watchers
        sass_watchers.each do |watcher|
          files.each do |file|
            watcher.run_callback(project_path, file, action) if watcher.match?(file)
          end
        end
      end

      def sass_callback(base, file, action)
        #log_action(:info, ">>> Sass Callback fired #{action}", {})
        sass_modified(file) if action == :modified
        sass_added(file) if action == :added
        sass_removed(file) if action == :removed
      end

      def sass_modified(file)
        log_action(:info, "#{file} was modified", options)
        compile
      end

      def sass_added(file)
        log_action(:info, "#{file} was added", options)
        compile
      end

      def sass_removed(file)
        log_action(:info, "#{file} was removed", options)
        css_file = compiler.corresponding_css_file(File.join(project_path, file))
        compile
        if File.exists?(css_file)
          remove(css_file)
        end
      end

    end
  end
end