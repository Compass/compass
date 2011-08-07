module Compass
  module SassExtensions
    module Sprites
      module ImageMethods
        # Fetches the Sprite::Image object for the supplied name
         def image_for(name)
           @images.detect { |img| img.name == name}
         end

         # Returns true if the image name has a hover selector image
         def has_hover?(name)
           !image_for("#{name}_hover").nil?
         end

         # Returns true if the image name has a target selector image
         def has_target?(name)
           !image_for("#{name}_target").nil?
         end

         # Returns true if the image name has an active selector image
         def has_active?(name)
           !image_for("#{name}_active").nil?
         end

         # Return and array of image names that make up this sprite
         def sprite_names
           image_names.map { |f| File.basename(f, '.png') }
         end
      end
    end
  end
end