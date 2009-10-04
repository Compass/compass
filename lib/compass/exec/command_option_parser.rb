module Compass::Exec
  class CommandOptionParser
    attr_accessor :options, :arguments
    def initialize(arguments)
      self.arguments = arguments
      self.options = {}
    end
    def parse!
      opts = OptionParser.new(&method(:set_options))
      opts.parse!(arguments)
    end
    def set_options(opts)

    end
  end
end
