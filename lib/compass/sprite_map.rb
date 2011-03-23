module Compass
  class SpriteMap
    attr_reader :uri, :options

    def initialize(uri, options)
      @uri, @options = uri, options
    end

    def name
      ensure_path_and_name!
      @name
    end

    def path
      ensure_path_and_name!
      @path
    end

    def files
      @files ||= Dir[File.join(Compass.configuration.images_path, uri)].sort
    end

    def sprite_names
      @sprite_names ||= files.collect { |file| File.basename(file, '.png') }
    end

    def sass_options
      @sass_options ||= options.merge(:filename => name, :syntax => :scss, :importer => self)
    end

    def mtime
      Compass.quick_cache("mtime:#{uri}") do
        files.collect { |file| File.mtime(file) }.max
      end
    end

    def sass_engine
      Sass::Engine.new(content_for_images, options)
    end

    private
    def ensure_path_and_name!
      return if @path && @name
      uri =~ %r{((.+/)?(.+))/(.+?)\.png}
      @path, @name = $1, $3
    end

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

