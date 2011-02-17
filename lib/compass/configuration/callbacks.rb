module Compass
  module Configuration
    module Callbacks
      extend ::Sass::Callbacks
      # on_sprite_generated
      # yields the filename
      # usage: on_sprite_save {|filename| do_somethign(filename) }
      define_callback :sprite_saved
      # on_sprite_generated
      # yields 'ChunkyPNG::Image'
      # usage: on_sprite_generated {|sprite_data| do_something(sprite_data) }
      define_callback :sprite_generated
      
      define_callback :stylesheet_saved
      define_callback :stylesheet_error
      
    end
  end
end