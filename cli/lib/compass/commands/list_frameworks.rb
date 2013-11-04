module Compass
  module Commands
    class ListFrameworks < ProjectBase
      attr_accessor :options
      register :frameworks
      def initialize(working_path, options)
        super
      end
  
      def execute
        if options[:quiet]
          Compass::Frameworks::ALL.each do |framework|
            puts framework.name unless framework.name =~ /^_/
          end
        else
          puts "Available Frameworks & Patterns:\n\n"
          puts Compass::Frameworks.pretty_print
        end
      end
      class << self
        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(Compass::Exec::GlobalOptionsParser)
        end
        def usage
          option_parser([]).to_s
        end
        def description(command)
          "List the available frameworks"
        end
        def parse!(arguments)
          parser = option_parser(arguments)
          parser.parse!
          parser.options
        end
      end
    end
  end
end