module Compass
  module ImportOnce
    # Any importer object that is extended with this module will get the import once behavior.
    module Importer
      DUMMY_FILENAME = "import_once_dummy_engine".freeze

      def find_relative(uri, base, options)
        uri, force_import = handle_force_import(uri)
        maybe_replace_with_dummy_engine(super(uri, base, options), options, force_import)
      end

      def find(uri, options)
        uri, force_import = handle_force_import(uri)
        maybe_replace_with_dummy_engine(super(uri, options), options, force_import)
      end

      # ensure that all dummy engines share the same sass cache entry.
      def key(uri, options)
        if uri == DUMMY_FILENAME
          ["(import-once)", "dummy_engine"]
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

      def import_tracker_key(engine, options)
        key(engine.options[:filename], options).join("|").freeze
      end

      def dummy_engine(engine, options)
        new_options = engine.options.merge(:filename => DUMMY_FILENAME)
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
