require 'sass/script'

module Sass::Script
  module Value
    class Base
      NO_CHILDREN = []
      def children
        NO_CHILDREN
      end

      def opts(value)
        value.options = options
        value
      end
    end

    class List < Base
      def children
        value
      end
    end

    class ArgList < List
      def children
        super + @keywords.values
      end
    end

    class Map < Base
      def children
        to_a
      end
    end
  end
  module HasSimpleCrossBrowserFunctionSupport
    def supports?(aspect)
      return true if Compass::BrowserSupport.supports?(name, aspect)
      children.any? {|child| child.respond_to?(:supports?) && child.supports?(aspect) }
    end

    def has_aspect?(children = nil)
      children ||= self.children
      return true if Compass::BrowserSupport.has_aspect?(name)
      children.any? {|child| child.respond_to?(:has_aspect?) && child.has_aspect? }
    end
  end

  class CrossBrowserFunctionCall < Literal

    attr_accessor :name, :args

    include HasSimpleCrossBrowserFunctionSupport
    include Sass::Script::Value::Helpers

    def initialize(name, args)
      self.name = name
      self.args = args
    end

    def children
      args
    end

    def inspect
      to_s
    end

    def to_s(options = self.options)
      "#{name}(#{args.map{|a| a.to_s(options)}.join(", ")})"
    end

    %w(webkit moz o ms svg css2 owg).each do |prefix|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def to_#{prefix}(options = self.options)
          prefixed_args = args.map do |arg|
            arg.respond_to?(:to_#{prefix}) ? arg.to_#{prefix}(options) : arg
          end
          prefixed_name = if Compass::BrowserSupport.supports?(name, "#{prefix}")
            "-#{prefix}-\#{name}"
          else
            name
          end
          contents = prefixed_args.join(', ')
          if contents.size > 0
            opts(identifier("\#{prefixed_name}(\#{contents})"))
          else
            opts(null)
          end
        end
      RUBY
    end

  end

  class Funcall < Node
    include HasSimpleCrossBrowserFunctionSupport

    alias sass_to_value to_value 

    def to_value(args)
      if has_aspect?(args)
        CrossBrowserFunctionCall.new(name, args)
      else
        sass_to_value(args)
      end
    end
  end

  class List < Literal
    def supports?(aspect)
      children.any? {|child| child.respond_to?(:supports?) && child.supports?(aspect) }
    end

    def has_aspect?
      children.any? {|child| child.respond_to?(:has_aspect?) && child.has_aspect? }
    end
  end

end
