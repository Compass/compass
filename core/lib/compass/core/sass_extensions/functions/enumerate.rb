module Compass::Core::SassExtensions::Functions::Enumerate
  def enumerate(prefix, from, through, separator = nil)
    separator ||= identifier("-")
    selectors = (from.value..through.value).map{|i| "#{prefix.value}#{separator.value}#{i}"}.join(", ")
    identifier(selectors)
  end
end
