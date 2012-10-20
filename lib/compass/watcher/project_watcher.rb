require 'listen'
require 'forwardable'
module Compass
  module Watcher
    class ProjectWatcher
      include Compass::Actions
      SASS_FILTER = '*.s[ac]ss'
      ALL_CHILDREN_SASS_FILTER = File.join('**', SASS_FILTER)
      POLLING_MESSAGE = 'Some message about polling'

      attr_reader :project_path, :watcher_compiler, :listener, :poll, :css_dir, :sass_watchers

      extend Forwardable
  
      def_delegators :@watcher_compiler, :compiler, :compiler

      def initialize(project_path, watches=[], options={}, poll=false)
        @poll             = poll
        @project_path     = project_path
        @css_dir          = Compass.configuration.css_dir
        @sass_watchers    = create_sass_watchers + watches
        @watcher_compiler = Compass::Watcher::Compiler.new(project_path, options)
        setup_listener
      end

      def watch!
        listener.start
      end

      def unwatch!
        listener.stop
      end


    private #============================================================================>

      def setup_listener
        @listener = Listen.to(@project_path)
        if poll
          @listener = listener.force_polling(true)
        end
        # not sure if we need to do this
        # @listener = listener.filter(SASS_FILE_FILTER)
        @listener = listener.polling_fallback_message(POLLING_MESSAGE)
        @listener = listener.polling_fallback_message(true)
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
        action = nil
        action = :modified if modified_file        
        action = :added if added_file
        action = :removed if removed_file

        file = modified_file || added_file || removed_file
        # run watchers
        sass_watchers.each do |watcher|
          watcher.run_callback(project_path, file, action) if watcher.match?(file)
        end
      end

      def sass_callback(base, file, action)
        sass_modified(file) if action == :modified
        sass_added(file) if action == :added
        sass_removed(file) if action == :removed
      end

      def sass_modified(file)
        watcher_compiler.compile
      end

      def sass_added(file)
        watcher_compiler.compile
      end

      def sass_removed(file)
        remove_obsolete_css
        watcher_compiler.compile
      end

      def remove_obsolete_css
        sass_files = compiler.sass_files
        deleted_sass_files = (last_sass_files || []) - sass_files
        deleted_sass_files.each do |deleted_sass_file|
          css_file = compiler.corresponding_css_file(deleted_sass_file)
          remove(css_file) if File.exists?(css_file)
        end
      end

    end
  end
end