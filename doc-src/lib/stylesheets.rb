
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

def mixin_signature(mixin)
  signature = "+#{mixin.name}"
  if mixin.args && mixin.args.any?
    signature << "("
    signature << mixin.args.map do |a|
      var = a.first
      default_value = a.last
      "#{var.inspect}#{" = " + default_value.inspect if default_value}"
    end.join(", ")
    signature << ")"
  end
  signature
end

