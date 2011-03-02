require 'compass/sass_extensions/sprites/image'
require 'compass/sass_extensions/sprites/engines/chunky_png_engine'
module Compass
  module SassExtensions
    module Sprites
      class Base < Sass::Script::Literal

        def self.from_uri(uri, context, kwargs)
          path, name = Compass::Sprites.path_and_name(uri.value)
          sprites = Compass::Sprites.discover_sprites(uri.value).map do |sprite|
            sprite.gsub(Compass.configuration.images_path+"/", "")
          end
          new(sprites, path, name, context, kwargs)
        end

        def require_engine!
          self.class.send(:include, eval("::Compass::SassExtensions::Sprites::#{modulize}Engine"))
        end
      
        # Changing this string will invalidate all previously generated sprite images.
        # We should do so only when the packing algorithm changes
        SPRITE_VERSION = "1"

        attr_accessor :image_names, :path, :name, :options
        attr_accessor :images, :width, :height


        def initialize(image_names, path, name, context, options)
          require_engine!
          @image_names, @path, @name, @options = image_names, path, name, options
          @images = nil
          @width = nil
          @height = nil
          @evaluation_context = context
          validate!
          compute_image_metadata!
        end

        # Calculate the size of the sprite
        def size
          [width, height]
        end
      
        # Calculates the overal image dimensions
        # collects image sizes and input parameters for each sprite
        def compute_image_metadata!
          @width = 0
          init_images
          compute_image_positions!
          @height = @images.last.top + @images.last.height
        end

        def init_images
          @images = image_names.collect do |relative_file|
            image = Compass::SassExtensions::Sprites::Image.new(relative_file, options)
            @width = [ @width, image.width + image.offset ].max
            image
          end
        end
        # Calculates the overal image dimensions
        # collects image sizes and input parameters for each sprite
        def compute_image_positions!
          @images.each_with_index do |image, index|
            image.left = image.position.unit_str == "%" ? (@width - image.width) * (image.position.value / 100) : image.position.value
            next if index == 0
            last_image = @images[index-1]
            image.top = last_image.top + last_image.height + [image.spacing,  last_image.spacing].max
          end
        end

        def image_for(name)
          @images.detect { |img| img.name == name}
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

        def save!(output_png)
          saved = output_png.save filename
          Compass.configuration.run_callback(:sprite_saved, filename)
          saved
        end

        # All the full-path filenames involved in this sprite
        def image_filenames
          @images.map(&:file)
        end

        # Checks whether this sprite is outdated
        def outdated?
          @images.map(&:mtime).any? { |mtime| mtime > self.mtime }
        end

        def mtime
          File.mtime(filename)
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
        
        private 
        
        def modulize
          @modulize ||= Compass::configuration.sprite_engine.to_s.scan(/([^_.]+)/).flatten.map {|chunk| "#{chunk[0].chr.upcase}#{chunk[1..-1]}" }.join
        end
        
      end
    end
  end
end
