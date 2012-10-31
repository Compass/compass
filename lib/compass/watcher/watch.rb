module Compass
  module Watcher
    class Watch
      attr_reader :callback, :glob

      def initialize(glob, &block)
        @callback = block
        @glob     = glob
        verify!
      end

      def match?(changed_path)
        File.fnmatch(glob, changed_path)
      end

      def run_callback(base, relative, action)
        callback.call(base, relative, action)
      end

    private

      def verify!
        if Pathname.new(glob).absolute?
          raise AbsolutePathError, "Only paths relative to the project can be watched"
        end
        if callback.nil?
          raise NoCallbackError, "A Block must be supplied in order to be watched"
        end
      end

    end
  end
end