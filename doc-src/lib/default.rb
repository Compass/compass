# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Capturing
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Breadcrumbs

def body_class(item)
  (item[:classnames] || []).join(" ")
end

def body_id(item)
  if item[:body_id]
    item[:body_id]
  elsif id = item.identifier.chop[1..-1]
    id.gsub(/\/|_/, "-")
  end
end

def body_attributes(item)
  {
    :id => body_id(item),
    :class => body_class(item)
  }
end

class Recycler
  attr_accessor :values
  attr_accessor :index
  def initialize *values
    self.values = values
    self.index = 0
  end
  def next
    values[index]
  ensure
    self.index += 1
    self.index = 0 if self.index >= self.values.size
  end
  def reset!
    self.index = 0
  end
end

def cycle(*args)
  yield Recycler.new *args
end

def default_path(item)
  item.reps.find{|r| r.name == :default}.path
end

def find(identifier)
  @items.find{|i| i.identifier == identifier}
end

def item_tree(item, omit_self = false)
  crumb = item[:crumb] || item[:title]
  child_html = ""
  if item.children.any?
    child_html << "<ol>"
    item.children.each do |child|
      child_html << item_tree(child)
    end
    child_html << "</ol>"
  end
  css_class = nil
  prefix = nil
  suffix = nil
  if item.identifier == @item.identifier
    css_class = %Q{class="selected"}
    prefix = "&raquo;"
    suffix = "&laquo;"
  end
  contents = unless omit_self
    %Q{<li><a href="#{default_path(item)}"#{css_class}>#{prefix}#{crumb}#{suffix}</a></li>}
  end
  %Q{#{contents}#{child_html}}
end


