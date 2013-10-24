module Compass::SassExtensions::Functions
  module SassDeclarationHelper
    def declare(*args)
      Sass::Script::Functions.declare(*args)
    end
  end
end

%w(sprites).each do |func|
  require "compass/sass_extensions/functions/#{func}"
end

module Sass::Script::Functions
  include Compass::SassExtensions::Functions::Sprites
end
