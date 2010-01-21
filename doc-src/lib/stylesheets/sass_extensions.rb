module Sass
  module Tree
    class VariableNode < Node
      attr_accessor :name unless method_defined? :name
    end
    class MixinDefNode < Node
      attr_accessor :name unless method_defined? :name
      attr_accessor :args unless method_defined? :args
    end
    class ImportNode < Node
      attr_accessor :imported_filename unless method_defined? :imported_filename
    end
  end
end