module Compass
  module Commands
    class ListFrameworks < ProjectBase
      attr_accessor :options
      register :frameworks
      def initialize(working_path, options)
        super
      end
  
      def execute
        Compass::Frameworks::ALL.each do |framework|
          puts framework.name unless framework.name =~ /^_/
        end
      end
      class << self
        def description(command)
          "List the available frameworks"
        end
      end
    end
  end
end