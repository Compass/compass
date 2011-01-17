require 'sass/script/node'
require 'sass/script/literal'
require 'sass/script/funcall'

module Sass::Script
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
      s = "#{name}(#{args.join(", ")})"
    end

    %w(webkit moz o ms svg pie css2).each do |prefix|
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
            opts(Sass::Script::String.new("\#{prefixed_name}(\#{contents})"))
          else
            opts(Sass::Script::String.new(""))
          end
        end
      RUBY
    end

  end

  class Funcall < Node
    include HasSimpleCrossBrowserFunctionSupport

    if method_defined? :to_literal
      alias sass_to_literal to_literal 
    else
      def sass_to_literal
        Script::String.new("#{name}(#{args.join(', ')})")
      end
    end

    def to_literal(args)
      if has_aspect?(args)
        CrossBrowserFunctionCall.new(name, args)
      else
        sass_to_literal(args)
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
