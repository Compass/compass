require 'rdiscount'

def stylesheets_dir(framework)
  Compass::Frameworks[framework].stylesheets_directory
end

def stylesheet_key(item)
  [item[:framework], item[:stylesheet]].join("/")
end

def tree(item)
  @stylesheets ||= {}
  @stylesheets[stylesheet_key(item)] ||= begin
    file = File.join(stylesheets_dir(item[:framework]), item[:stylesheet])
    contents = File.read(file)
    Sass::Engine.new(contents).send :to_tree
  end
end

def imports(item)
  sass_tree = tree(item)
  imports = []
  sass_tree.children.each do |child|
    if child.is_a?(Sass::Tree::ImportNode)
      imports << child.imported_filename
    end
  end
  imports
end

def mixins(item)
  sass_tree = tree(item)
  mixins = []
  comment = nil
  sass_tree.children.each do |child|
    if child.is_a?(Sass::Tree::MixinDefNode)
      child.comment = comment
      comment = nil
      mixins << child
    elsif child.is_a?(Sass::Tree::CommentNode)
      comment ||= ""
      comment << "\n" unless comment.empty?
      comment << child.docstring
    else
      comment = nil
    end
  end
  mixins
end

def constants(item)
  sass_tree = tree(item)
  constants = []
  comment = nil
  sass_tree.children.each do |child|
    if child.is_a?(Sass::Tree::VariableNode)
      child.comment = comment
      comment = nil
      constants << child
    elsif child.is_a?(Sass::Tree::CommentNode)
      comment ||= ""
      comment << "\n" unless comment.empty?
      comment << child.docstring
    else
      comment = nil
    end
  end
  constants
end

def mixin_signature(mixin)
  mixin.sass_signature(:include)
end

def mixin_source_dialog(mixin, &block)
  vars = {
    :html => {
      :id => "mixin-source-#{mixin.name}",
      :class => "mixin",
      :title => "Source for +#{mixin.name}"
    }
  }
  render 'dialog', vars, &block
end

def format_doc(docstring)
  RDiscount.new(docstring).to_html
end

