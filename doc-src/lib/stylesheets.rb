
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
