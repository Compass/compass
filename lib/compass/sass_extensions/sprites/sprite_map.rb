module Compass
  class SpriteMap
    attr_reader :uri, :options
    VAILD_FILE_NAME = /\A#{Sass::SCSS::RX::IDENT}\Z/

    def find_relative(*args)
      nil
    end

    def initialize(uri, options)
      @uri, @options = uri, options
    end

    # Name of this spite
    def name
      ensure_path_and_name!
      @name
    end

    # The on-disk location of this sprite
    def path
      ensure_path_and_name!
      @path
    end
    
    # Returns the Glob of image files for this sprite
    def files
      @files ||= Dir[File.join(Compass.configuration.images_path, uri)].sort
    end

    # Returns an Array of image names without the file extension
    def sprite_names
      @sprite_names ||= files.collect do |file|
        filename = File.basename(file, '.png')
        unless VAILD_FILE_NAME =~ filename
          raise Compass::Error, "Sprite file names must be legal css identifiers. Please rename #{File.basename(file)}"
        end
        filename
      end
    end
    
    # Returns the sass options for this sprite
    def sass_options
      @sass_options ||= options.merge(:filename => name, :syntax => :scss, :importer => self)
    end
    
    # Returns a Sass::Engine for this sprite object
    def sass_engine
      Sass::Engine.new(content_for_images, sass_options)
    end
    
    def ensure_path_and_name!
      @path, @name = Compass::Sprites.path_and_name(uri)
    end
    
    def key(uri, options)
      Compass::Sprites.key(uri)
    end

    def mtime(uri, options)
      Compass::Sprites.mtime(uri, options)
    end

    # Generates the Sass for this sprite file
    def content_for_images(skip_overrides = false)
      <<-SCSS
@import "compass/utilities/sprites/base";

// General Sprite Defaults
// You can override them before you import this file.
$#{name}-sprite-base-class: ".#{name}-sprite" !default;
$#{name}-sprite-dimensions: false !default;
$#{name}-position: 0% !default;
$#{name}-spacing: 0 !default;
$#{name}-repeat: no-repeat !default;
$#{name}-prefix: '' !default;

#{skip_overrides ? "$#{name}-sprites: sprite-map(\"#{uri}\");" : generate_overrides }

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
  @include sprite-background-position($#{name}-sprites, $name, $offset-x, $offset-y)
}

// Extends the sprite base class and set the background position for the desired sprite.
// It will also apply the image dimensions if $dimensions is true.
@mixin #{name}-sprite($name, $dimensions: $#{name}-sprite-dimensions, $offset-x: 0, $offset-y: 0) {
  @extend \#{$#{name}-sprite-base-class};
  @include sprite($#{name}-sprites, $name, $dimensions, $offset-x, $offset-y)
}

@mixin #{name}-sprites($sprite-names, $dimensions: $#{name}-sprite-dimensions, $prefix: sprite-map-name($#{name}-sprites)) {
  @include sprites($#{name}-sprites, $sprite-names, $#{name}-sprite-base-class, $dimensions, $prefix)
}

// Generates a class for each sprited image.
@mixin all-#{name}-sprites($dimensions: $#{name}-sprite-dimensions, $prefix: sprite-map-name($#{name}-sprites)) {
  @include #{name}-sprites(#{sprite_names.join(" ")}, $dimensions, $prefix);
}
SCSS
    end
    
    # Generates the override defaults for this Sprite
    # <tt>$#{name}-#{sprite_name}-position </tt>
    # <tt> $#{name}-#{sprite_name}-spacing </tt>
    # <tt> #{name}-#{sprite_name}-repeat: </tt>
    def generate_overrides
      content = <<-TXT
// These variables control the generated sprite output
// You can override them selectively before you import this file.
      TXT
      sprite_names.map do |sprite_name| 
        content += <<-SCSS
$#{name}-#{sprite_name}-position: $#{name}-position !default;
$#{name}-#{sprite_name}-spacing: $#{name}-spacing !default;
$#{name}-#{sprite_name}-repeat: $#{name}-repeat !default;
        SCSS
      end.join

      content += "\n$#{name}-sprites: sprite-map(\"#{uri}\",\n"
      content += sprite_names.map do |sprite_name| 
%Q{  $#{sprite_name}-position: $#{name}-#{sprite_name}-position,
  $#{sprite_name}-spacing: $#{name}-#{sprite_name}-spacing,
  $#{sprite_name}-repeat: $#{name}-#{sprite_name}-repeat}
      end.join(",\n")
      content += ");"
    end
  end
end

