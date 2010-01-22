module Sass
  module Tree
    class VariableNode < Node
      attr_accessor :name unless method_defined? :name
    end
    class MixinDefNode < Node
      attr_accessor :name unless method_defined? :name
      attr_accessor :args unless method_defined? :args
      attr_accessor :comment unless method_defined? :comment
    end
    class ImportNode < RootNode
      attr_accessor :imported_filename unless method_defined? :imported_filename
    end
    class CommentNode < Node
      def docstring
        ([value] + lines).join("\n")
      end
    end
  end
end