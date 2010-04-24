def example_haml
  markup_item = @item.children.detect{|child| child.identifier =~ /markup/}
  markup_item.reps.find { |r| r.name == :default }.content_at_snapshot(:raw)
end

def example_html
  Haml::Engine.new(example_haml).render
end

def example_sass
  markup_item = @item.children.detect{|child| child.identifier =~ /stylesheet/}
  markup_item.reps.find { |r| r.name == :default }.content_at_snapshot(:raw)
end

def example_scss
  Sass::Engine.new(example_sass).to_tree.to_scss
end

def example_css
  Sass::Engine.new(example_sass, Compass.sass_engine_options.merge(:line_comments => false)).render
end