module Compass
  module Sprites
    module SassExtensions
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
          path, name = Compass::Sprites::Importer.path_and_name(uri)
          files = Compass::Sprites::Importer.files(uri)
          sprites = files.map do |sprite|
            relative_name(sprite)
          end
          new(sprites, path, name, context, kwargs)
        end
        
        def self.relative_name(sprite)
          Compass.configuration.sprite_resolver.relative_path(:image, sprite)
        end

        def self.sprite_engine_class      
          constantize("Compass::SassExtensions::Sprites::#{self.modulize}Engine")
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

        def self.modulize
          @modulize ||= Compass::configuration.sprite_engine.to_s.scan(/([^_.]+)/).flatten.map {|chunk| "#{chunk[0].chr.upcase}#{chunk[1..-1]}" }.join
        end

        def self.constantize(camel_cased_word)
          names = camel_cased_word.split('::')
          names.shift if names.empty? || names.first.empty?

          constant = Object
          names.each do |name|
            constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
          end
          constant
        end



      end
    end
  end
end
