module Compass
  module Configuration
    module CallbackMethods
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
    
    # This is really gross and i hate it but after an hour this is the only way 
    # I can get it to work wit hthe way the current sass call backs are build using class_eval and InstanceMethods
    class Callbacks
      extend CallbackMethods
    end
    
  end
end