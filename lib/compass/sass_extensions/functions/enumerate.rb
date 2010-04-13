module Compass::SassExtensions::Functions::Enumerate
  def enumerate(prefix, from, through, separator = nil)
    separator ||= Sass::Script::String.new("-", :string)
    selectors = (from.value..through.value).map{|i| "#{prefix.value}#{separator.value}#{i}"}.join(", ")
    Sass::Script::String.new(selectors)
  end
end