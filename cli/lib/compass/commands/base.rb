module Compass
  module Commands
    class Base

      @callbacks = {}

      def self.register(command_name)
        Compass::Commands[command_name] = self
      end

      def self.register_callback(event, &block)
        @callbacks[event] ||= []
        @callbacks[event] << block
      end

      def self.run_callback(event)
        if @callbacks.has_key?(event)
          @callbacks[event].each do |callback|
            callback.call(self)
          end
        end
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
