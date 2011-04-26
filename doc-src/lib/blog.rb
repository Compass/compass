POST_NAME = %r{^/posts/(\d{4})-(\d{2})-(\d{2})-(.*)/$}
require 'time'
require 'yaml'

def blog_posts_in_order
  @blog_posts_in_order ||= @items.select {|i| i.identifier =~ %r{/posts} }.sort_by {|i| i.identifier }
end

def previous_post(item = @item)
  current_index = blog_posts_in_order.index(item)
  if current_index && current_index > 0
    blog_posts_in_order[current_index - 1]
  end
end

def next_post(item = @item)
  current_index = blog_posts_in_order.index(item)
  if current_index && current_index < blog_posts_in_order.size - 1
    blog_posts_in_order[current_index + 1]
  end
end

def blog_date(item = @item)
  if item.identifier =~ POST_NAME
    Time.new($1.to_i, $2.to_i, $3.to_i)
  end
end

def authors
  @site.cached("authors") do
    YAML.load_file("#{File.dirname(__FILE__)}/../authors.yml")
  end
end

def author(author_id)
  authors[author_id]
end
