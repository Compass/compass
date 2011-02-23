module Compass
  module SassExtensions
    module Sprites
      class Base < Sass::Script::Literal
        # Changing this string will invalidate all previously generated sprite images.
        # We should do so only when the packing algorithm changes
        SPRITE_VERSION = "1"

        attr_accessor :image_names, :path, :name, :options
        attr_accessor :images, :width, :height

        def self.from_uri(uri, context, kwargs)
          path, name = Compass::Sprites.path_and_name(uri.value)
          sprites = Compass::Sprites.discover_sprites(uri.value).map do |sprite|
            sprite.gsub(Compass.configuration.images_path+"/", "")
          end
          new(sprites, path, name, context, kwargs)
        end

        def initialize(image_names, path, name, context, options)
          @image_names, @path, @name, @options = image_names, path, name, options
          @images = nil
          @width = nil
          @height = nil
          @evaluation_context = context
          validate!
          compute_image_metadata!
        end

        def sprite_names
          image_names.map{|f| Compass::Sprites.sprite_name(f) }
        end

        def validate!
          for sprite_name in sprite_names
            unless sprite_name =~ /\A#{Sass::SCSS::RX::IDENT}\Z/
              raise Sass::SyntaxError, "#{sprite_name} must be a legal css identifier"
            end
          end
        end

        # The on-the-disk filename of the sprite
        def filename
          File.join(Compass.configuration.images_path, "#{path}-#{uniqueness_hash}.png")
        end

        # Calculates the overal image dimensions
        # collects image sizes and input parameters for each sprite
        def compute_image_metadata!
        end

        # Generate a sprite image if necessary
        def generate
          if generation_required?
            sprite_data = construct_sprite
            save!(sprite_data)
            Compass.configuration.run_callback(:sprite_generated, sprite_data)
          end
        end

        def generation_required?
          !File.exists?(filename) || outdated?
        end

        def uniqueness_hash
          @uniqueness_hash ||= begin
            sum = Digest::MD5.new
            sum << SPRITE_VERSION
            sum << path
            images.each do |image|
              [:relative_file, :height, :width, :repeat, :spacing, :position, :digest].each do |attr|
                sum << image.send(attr).to_s
              end
            end
            sum.hexdigest[0...10]
          end
          @uniqueness_hash
        end

        # saves the sprite for later retrieval
        def save!(output_png)
          saved = output_png.save filename
          Compass.configuration.run_callback(:sprite_saved, filename)
          saved
        end

        # All the full-path filenames involved in this sprite
        def image_filenames
          image_names.map do |image_name|
            File.join(Compass.configuration.images_path, image_name)
          end
        end

        def inspect
          to_s
        end

        def to_s(options = self.options)
          sprite_url(self).value
        end

        def respond_to?(meth)
          super || @evaluation_context.respond_to?(meth)
        end

        def method_missing(meth, *args, &block)
          if @evaluation_context.respond_to?(meth)
            @evaluation_context.send(meth, *args, &block)
          else
            super
          end
        end

      end
    end
  end
end
