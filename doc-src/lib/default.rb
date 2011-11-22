# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require 'erb'
require 'active_support/inflector'
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Capturing
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Breadcrumbs
include Nanoc3::Helpers::XMLSitemap

def body_class(item)
  classes = [""]
  classes += item[:classnames] || []
  classes << "demo" if item.identifier =~ /^\/examples/
  classes.join(" ")
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

module Enumerable
  def sorted_and_grouped_by_name
    sort_by{|i| yield(i)}.group_by{|i| yield(i).sub(/^[^\w]/,"")[0..0].upcase}
  end
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

def get_var(instance_var)
  instance_variable_defined?("@#{instance_var}") ? instance_variable_get("@#{instance_var}") : yield
end

def sidebar_item(item)
  if item.nil?
    nil
  elsif item[:sidebar]
    item
  else
    sidebar_item(item.parent)
  end
end

def sidebar_stylesheet(item)
  i = sidebar_item(item)
  i[:stylesheet] if i
end
  

def item_tree(item, options = {})
  crumb = item[:crumb] || item[:title]
  options[:heading_level] ||= 1 if options.fetch(:headings, true)
  child_html = ""
  if options.fetch(:depth,1) > 0
    child_opts = options.dup
    child_opts[:depth] -= 1 if child_opts.has_key?(:depth)
    child_opts[:heading_depth] -= 1 if child_opts.has_key?(:heading_depth)
    child_opts[:heading_level] += 1 if child_opts[:heading_level]
    child_opts.delete(:omit_self)
    item.children.sort_by{|c| c[:crumb] || c[:title]}.each do |child|
      next if child[:navigable] == false
      child_html << item_tree(child, child_opts)
    end
  else
    options.delete(:heading_level)
  end
  child_html = render("partials/sidebar/container", :contents => child_html) unless child_html.size == 0
  css_class = nil
  contents = unless options[:omit_self]
    item_opts = {
      :current_item => item,
      :selected => !!@item.identifier[item.identifier],
      :crumb => item[:crumb] || item[:title]
    }
    if options[:heading_level] && (options.fetch(:heading_depth, 1) > 0)
      render("partials/sidebar/heading",
        item_opts.merge(:heading => "h#{options[:heading_level]}")
      )
    else
      render("partials/sidebar/item", item_opts)
    end
  end
  %Q{#{contents}#{child_html}}
end

def tutorial_item(path)
  path = "" if path == :root
  @items.detect do |i|
    i.identifier == "/help/tutorials/#{path}"
  end
end

def compass_version
  v = Compass.version
  "#{v[:major]}.#{v[:minor]}#{"."+v[:state] if v[:state]}.#{v[:build] || v[:patch]}"
end

def long_compass_version
  require 'compass/commands'
  Compass::Commands::PrintVersion.long_output_string
end


def sprite_tutorial_links(index=false)
  string = <<-ERB
<% unless index %>
  * [Sprite Tutorial Index](/help/tutorials/spriting/)
<% end %>
<% Dir["./content/help/tutorials/spriting/**/*.markdown"].sort.each do |file| %>
  * [<%= File.basename(file, '.markdown').gsub('-', ' ').titleize %>](/help/tutorials/spriting/<%= File.basename(file, '.markdown') %>)
<% end %>
  ERB
  ::ERB.new(string).result(binding)
end
