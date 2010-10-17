require 'chunky_png'

module Compass
  class Sprites < Sass::Importers::Base
    attr_accessor :name
    
    class << self
      def reset
        @@sprites = {}
      end
      
      def path_and_name(uri)
        if uri =~ %r{((.+/)?(.+))/(\*)\.png}
          [$1, $3, $4]
        end
      end
    
      def sprites(name)
        @@sprites = {} if @@sprites.nil?
        @@sprites[name] ||= []
      end
    end

    def images
      Compass::Sprites.sprites(self.name)
    end

    def find(uri, options)
      if uri =~ /\.png$/
        path, self.name = Compass::Sprites.path_and_name(uri)
        glob = File.join(Compass.configuration.images_path, uri)
        Dir.glob(glob).sort.each do |file|
          width, height = Compass::SassExtensions::Functions::ImageSize::ImageProperties.new(file).size
          images << {
            :name => File.basename(file, '.png'),
            :file => file,
            :height => height,
            :width => width
          }
        end

        contents = <<-SCSS
          $#{name}-sprite-base-class: ".#{name}-sprite" !default;
          $#{name}-sprite-dimensions: false !default;
        
          \#{$#{name}-sprite-base-class} {
            background: sprite-image("#{uri}") no-repeat;
          }
        
          @mixin #{name}-sprite-dimensions($sprite) {
            height: image-height("#{name}/\#{$sprite}.png");
            width: image-width("#{name}/\#{$sprite}.png");
          }
          
          @mixin #{name}-sprite-position($sprite) {
            background-position: sprite-position("#{path}/\#{$sprite}.png");  
          }
        
          @mixin #{name}-sprite($sprite, $dimensions: $#{name}-sprite-dimensions) {
            @extend \#{$#{name}-sprite-base-class};
            @include #{name}-sprite-position($sprite);
            @if $dimensions {
              @include #{name}-sprite-dimensions($sprite);
            }
          }
        
          @mixin all-#{name}-sprites {
            #{images.map do |sprite| 
                %Q(.#{name}-#{sprite[:name]} { @include #{name}-sprite("#{sprite[:name]}"); })
              end.join}
          }
        SCSS
        options.merge! :filename => name, :syntax => :scss, :importer => self
        Sass::Engine.new(contents, options)
      end
    end

    def key(uri, options)
      [self.class.name + ":" + File.dirname(File.expand_path(uri)),
        File.basename(uri)]
    end
    
    def to_s
      ""
    end

  end
end