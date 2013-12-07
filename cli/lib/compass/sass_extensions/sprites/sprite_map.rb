module Compass
  module SassExtensions
    module Sprites
      class SpriteMap < Sass::Script::Value::Base
        attr_accessor :image_names, :path, :name, :map, :kwargs
        attr_accessor :images, :width, :height, :engine

        include SpriteMethods
        include ImageMethods
        include LayoutMethods
        include Sass::Script::Value::Helpers


        # Initialize a new sprite object from a relative file path
        # the path is relative to the <tt>images_path</tt> confguration option
        def self.from_uri(uri, context, kwargs)
          uri = uri.value
          path, name = Compass::SpriteImporter.path_and_name(uri)
          files = Compass::SpriteImporter.files(uri)
          sprites = files.map do |sprite|
            relative_name(sprite)
          end
          new(sprites, path, name, context, kwargs)
        end
        
        def self.relative_name(sprite)
          sprite = File.expand_path(sprite)
          Compass.configuration.sprite_load_path.each do |path|
            path_with_slash = "#{File.expand_path(path)}/"
            
            if sprite.include?(path_with_slash)
              return sprite.gsub(path_with_slash, '')
            end
          end
        end

        def initialize(sprites, path, name, context, kwargs)
          @image_names = sprites
          @path = path
          @name = name
          @kwargs = kwargs
          @kwargs['cleanup'] ||= bool(true)
          @kwargs['layout'] ||= identifier('vertical')
          @kwargs['sort_by'] ||= identifier('none')
          @images = nil
          @width = nil
          @height = nil
          @engine = nil
          @evaluation_context = context
          compute_image_metadata!
        end

        def sort_method
          @kwargs['sort_by'].value
        end

        def inspect
          puts 'images'
          @images.each do |img|
            puts img.file
          end
          puts "options"
          @kwargs.each do |k,v|
            puts "#{k}:#{v}"
          end
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
