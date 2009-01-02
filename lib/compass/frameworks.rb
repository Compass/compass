module Compass
  module Frameworks
    ALL = []
    class Framework
      attr_accessor :name
      attr_accessor :templates_directory, :stylesheets_directory
      def initialize(name, *arguments)
        options = arguments.last.is_a?(Hash) ? arguments.pop : {}
        path = options[:path] || arguments.shift
        @name = name
        @templates_directory = options[:templates_directory] || File.join(path, 'templates')
        @stylesheets_directory = options[:stylesheets_directory] || File.join(self.path, 'stylesheets')
      end
    end
    def register(name, path)
      ALL << Framework.new(name, path)
    end
    module_function :register
  end
end

require File.join(File.dirname(__FILE__), 'frameworks', 'compass')
require File.join(File.dirname(__FILE__), 'frameworks', 'blueprint')
require File.join(File.dirname(__FILE__), 'frameworks', 'yui')
