module Compass::SassExtensions::Functions::Lists
  def first_value_of(list)
    if list.is_a?(Sass::Script::String)
      Sass::Script::String.new(list.value.split(/\s+/).first)
    elsif defined?(Sass::Script::List) && list.is_a?(Sass::Script::List)
      list.value.first
    else
      list
    end
  end
end
