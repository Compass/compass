module Compass::SassExtensions::Functions
  module SassDeclarationHelper
    def declare(*args)
      Sass::Script::Functions.declare(*args)
    end
  end
end
