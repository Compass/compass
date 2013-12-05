module Compass
  # although this is part of the compass suite of gems, it doesn't depend on compass,
  # so any sass-based project can use to to get import-once behavior for all of their
  # importers.
  module ImportOnce
    # All sass engines will be extended with this module to manage the lifecycle
    # around each
    module Engine
      def to_css
        with_import_scope(options[:css_filename]) do
          super
        end
      end

      def render
        with_import_scope(options[:css_filename]) do
          super
        end
      end

      def render_with_sourcemap(sourcemap_uri)
        with_import_scope(options[:css_filename]) do
          super
        end
      end

      def with_import_scope(css_filename)
        Compass::ImportOnce.import_tracker[css_filename] = Set.new
        yield
      ensure
        Compass::ImportOnce.import_tracker.delete(css_filename)
      end
    end
  end
end

