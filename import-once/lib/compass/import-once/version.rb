module Compass
  module ImportOnce
    VERSION = File.read(File.join(File.dirname(__FILE__), "..", "..", "..", "VERSION")).strip
  end
end
