module Compass
  module Commands
    class Base
      def self.register(command_name)
        Compass::Commands[command_name] = self
      end

      include Actions

      attr_accessor :working_path, :options

      def initialize(working_path, options)
        self.working_path = working_path.to_s
        self.options = options
      end
      
      def execute
        perform
      end

      def perform
        raise StandardError.new("Not Implemented")
      end

      def successful?
        !@failed
      end

      def failed!
        @failed = true
      end

      protected

      def framework
        unless Compass::Frameworks[options[:framework]]
          raise Compass::Error.new("No such framework: #{options[:framework].inspect}")
        end
        Compass::Frameworks[options[:framework]]
      end

    end
  end
end
