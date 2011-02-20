module Compass
  module Configuration
    class FileData < Data
      extend Sass::Callbacks

      # on_sprite_generated
      # yields the filename
      # usage: on_sprite_save {|filename| do_somethign(filename) }
      define_callback :sprite_saved

      # on_sprite_generated
      # yields 'ChunkyPNG::Image'
      # usage: on_sprite_generated {|sprite_data| do_something(sprite_data) }
      define_callback :sprite_generated

      # on_stylesheet_saved
      # yields the filename
      # usage: on_stylesheet_saved {|filename| do_something(filename) }
      define_callback :stylesheet_saved

      # on_stylesheet_error
      # yields the filename & message
      # usage: on_stylesheet_error {|filename, message| do_something(filename, message) }
      define_callback :stylesheet_error

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
