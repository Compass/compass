require 'erb'
require 'compass/sprite_importer/binding'
module Compass
  class SpriteImporter < Sass::Importers::Base
    VAILD_FILE_NAME       = /\A#{Sass::SCSS::RX::IDENT}\Z/
    SPRITE_IMPORTER_REGEX = %r{((.+/)?([^\*.]+))/(.+?)\.png}
    VALID_EXTENSIONS      = ['.png']
    
    TEMPLATE_FOLDER       = File.join(File.expand_path('../', __FILE__), 'sprite_importer')
    CONTENT_TEMPLATE_FILE = File.join(TEMPLATE_FOLDER, 'content.erb')
    CONTENT_TEMPLATE      = ERB.new(File.read(CONTENT_TEMPLATE_FILE))



    # finds all sprite files
    def self.find_all_sprite_map_files(path)
      hex = "[0-9a-f]"
      glob = "*-s#{hex*10}{#{VALID_EXTENSIONS.join(",")}}"
      Sass::Util.glob(File.join(path, "**", glob))
    end
    
    def find(uri, options)
      if uri =~ SPRITE_IMPORTER_REGEX
        return self.class.sass_engine(uri, self.class.sprite_name(uri), self, options)
      end
      nil
    end
    
    def find_relative(uri, base, options)
      nil
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

    def public_url(*args)
      nil
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
      Compass.configuration.sprite_load_path.compact.each do |folder|
        files = Sass::Util.glob(File.join(folder, uri)).sort
        next if files.empty?
        return files
      end

      path = Compass.configuration.sprite_load_path.to_a.join(', ')
      raise Compass::SpriteException, %Q{No files were found in the load path matching "#{uri}". Your current load paths are: #{path}}
    end

    # Returns an Array of image names without the file extension
    def self.sprite_names(uri)
      files(uri).collect do |file|
        File.basename(file, '.png')
      end
    end
    
    # Returns the sass_options for this sprite
    def self.sass_options(uri, importer, options)
      options.merge!(:filename => uri.gsub(%r{\*/},"*\\/"), :syntax => :scss, :importer => importer)
    end
    
    # Returns a Sass::Engine for this sprite object
    def self.sass_engine(uri, name, importer, options)
      content = content_for_images(uri, name, options[:skip_overrides])
      Sass::Engine.new(content, sass_options(uri, importer, options))
    end

    # Generates the Sass for this sprite file
    def self.content_for_images(uri, name, skip_overrides = false)
      binder = Compass::Sprites::Binding.new(:name => name, :uri => uri, :skip_overrides => skip_overrides, :sprite_names => sprite_names(uri), :files => files(uri))
      CONTENT_TEMPLATE.result(binder.get_binding)
    end
  end
end

