module Compass
  module Watcher
    class BasicWatch
      attr_reader :callback

      def initialize(&block)
        unless block
          raise NoCallbackError, "A Block must be supplied in order to be watched"
        end
        @callback = block
      end

      def run_callback(base, relative, action)
        callback.call(base, relative, action)
      end

      def run_once_per_changeset?
        false
      end

      def match?(path)
        Sass::Util.abstract(self)
      end
    end

    class Watch < BasicWatch
      attr_reader :glob

      def initialize(glob, &block)
        super(&block)
        unless glob
          raise WatcherException, "A glob must be supplied in order to be watched"
        end
        @glob = glob
      end

      def match?(changed_path)
        File.fnmatch(glob, changed_path)
      end
    end

    class SassWatch < BasicWatch
      def match?(path)
        path =~ /s[ac]ss$/
      end
      def run_once_per_changeset?
        true
      end
    end
  end
end
