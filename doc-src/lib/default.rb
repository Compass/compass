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
  if id = item.identifier.chop[1..-1]
    id.gsub(/\/|_/, "-")
  else
    nil
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
