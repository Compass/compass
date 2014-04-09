module Compass
  module Commands
    module DefaultOptionsParser
      def set_options(opts)
        opts.on("--trace") do
          self.options[:trace] = true
        end
        opts.on("-?", "-h", "--help") do
          self.options[:command] = Proc.new do
            Help.new(working_path, options.merge(:help_command => "help"))
          end
        end
        opts.on("-q", "--quiet") do
          self.options[:quiet] = true
        end
        opts.on("-v", "--version") do
          self.options[:command] = Proc.new do
            PrintVersion.new(working_path, options)
          end
        end
        super
      end
    end
    class Default < Base
      
      class << self
        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(DefaultOptionsParser)
        end
        # def usage
        #   $stderr.puts caller.join("\n")
        #   "XXX"
        # end
        def parse!(arguments)
          parser = option_parser(arguments)
          parser.parse!
          parser.options[:command] ||= Proc.new do
            Help.new(working_path, options.merge(:help_command => "help"))
          end
          parser.options
        end
      end

      def execute
        instance_eval(&options[:command]).execute
      end
    end
  end
end
