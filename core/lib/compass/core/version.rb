module Compass
  module Core
    def self.scope(file)
      File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", file))
    end

    VERSION = File.exist?(scope("RELEASE_VERSION")) ?
                File.read(scope("RELEASE_VERSION")).strip :
                File.read(scope("VERSION")).strip
  end
end
