require 'sass/script/node'
require 'sass/script/literal'
require 'sass/script/funcall'

module Compass
  module BrowserSupport
    extend self

    ASPECTS = %w(webkit moz o ms svg pie css2)

    SIMPLE_FUNCTIONS = {
           "image" => %w(), # No browsers implement this yet.
      "cross-fade" => %w()  # No browsers implement this yet.
    }

    # Adds support for one or more aspects for the given simple function
    # Example:
    #
    #   Compass::BrowserSupport.add_support("image", "moz", "webkit")
    #   # => Adds support for moz and webkit to the image() function.
    #
    # This function can be called one or more times in a compass configuration
    # file in order to add support for new, simple browser functions without
    # waiting for a new compass release.
    def add_support(function, *aspects)
      aspects.each do |aspect|
        unless ASPECTS.include?(aspect)
          Compass::Util.compass_warn "Unknown support aspect: #{aspect}"
          next
        end
        unless supports?(function, aspect)
          SIMPLE_FUNCTIONS[function.to_s] ||= []
          SIMPLE_FUNCTIONS[function.to_s] << aspect.to_s
        end
      end
    end

    # Removes support for one or more aspects for the given simple function
    # Example:
    #
    #   Compass::BrowserSupport.remove_support("image", "o", "ms")
    #   # => Adds support for moz and webkit to the image() function.
    #
    # This function can be called one or more times in a compass configuration
    # file in order to remove support for simple functions that no longer need to
    # a prefix without waiting for a new compass release.
    def remove_support(function, *aspects)
      aspects.each do |aspect|
        unless ASPECTS.include?(aspect)
          Compass::Util.compass_warn "Unknown support aspect: #{aspect}"
          next
        end
        SIMPLE_FUNCTIONS[function.to_s].reject!{|a| a == aspect.to_s}
      end
    end

    def supports?(function, aspect)
      SIMPLE_FUNCTIONS.has_key?(function.to_s) && SIMPLE_FUNCTIONS[function.to_s].include?(aspect.to_s)
    end

    def has_aspect?(function)
      SIMPLE_FUNCTIONS.has_key?(function.to_s) && SIMPLE_FUNCTIONS[function.to_s].size > 0
    end

  end
end

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

    alias sass_to_literal to_literal

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
