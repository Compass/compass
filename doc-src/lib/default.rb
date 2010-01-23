# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Capturing
include Nanoc3::Helpers::Rendering

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