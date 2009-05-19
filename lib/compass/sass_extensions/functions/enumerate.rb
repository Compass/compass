module Compass::SassExtensions::Functions::Enumerate
  def enumerate(prefix, from, through)
    selectors = (from.value..through.value).map{|i| "#{prefix.value}-#{i}"}.join(", ")
    Sass::Script::String.new(selectors)
  end
end