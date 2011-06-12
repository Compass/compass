module Compass
  module SassExtensions
    module Sprites
      class SpriteMap < Sass::Script::Literal
        attr_accessor :image_names, :path, :name, :map, :kwargs
        attr_accessor :images, :width, :height, :engine

        include SpriteMethods
        include ImageMethods


        # Initialize a new sprite object from a relative file path
        # the path is relative to the <tt>images_path</tt> confguration option
        def self.from_uri(uri, context, kwargs)
          importer = ::Compass::SpriteImporter.new(:uri => uri.value, :options => {})
          sprites = importer.files.map do |sprite|
            sprite.gsub(Compass.configuration.images_path+"/", "")
          end
          new(sprites, importer.path, importer.name, context, kwargs)
        end

        def initialize(sprites, path, name, context, kwargs)
          @image_names = sprites
          @path = path
          @name = name
          @kwargs = kwargs
          @kwargs['cleanup'] ||= Sass::Script::Bool.new(true)
          @images = nil
          @width = nil
          @height = nil
          @engine = nil
          @evaluation_context = context
          validate!
          compute_image_metadata!
        end

        def inspect
          to_s
        end

        def to_s(kwargs = self.kwargs)
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