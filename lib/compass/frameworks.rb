module Compass
  module Frameworks
    ALL = []
    class Framework
      attr_accessor :name
      attr_accessor :path
      def initialize(name, path)
        self.name = name
        self.path = path
      end
      def template_directory
        File.join(self.path, 'templates')
      end
      def stylesheets_directory
        File.join(self.path, 'stylesheets')
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
