require 'chunky_png'

module Compass
  class Sprites < Sass::Importers::Base
    attr_accessor :name
    
    class << self
      def reset
        @@sprites = {}
      end
      
      def path_and_name(file)
        if file =~ %r{((.+/)?(.+))/(\*)\.png}
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

    def find(url, context = nil)
      if url =~ /\.png$/
        path, self.name = Compass::Sprites.path_and_name(url)
        glob = File.join(Compass.configuration.images_path, url)
        generated_image = "#{path}.png"
        y = 0
        Dir.glob(glob).sort.each do |file|
          width, height = Compass::SassExtensions::Functions::ImageSize::ImageProperties.new(file).size
          images << {
            :name => File.basename(file, '.png'),
            :filename => File.basename(file),
            :height => height,
            :width => width,
            :y => y
          }
          y += height
        end
      
        contents = <<-SCSS
          $#{name}-sprite-base-class: ".#{name}-sprite" !default;
          $#{name}-sprite-dimensions: false !default;
        
          \#{$#{name}-sprite-base-class} {
            background: image-url("#{generated_image}") no-repeat;
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
        Sass::Engine.new(contents, :filename => name, :syntax => :scss, :importer => self)
      end
    end

    def key(name, options)
      [self.class.name + ":" + File.dirname(File.expand_path(name)),
        File.basename(name)]
    end
  
    def to_s
      "fdsfd"
    end

  end
end