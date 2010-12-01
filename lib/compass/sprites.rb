module Compass
  class Sprites < Sass::Importers::Base
    attr_accessor :name
    attr_accessor :path
    
    class << self
      def path_and_name(uri)
        if uri =~ %r{((.+/)?(.+))/(.+?)\.png}
          [$1, $3, $4]
        end
      end
    
      def discover_sprites(uri)
        glob = File.join(Compass.configuration.images_path, uri)
        Dir.glob(glob).sort
      end

      def sprite_name(file)
        File.basename(file, '.png')
      end

    end

    def find_relative(*args)
      nil
    end

    def find(uri, options)
      if uri =~ /\.png$/
        self.path, self.name = Compass::Sprites.path_and_name(uri)
        options.merge! :filename => name, :syntax => :scss, :importer => self
        sprite_files = Compass::Sprites.discover_sprites(uri)
        image_names = sprite_files.map {|i| Compass::Sprites.sprite_name(i) }
        Sass::Engine.new(content_for_images(uri, name, image_names), options)
      end
    end

    def content_for_images(uri, name, images)
      <<-SCSS
@import "compass/utilities/sprites/base";

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

$#{name}-sprites: sprite-map("#{uri}",
#{images.map do |sprite_name| 
%Q{  $#{sprite_name}-position: $#{name}-#{sprite_name}-position,
  $#{sprite_name}-spacing: $#{name}-#{sprite_name}-spacing,
  $#{sprite_name}-repeat: $#{name}-#{sprite_name}-repeat}
end.join(",\n")});

// All sprites should extend this class
// The #{name}-sprite mixin will do so for you.
\#{$#{name}-sprite-base-class} {
  background: $#{name}-sprites no-repeat;
}

// Use this to set the dimensions of an element
// based on the size of the original image.
@mixin #{name}-sprite-dimensions($name) {
  @include sprite-dimensions($#{name}-sprites, $name)
}

// Move the background position to display the sprite.
@mixin #{name}-sprite-position($name, $offset-x: 0, $offset-y: 0) {
  @include sprite-position($#{name}-sprites, $name, $offset-x, $offset-y)
}

// Extends the sprite base class and set the background position for the desired sprite.
// It will also apply the image dimensions if $dimensions is true.
@mixin #{name}-sprite($name, $dimensions: $#{name}-sprite-dimensions, $offset-x: 0, $offset-y: 0) {
  @extend \#{$#{name}-sprite-base-class};
  @include sprite($#{name}-sprites, $name, $dimensions, $offset-x, $offset-y)
}

@mixin #{name}-sprites($sprite-names, $dimensions: $#{name}-sprite-dimensions) {
  @include sprites($#{name}-sprites, $sprite-names, $#{name}-sprite-base-class, $dimensions)
}

// Generates a class for each sprited image.
@mixin all-#{name}-sprites($dimensions: $#{name}-sprite-dimensions) {
  @include #{name}-sprites(#{images.join(" ")}, $dimensions);
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