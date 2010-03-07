module Compass::SassExtensions::Functions
end

%w(selectors enumerate urls display inline_image image_size gradient_support font_files).each do |func|
  require "compass/sass_extensions/functions/#{func}"
end

module Sass::Script::Functions
  include Compass::SassExtensions::Functions::Selectors
  include Compass::SassExtensions::Functions::Enumerate
  include Compass::SassExtensions::Functions::Urls
  include Compass::SassExtensions::Functions::Display
  include Compass::SassExtensions::Functions::InlineImage
  include Compass::SassExtensions::Functions::ImageSize
  include Compass::SassExtensions::Functions::GradientSupport::Functions
  include Compass::SassExtensions::Functions::FontFiles
end

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
end
