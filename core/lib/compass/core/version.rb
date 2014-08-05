require 'compass/core/generated_version'

module Compass
  module Core
    unless defined?(::Compass::Core::VERSION)
      def self.scope(file)
        File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", file))
      end

      VERSION = File.read(scope("VERSION")).strip
    end
  end
end
