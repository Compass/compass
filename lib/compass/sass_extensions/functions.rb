module Compass::SassExtensions::Functions
end

['nest', 'enumerate', 'image_url'].each do |func|
  require File.join(File.dirname(__FILE__), 'functions', func)
end

module Sass::Script::Functions
  include Compass::SassExtensions::Functions::Nest
  include Compass::SassExtensions::Functions::Enumerate
  include Compass::SassExtensions::Functions::ImageUrl
end

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
end
