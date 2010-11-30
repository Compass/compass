module Compass
  class Sprites < Sass::Importers::Base
    attr_accessor :name
    attr_accessor :path
    
    class << self
      def reset
        @@sprites = {}
      end
      
      def path_and_name(uri)
        if uri =~ %r{((.+/)?(.+))/(.+?)\.png}
          [$1, $3, $4]
        end
      end
    
      def sprites(path, name, create = false)
        if !defined?(@@sprites) || @@sprites.nil?
          @@sprites = {}
        end
        index = "#{path}/#{name}"
        images = @@sprites[index]
        if images
          images
        elsif create
          images = @@sprites[index] = []
        else
          raise Compass::Error, %Q(`@import` statement missing. Please add `@import "#{path}/*.png";`.)
        end
      end

      def discover_sprites(uri)
        glob = File.join(Compass.configuration.images_path, uri)
        Dir.glob(glob).sort
      end

      def compute_image_metadata!(file, path, name)
        width, height = Compass::SassExtensions::Functions::ImageSize::ImageProperties.new(file).size
        sprite_name = File.basename(file, '.png');
        unless sprite_name =~ /\A#{Sass::SCSS::RX::IDENT}\Z/
          raise Sass::SyntaxError, "#{sprite_name} must be a legal css identifier"
        end
        sprites(path, name, true) << {
          :name => sprite_name,
          :file => file,
          :height => height,
          :width => width
        }
      end
    end

    def images
      Compass::Sprites.sprites(self.path, self.name, true)
    end

    def find(uri, options)
      if uri =~ /\.png$/
        self.path, self.name = Compass::Sprites.path_and_name(uri)
        options.merge! :filename => name, :syntax => :scss, :importer => self
        image_names = Compass::Sprites.discover_sprites(uri).map{|i| File.basename(i, '.png')}
        Sass::Engine.new(content_for_images(uri, name, image_names), options)
      end
    end

    def content_for_images(uri, name, images)
      <<-SCSS
// General Sprite Defaults
// You can override them before you import this file.
$#{name}-sprite-base-class: ".#{name}-sprite" !default;
$#{name}-sprite-dimensions: false !default;
$#{name}-position: 0% !default;
$#{name}-spacing: 0 !default;
$#{name}-repeat: no-repeat !default;

// These variables control the generated sprite output
// You can override them selectively before you import this file.
#{images.map do |sprite_name| 
<<-SCSS
$#{name}-#{sprite_name}-position: $#{name}-position !default;
$#{name}-#{sprite_name}-spacing: $#{name}-spacing !default;
$#{name}-#{sprite_name}-repeat: $#{name}-repeat !default;
SCSS
end.join}

// All sprites should extend this class
// The #{name}-sprite mixin will do so for you.
\#{$#{name}-sprite-base-class} {
  background: generate-sprite-image("#{uri}",
#{images.map do |sprite_name| 
%Q{    $#{sprite_name}-position: $#{name}-#{sprite_name}-position,
    $#{sprite_name}-spacing: $#{name}-#{sprite_name}-spacing,
    $#{sprite_name}-repeat: $#{name}-#{sprite_name}-repeat}
end.join(",\n")}) no-repeat;
}

// Use this to set the dimensions of an element
// based on the size of the original image.
@mixin #{name}-sprite-dimensions($sprite) {
  height: image-height("#{name}/\#{$sprite}.png");
  width: image-width("#{name}/\#{$sprite}.png");
}

// Move the background position to display the sprite.
@mixin #{name}-sprite-position($sprite, $x: 0, $y: 0) {
  background-position: sprite-position("#{path}/\#{$sprite}.png", $x, $y);  
}

// Extends the sprite base class and set the background position for the desired sprite.
// It will also apply the image dimensions if $dimensions is true.
@mixin #{name}-sprite($sprite, $dimensions: $#{name}-sprite-dimensions, $x: 0, $y: 0) {
  @extend \#{$#{name}-sprite-base-class};
  @include #{name}-sprite-position($sprite, $x, $y);
  @if $dimensions {
    @include #{name}-sprite-dimensions($sprite);
  }
}

// Generates a class for each sprited image.
@mixin all-#{name}-sprites {
#{images.map do |sprite_name| 
<<-SCSS
  .#{name}-#{sprite_name} {
    @include #{name}-sprite("#{sprite_name}");
  }
SCSS
end.join}
}
      SCSS
    end

    def key(uri, options)
      [self.class.name + ":" + File.dirname(File.expand_path(uri)),
        File.basename(uri)]
    end

    def mtime(uri, options)
      Compass.quick_cache("mtime:#{uri}") do
        self.path, self.name = Compass::Sprites.path_and_name(uri)
        glob = File.join(Compass.configuration.images_path, uri)
        Dir.glob(glob).inject(Time.at(0)) do |max_time, file|
          (t = File.mtime(file)) > max_time ? t : max_time
        end
      end
    end
    
    def to_s
      ""
    end

  end
end