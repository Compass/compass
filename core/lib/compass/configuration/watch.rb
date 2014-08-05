module Compass
  module Configuration
    class Watch
      attr_reader :callback
      attr_reader :glob
      attr_reader :full_glob

      def initialize(glob, &block)
        unless block
          raise ArgumentError, "A Block must be supplied in order to be watched"
        end
        @callback = block
        unless glob
          raise ArgumentErrorn, "A glob must be supplied in order to be watched"
        end
        @glob = glob

        if Pathname.new(glob).absolute?
          @full_glob = glob
        else
          @full_glob = File.join(Compass.configuration.project_path, glob)
        end
      end

      def run_callback(base, relative, action)
        callback.call(base, relative, action)
      end

      def run_once_per_changeset?
        false
      end

      def match?(changed_path)
        File.fnmatch(full_glob, changed_path, File::FNM_PATHNAME)
      end
    end
  end
end
