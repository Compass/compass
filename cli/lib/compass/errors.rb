require 'compass/error'
module Compass
  class FilesystemConflict < Error
  end

  class MissingDependency < Error
  end
  class SpriteException < Error; end
end
