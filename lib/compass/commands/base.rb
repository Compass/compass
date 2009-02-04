module Compass
  module Commands
    class Base

      include Actions

      attr_accessor :working_path, :options

      def initialize(working_path, options)
        self.working_path = working_path
        self.options = options
      end
      
      def perform
        raise StandardError.new("Not Implemented")
      end

      protected

      # returns the path to the templates directory and caches it
      def templates_directory
        @templates_directory ||= framework.templates_directory
      end

      def framework
        Compass::Frameworks[options[:framework]]
      end

    end
  end
end