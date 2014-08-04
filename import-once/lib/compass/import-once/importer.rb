module Compass
  module ImportOnce
    # Any importer object that is extended with this module will get the import once behavior.
    module Importer
      def find_relative(uri, base, options, *args)
        uri, force_import = handle_force_import(uri)
        maybe_replace_with_dummy_engine(super(uri, base, options, *args), options, force_import)
      end

      def find(uri, options, *args)
        uri, force_import = handle_force_import(uri)
        maybe_replace_with_dummy_engine(super(uri, options, *args), options, force_import)
      end

      def key(uri, options, *args)
        if uri =~ /^\(NOT IMPORTED\) (.*)$/
          ["(import-once)", $1]
        else
          super
        end
      end

      def mtime(uri, options, *args)
        if uri =~ /^\(NOT IMPORTED\) (.*)$/
          File.mtime($1) if File.exist?($1)
        else
          super
        end
      end

      protected

      # any uri that ends with an exclamation mark will be forced to import
      def handle_force_import(uri)
        if uri.end_with?("!")
          [uri[0...-1], true]
        else
          [uri, false]
        end
      end

      def maybe_replace_with_dummy_engine(engine, options, force_import)
        if engine && !force_import && imported?(engine, options)
          engine = dummy_engine(engine, options)
        elsif engine
          imported!(engine, options)
        end
        engine
      end

      def tracker(options)
         Compass::ImportOnce.import_tracker[options[:css_filename]] ||= Set.new
      end

      # Giant hack to support sass-globbing.
      # Need to find a better fix.
      def normalize_filesystem_importers(key)
        key.map do |part|
          part.sub(/Glob:/, 'Sass::Importers::Filesystem:')
        end
      end

      def import_tracker_key(engine, options)
        normalize_filesystem_importers(key(engine.options[:filename], options)).join("|").freeze
      end

      def dummy_engine(engine, options)
        new_options = engine.options.merge(:filename => "(NOT IMPORTED) #{engine.options[:filename]}" )
        Sass::Engine.new("", new_options)
      end

      def imported?(engine, options)
        tracker(options).include?(import_tracker_key(engine, options))
      end

      def imported!(engine, options)
        tracker(options) << import_tracker_key(engine, options)
      end
    end
  end
end
