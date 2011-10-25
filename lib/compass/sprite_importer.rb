require 'erb'
module Compass
  class SpriteImporter < Sass::Importers::Base
    VAILD_FILE_NAME = /\A#{Sass::SCSS::RX::IDENT}\Z/
    SPRITE_IMPORTER_REGEX = %r{((.+/)?([^\*.]+))/(.+?)\.png}
    VALID_EXTENSIONS = ['.png']
    
    
    TEMPLATE_FOLDER = File.join(File.expand_path('../', __FILE__), 'sprite_importer')
    CONTENT_TEMPLATE_FILE = File.join(TEMPLATE_FOLDER, 'content.erb')
    GENERATE_OVERRIDES_TEMPLATE_FILE = File.join(TEMPLATE_FOLDER, 'generate_overrides.erb')

    # finds all sprite files
    def self.find_all_sprite_map_files(path)
      hex = "[0-9a-f]"
      glob = "*-{,s}#{hex*10}{#{VALID_EXTENSIONS.join(",")}}"
      Dir.glob(File.join(path, "**", glob))
    end
    
    def find(uri, options)
      if uri =~ SPRITE_IMPORTER_REGEX
        return self.class.sass_engine(uri, self.class.sprite_name(uri), self, options)
      end
      nil
    end
    
    def find_relative(uri, base, options)
      find(File.join(base, uri), options)
    end
    
    def to_s
      self.class.name
    end
    
    def hash
      self.class.name.hash
    end
	
    def eql?(other)
      other.class == self.class
    end
    
    def mtime(uri, options)
      self.class.files(uri).sort.inject(Time.at(0)) do |max_time, file|
        (t = File.mtime(file)) > max_time ? t : max_time
      end
    end
    
    def key(uri, options={})
      [self.class.name + ":sprite:" + File.dirname(File.expand_path(uri)), File.basename(uri)]
    end
    
    def self.path_and_name(uri)
      if uri =~ SPRITE_IMPORTER_REGEX
        [$1, $3]
      else
        raise Compass::Error, "invalid sprite path"
      end
    end

    # Name of this spite
    def self.sprite_name(uri)
      _, name = path_and_name(uri)
      name
    end

    # The on-disk location of this sprite
    def self.path(uri)
      path, _ = path_and_name(uri)
      path
    end
    
    # Returns the Glob of image files for the uri
    def self.files(uri)
      Compass.configuration.sprite_load_path.each do |folder|
        files = Dir[File.join(folder, uri)].sort
        next if files.empty?
        return files
      end
    end

    # Returns an Array of image names without the file extension
    def self.sprite_names(uri)
      files(uri).collect do |file|
        filename = File.basename(file, '.png')
        unless VAILD_FILE_NAME =~ filename
          raise Compass::Error, "Sprite file names must be legal css identifiers. Please rename #{File.basename(file)}"
        end
        filename
      end
    end
    
    # Returns the sass_options for this sprite
    def self.sass_options(name, importer, options)
      options.merge!(:filename => name, :syntax => :scss, :importer => importer)
    end
    
    # Returns a Sass::Engine for this sprite object
    def self.sass_engine(uri, name, importer, options)
      Sass::Engine.new(content_for_images(uri, name, options[:skip_overrides]), sass_options(name, importer, options))
    end

    # Generates the Sass for this sprite file
    def self.content_for_images(uri, name, skip_overrides = false)
      CONTENT_TEMPLATE ||= ERB.new(CONTENT_TEMPLATE_FILE)
    end
    
    # Generates the override defaults for this Sprite
    # <tt>$#{name}-#{sprite_name}-position </tt>
    # <tt> $#{name}-#{sprite_name}-spacing </tt>
    # <tt> #{name}-#{sprite_name}-repeat: </tt>
    def self.generate_overrides(uri, name)
      sprites = sprite_names(uri)
      content = <<-TXT
// These variables control the generated sprite output
// You can override them selectively before you import this file.
      TXT
      sprites.map do |sprite_name| 
        content += <<-SCSS
$#{name}-#{sprite_name}-position: $#{name}-position !default;
$#{name}-#{sprite_name}-spacing: $#{name}-spacing !default;
$#{name}-#{sprite_name}-repeat: $#{name}-repeat !default;
        SCSS
      end.join

      content += "\n$#{name}-sprites: sprite-map(\"#{uri}\", \n$layout: $#{name}-layout, \n$cleanup: $#{name}-clean-up,\n"
      content += sprites.map do |sprite_name| 
%Q{  $#{sprite_name}-position: $#{name}-#{sprite_name}-position,
  $#{sprite_name}-spacing: $#{name}-#{sprite_name}-spacing,
  $#{sprite_name}-repeat: $#{name}-#{sprite_name}-repeat}
      end.join(",\n")
      content += ");"
    end
  end
end

