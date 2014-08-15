module Compass::Core::SassExtensions::Functions
  module SassDeclarationHelper
    def declare(*args)
      Sass::Script::Functions.declare(*args)
    end
  end
end

%w(
  selectors    enumerate  urls      display
  inline_image image_size constants gradient_support
  font_files   lists      colors    math
  env          cross_browser_support configuration
  files
).each do |func|
  require "compass/core/sass_extensions/functions/#{func}"
end

module Sass::Script::Functions
  include Compass::Core::SassExtensions::Functions::Configuration
  include Compass::Core::SassExtensions::Functions::Selectors
  include Compass::Core::SassExtensions::Functions::Enumerate
  include Compass::Core::SassExtensions::Functions::Urls
  include Compass::Core::SassExtensions::Functions::Display
  include Compass::Core::SassExtensions::Functions::InlineImage
  include Compass::Core::SassExtensions::Functions::ImageSize
  include Compass::Core::SassExtensions::Functions::GradientSupport::Functions
  include Compass::Core::SassExtensions::Functions::FontFiles
  include Compass::Core::SassExtensions::Functions::Files
  include Compass::Core::SassExtensions::Functions::Constants
  include Compass::Core::SassExtensions::Functions::Lists
  include Compass::Core::SassExtensions::Functions::Colors
  include Compass::Core::SassExtensions::Functions::Math
  include Compass::Core::SassExtensions::Functions::CrossBrowserSupport
  include Compass::Core::SassExtensions::Functions::Env
end

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
end
