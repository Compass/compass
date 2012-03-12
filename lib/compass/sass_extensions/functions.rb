module Compass::SassExtensions::Functions
end

%w(
  selectors    enumerate  urls      display
  inline_image image_size constants gradient_support
  font_files   lists      colors    math
  sprites      env        cross_browser_support
).each do |func|
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
  include Compass::SassExtensions::Functions::Constants
  include Compass::SassExtensions::Functions::Lists
  include Compass::SassExtensions::Functions::Colors
  include Compass::SassExtensions::Functions::Math
  include Compass::SassExtensions::Functions::Sprites
  include Compass::SassExtensions::Functions::CrossBrowserSupport
  include Compass::SassExtensions::Functions::Env
end

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
end
