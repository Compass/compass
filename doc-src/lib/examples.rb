def example_html
  markup_item = @item.children.detect{|child| child.identifier =~ /markup/}
  haml = markup_item.reps.find { |r| r.name == :default }.content_at_snapshot(:raw)
  Haml::Engine.new(haml).render
end

def example_sass
  markup_item = @item.children.detect{|child| child.identifier =~ /stylesheet/}
  markup_item.reps.find { |r| r.name == :default }.content_at_snapshot(:raw)
end

def example_css
  Sass::Engine.new(example_sass, Compass.sass_engine_options.merge(:line_comments => false)).render
end