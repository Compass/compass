module Compass
  module SassExtensions
    module Sprites
      module ImageMethods
        # Fetches the Sprite::Image object for the supplied name
         def image_for(name)
          if name.is_a?(Sass::Script::Value::String)
            name = name.value
          end
          name = name.to_s
          @images.detect { |img| img.name.downcase == name.downcase}
         end

         # Returns true if the image name has a hover selector image
         def has_hover?(name)
           !get_magic_selector_image(name, 'hover').nil?
         end

         # Returns true if the image name has a target selector image
         def has_target?(name)
           !get_magic_selector_image(name, 'target').nil?
         end

         # Returns true if the image name has a focus selector image
         def has_focus?(name)
           !get_magic_selector_image(name, 'focus').nil?
         end

         # Returns true if the image name has an active selector image
         def has_active?(name)
           !get_magic_selector_image(name, 'active').nil?
         end

         SEPERATORS = ['_', '-']

         def get_magic_selector_image(name, selector)
          SEPERATORS.each do |seperator|
            file = image_for("#{name}#{seperator}#{selector}")
            return file if !file.nil?
          end

          nil
        end

         # Return and array of image names that make up this sprite
         def sprite_names
           image_names.map { |f| File.basename(f, '.png') }
         end
      end
    end
  end
end
