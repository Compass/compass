module Compass::SassExtensions::Functions::Lists
  def value_of(int, list)
    if list.is_a?(Sass::Script::String)
      values = list.value.split(/\s+/)
      Sass::Script::String.new(values[int] || values.first)
    elsif defined?(Sass::Script::List) && list.is_a?(Sass::Script::List)
      list.value[int] || list.value.first
    else
      list
    end
  end
  
  def first_value_of(list)
    self.value_of(0, list)
  end
  
  def second_value_of(list)
    self.value_of(1, list)
  end
  
  def third_value_of(list)
    self.value_of(2, list)
  end
  
  def fourth_value_of(list)
    self.value_of(3, list)
  end
end
