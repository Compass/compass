module Compass
  module Installers
    class TemplateContext
      def self.ctx(*arguments)
        new(*arguments).get_binding
      end
      def initialize(locals = {})
        @locals = locals
      end
      def get_binding
        @locals.each do |k, v|
          eval("#{k} = v")
        end
        binding
      end
      def config
        Compass.configuration
      end
      alias configuration config
    end
  end
end