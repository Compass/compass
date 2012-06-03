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

    # compile a Sass string in the context of a project in the current working directory.
    def compile_for_project(contents, options = {})
      Compass.add_project_configuration
      options[:syntax] ||= :scss
      Sass::Engine.new(contents, Compass.configuration.to_sass_engine_options.merge(options)).render
    end

    def assert_correct(before, after)
      if before == after
        assert(true)
      else
        assert false, diff_as_string(before.inspect, after.inspect)
      end
    end
    
    module ClassMethods

      def let(method, &block)
        define_method method, &block
      end

      def it(name, &block)
        test(name, &block)
      end

      def test(name, &block)
        define_method "test_#{underscore(name)}".to_sym, &block
      end

      def setup(&block)
        define_method :setup do
          yield
        end
      end

      def after(&block)
        define_method :teardown do
          yield
        end
      end

      private 

      def underscore(string)
        string.gsub(' ', '_')
      end

    end
  end
end
