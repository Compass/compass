module Compass
  module TestCaseHelper
    def absolutize(path)
      if Compass::Util.blank?(path)
        File.expand_path('../../', __FILE__)
      elsif path[0] == ?/
        File.join(File.expand_path('../', __FILE__), path)
      else
        File.join(File.expand_path('../../', __FILE__), path)
      end
    end
    module ClassMethods

      def it(name, &block)
        test(name, &block)
      end

      def test(name, &block)
        define_method "test_#{underscore(name)}".to_sym, &block
      end

      def setup(&block)
        define_method :setup do
          yield
          super
        end
      end

      def after(&block)
        define_method :teardown do
          yield
          super
        end
      end

      private 

      def underscore(string)
        string.gsub(' ', '_')
      end

    end
  end
end
