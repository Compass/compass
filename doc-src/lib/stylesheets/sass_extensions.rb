require 'sass'
module Sass
  module Tree
    class Node
      private
      def tab(s, indent_level = 1)
        s.split("\n").join("\n" + "  " * indent_level)
      end
      def children_to_sass
        clean_children = children.inject([[],true]) do |m,c|
          if c.respond_to?(:doc) && !c.doc.nil?
            [m.first, c.doc]
          else
            if m.last
              [m.first + [c], true]
            else
              m
            end
          end
        end
        raise clean_children.first.inspect if clean_children.first.detect{|c| TrueClass === c}
        tab(clean_children.first.
          map{|c| c.to_sass}.join("\n"))
      end
    end
    class VariableNode < Node
      attr_accessor :name unless method_defined? :name
      attr_accessor :expr unless method_defined? :expr
      attr_accessor :guarded unless method_defined? :guarded
      attr_accessor :comment unless method_defined? :comment
    end
    class IfNode < Node
      def to_sass
        sass_str = %Q{@if #{@expr.inspect unless @expr.nil?}
                     -  #{tab children_to_sass}
                     -}.gsub(/^\s+-/,'')
        if @else
          sass_str << %Q{@else
                       -  #{tab @else.to_sass}
                       -}.gsub(/^\s+-/,'')
        end
        sass_str
      end
    end
    class DebugNode < Node
      def to_sass
        ""
      end
    end
    class MixinNode < Node
      attr_accessor :name unless method_defined? :name
      attr_accessor :args unless method_defined? :args
      def to_sass
        sass_str = "+#{name}"
        if args.any?
          sass_str << "(#{args.map{|a| a.inspect}.join(", ")})"
        end
        sass_str
      end
    end
    class VariableNode < Node
      attr_accessor :comment unless method_defined? :comment
    end
    class MixinDefNode < Node
      attr_accessor :name unless method_defined? :name
      attr_accessor :args unless method_defined? :args
      attr_accessor :comment unless method_defined? :comment
      
      def to_sass
        "#{sass_signature}\n  #{children_to_sass}\n"
      end

      def sass_signature(mode = :definition)
        prefix = case mode
        when :definition
          "="
        when :include
          "+"
        end
        "#{prefix}#{name}#{arglist_to_sass}"
      end

      private
      def arglist_to_sass
        if args.any?
          "(#{args.map{|a| arg_to_sass(a)}.join(", ")})"
        else
          ""
        end
      end
      def arg_to_sass(arg)
        name, default_value = arg
        sass_str = "#{name.inspect}"
        if default_value
          sass_str << " = "
          sass_str << default_value.inspect
        end
        sass_str
      end
    end
    class ImportNode < RootNode
      attr_accessor :imported_filename unless method_defined? :imported_filename
    end
    class CommentNode < Node
      def docstring
        ([value] + lines).join("\n")
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
    class Bool < Literal; alias to_sass to_s; end
    class Color < Literal; alias to_sass to_s; end
    class Funcall < Node
      def to_sass
        "#{name}(#{args.map {|a| a.to_sass}.join(', ')})"
      end
    end
    class Number < Literal
      def to_sass
        value = if self.value.is_a?(Float) && (self.value.infinite? || self.value.nan?)
          self.value
        elsif int?
          self.value.to_i
        else
          (self.value * PRECISION).round / PRECISION
        end
        value = "#{value}#{numerator_units.first}"
        if (nu = numerator_units[1..-1]).any?
          value << " * " + nu.map{|u| "1#{u}"}.join(" * ")
        end
        if (du = denominator_units).any?
          value << " / " + du.map{|u| "1#{u}"}.join(" / ")
        end
        value
      end
    end
    class Operation < Node
      unless defined? OPERATORS_TO_SASS
        OPERATORS_TO_SASS = {
          :plus => '+',
          :minus => '-',
          :div => '/',
          :mult => '*',
          :comma => ',',
          :concat => ' ',
          :neq => '!=',
          :eq => '==',
          :or => 'or',
          :and => 'and'
        }
      end
      def to_sass
        "#{operand_to_sass(@operand1)} #{OPERATORS_TO_SASS[@operator]} #{operand_to_sass(@operand2)}"
      end
      def operand_to_sass(operand)
        if operand.is_a? Operation
          "(#{operand.to_sass})"
        else
          operand.to_sass
        end
      end
    end
    class String < Literal
      def to_sass
        value.inspect
      end
    end
    class UnaryOperation < Node
      def to_sass
        "#{@operator}#{@operand}"
      end
    end
    class Variable < Node; alias to_sass inspect; end
  end
end