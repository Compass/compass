module Compass
  class Error < StandardError
  end

  class FilesystemConflict < Error
  end

  class MissingDependency < Error
  end
  class SpriteException < Error; end
end
