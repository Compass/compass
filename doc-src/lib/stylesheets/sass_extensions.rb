require 'sass'
module Sass
  module Tree
    class VariableNode < Node
      attr_accessor :name unless method_defined? :name
      attr_accessor :expr unless method_defined? :expr
      attr_accessor :guarded unless method_defined? :guarded
      attr_accessor :comment unless method_defined? :comment
    end
    class DebugNode < Node
      def to_sass
        ""
      end
    end
    class MixinNode < Node
      attr_accessor :name unless method_defined? :name
      attr_accessor :args unless method_defined? :args
    end
    class VariableNode < Node
      attr_accessor :comment unless method_defined? :comment
    end
    module HasSignature
      def sass_signature(format = :text)
        "#{name}#{arglist_to_sass(format)}"
      end

      private
      def arglist_to_sass(format = :text)
        if args && args.any?
          "(#{args.map{|a| arg_to_sass(a, format)}.join(", ")})"
        else
          ""
        end
      end
      def arg_to_sass(arg, format = :text)
        name, default_value = arg
        sass_str = ""
        if format == :html
          ddv = %Q{ data-default-value="#{h(default_value.to_sass)}"} if default_value
          sass_str = %Q{<span class="arg"#{ddv}>#{name.to_sass}</span>}
        else
          sass_str = "#{name.to_sass}"
          if default_value
            sass_str << " = "
            sass_str << default_value.to_sass
          end
        end
        sass_str
      end
    end
    class MixinDefNode < Node
      attr_accessor :name unless method_defined? :name
      attr_accessor :args unless method_defined? :args
      attr_accessor :comment unless method_defined? :comment
      unless included_modules.include?(HasSignature)
        include HasSignature
        alias sass_signature_without_prefix sass_signature
        def sass_signature(mode = :definition, format = :text)
          prefix = case mode
          when :definition
            "="
          when :include
            "+"
          end
          "#{prefix}#{sass_signature_without_prefix(format)}"
        end
      end
    end
    class FunctionNode < Node
      attr_accessor :name unless method_defined? :name
      attr_accessor :args unless method_defined? :args
      attr_accessor :comment unless method_defined? :comment
      include HasSignature unless included_modules.include?(HasSignature)
    end
    class ImportNode < RootNode
      attr_accessor :imported_filename unless method_defined? :imported_filename
    end
    class CommentNode < Node
      unless defined?(PRE_COMMENT)
        PRE_COMMENT = %r{(^ */*\**(\s*\|)?( |$))}
      end
      unless defined?(POST_COMMENT)
        POST_COMMENT = %r{ *\*/$}
      end
      def self.clean(docstring)
        docstring.gsub(/@doc off(.*?)@doc on/m, '')
      end
      def docstring
        v = value
        v = v.join("\n") if v.respond_to?(:join)
        v.gsub(PRE_COMMENT, '').gsub(POST_COMMENT, '')
      end
      def doc
        if value == "@doc off"
          false
        elsif value == "@doc on"
          true
        end
      end
    end
  end
  module Script
    class Color < Literal
      def to_sass(options = {})
        if options[:format] == :html
          %Q{<span class="color">#{to_s}</span>}
        else
          to_s
        end
      end
    end
  end
end
