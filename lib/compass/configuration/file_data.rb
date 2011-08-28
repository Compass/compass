module Compass
  module Configuration
    class FileData < Data
      def self.new_from_file(config_file, defaults = nil)
        data = new(config_file)
        data.with_defaults(defaults) do
          data._parse(config_file)
        end
        data
      end

      def self.new_from_string(contents, filename, defaults = nil)
        data = new(filename)
        data.with_defaults(defaults) do
          data.parse_string(contents, filename)
        end
        data
      end
    end
  end
end
