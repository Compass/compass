module Compass
  module Commands
    class Imports < ProjectBase
      attr_accessor :options
      register :imports
      def initialize(working_path, options)
        super
      end
  
      def execute
        print ::Compass::Frameworks::ALL.map{|f|
                  "-I #{f.stylesheets_directory}"
                }.join(' ')
      end
      class << self
        def description(command)
          "Emit an imports suitable for passing to the sass command-line."
        end
        def usage
          "Usage: compass imports\n\n" +
          "Prints out the imports known to compass.\n"+
          "Useful for passing imports to the sass command line:\n" +
          "  sass -r compass `compass imports` a_file_using_compass.sass"
        end
        def parse!(arguments)
          if arguments.join("").strip.size > 0
            raise OptionParser::ParseError, "This command takes no options or arguments."
          else
            {}
          end
        end
      end
    end
  end
end
