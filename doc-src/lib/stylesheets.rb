require 'rdiscount'

def stylesheets_dir(framework)
  Compass::Frameworks[framework].stylesheets_directory
end

def tree_key(item)
  "tree/"+[item[:framework], item[:stylesheet]].join("/")
end

def tree(item)
  @site.cached(tree_key(item)) do
    file = File.join(stylesheets_dir(item[:framework]), item[:stylesheet])
    contents = File.read(file)
    syntax = item[:stylesheet] =~ /\.scss$/ ? :scss : :sass
    Sass::Engine.new(contents, :syntax => syntax).send :to_tree
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
  imports.sort
end

def reference_item(options)
  stylesheet = options[:stylesheet]
  path = stylesheet_path(stylesheet)
  if path
    @site.cached("reference/item/#{path}") do
      @items.detect do |i|
        if i.identifier =~ /^\/reference/ && i[:stylesheet]
          i[:stylesheet] == path
        end
      end
    end
  end
end

def departialize(path)
  path.gsub(%r{(\b|/)_}){|m| m.size > 1 ? "/" : ""}
end

def reference_path(options)
  if item = reference_item(options)
    rep = item.reps.find { |r| r.name == :default }
    rep.path
  end
end

def import_paths
  paths = []
  if @item[:stylesheet]
    paths << [File.join(Compass::Frameworks[@item[:framework]].stylesheets_directory,
                        File.dirname(@item[:stylesheet])),
              @item[:stylesheet]["/"] ? File.dirname(@item[:stylesheet]) : ""]
  end

  paths += Compass::Frameworks::ALL.inject([]) {|m, f| m << f.stylesheets_directory}.map!{|p|[p, '']}
  paths
end

def stylesheet_path(ss)
  possible_names = possible_filenames_for_stylesheet(ss)
  import_paths.each do |import_path|
    possible_names.each do |filename|
      full_path = File.join(import_path.first, filename)
      if File.exist?(full_path)
        return "#{import_path.last}#{"/" if import_path.last && import_path.last.length > 0}#{filename}"
      end
    end
  end
  nil
end

def possible_filenames_for_stylesheet(ss)
  ext = File.extname(ss)
  path = File.dirname(ss)
  path = path == "." ? "" : "#{path}/"
  base = File.basename(ss)[0..-(ext.size+1)]
  extensions = if ext.size > 0
    [ext]
  else
    [".scss", ".sass"]
  end
  basenames = ["_#{base}", base]
  filenames = []
  basenames.each do |basename|
    extensions.each do |extension|
      filenames << "#{path}#{basename}#{extension}"
    end
  end
  filenames
end

def mixins(item)
  sass_tree = tree(item)
  mixins = []
  comment = nil
  sass_tree.children.each do |child|
    if child.is_a?(Sass::Tree::MixinDefNode)
      child.comment = comment && Sass::Tree::CommentNode.clean(comment)
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
  mixins.reject{|m| m.comment =~ /@private/}
end

def functions(item)
  sass_tree = tree(item)
  functions = []
  comment = nil
  sass_tree.children.each do |child|
    if child.is_a?(Sass::Tree::FunctionNode)
      child.comment = comment && Sass::Tree::CommentNode.clean(comment)
      comment = nil
      functions << child
    elsif child.is_a?(Sass::Tree::CommentNode)
      comment ||= ""
      comment << "\n" unless comment.empty?
      comment << child.docstring
    else
      comment = nil
    end
  end
  functions.reject{|m| m.comment =~ /@private/}
end

def constants(item)
  sass_tree = tree(item)
  constants = []
  comment = nil
  sass_tree.children.each do |child|
    if child.is_a?(Sass::Tree::VariableNode)
      child.comment = comment && Sass::Tree::CommentNode.clean(comment)
      comment = nil
      child.name.tr!("_",'-')
      constants << child
    elsif child.is_a?(Sass::Tree::CommentNode)
      comment ||= ""
      comment << "\n" unless comment.empty?
      comment << child.docstring
    else
      comment = nil
    end
  end
  constants.reject{|c| c.comment =~ /@private/}
end

def all_constants
  @items.inject([]) do |variables, item|
    next variables unless item.identifier =~ %r{/reference}
    next variables unless item[:stylesheet]
    variables += constants(item).map{|v| [item, v] }
  end
end

def all_mixins
  @items.inject([]) do |all_mixins, item|
    next all_mixins unless item.identifier =~ %r{/reference}
    next all_mixins unless item[:stylesheet]
    all_mixins += mixins(item).map{|m| [item, m] }
  end
end

def all_functions
  @items.inject([]) do |all_functions, item|
    next all_functions unless item.identifier =~ %r{/reference}
    next all_functions unless item[:stylesheet]
    all_functions += functions(item).map{|f| [item, f] }
  end
end

# Sass Only Functions from 3.1.10 (Brainy Betty)
# Not as elegant, but does the trick.
def sass_functions
  [:rgb, :rgba, :hsl, :hsla, :red, :green, :blue, :hue, :saturation, :lightness, :alpha, :opacity, :opacify, :fade_in, :transparentize, :fade_out, :lighten, :darken, :saturate, :desaturate, :adjust_hue, :adjust_color, :scale_color, :change_color, :mix, :grayscale, :complement, :invert, :unquote, :quote, :type_of, :unit, :unitless, :comparable, :percentage, :round, :ceil, :floor, :abs, :length, :nth, :join, :append, :zip, :index, :if]
end

def example_items
  @site.cached("examples") do
    @items.select do |i|
      i.identifier =~ /^\/examples/ && i[:example]
    end
  end
end

def item_for_function_name(function_name)
  @items.detect do |item|
    (item.identifier =~ %r{helpers}) && item[:documented_functions] && item[:documented_functions].include?(function_name)
  end
end

def examples_for_item(item)
  @site.cached("examples/#{item.identifier}") do
    example_items.select do |i|
      i[:framework] == item[:framework] &&
      i[:stylesheet] == item[:stylesheet]
    end
  end
end

def examples(item, mixin = nil)
  examples = examples_for_item(item)
  if mixin
    examples = examples.select {|i| i[:mixin] == mixin.name }
  else
    examples = examples.reject {|i| i[:mixin] }
  end
  examples.map{|i| i.reps.find{|r| r.name == :default}}
end

def format_doc(docstring)
  if docstring
    RDiscount.new(docstring).to_html
  end
end

