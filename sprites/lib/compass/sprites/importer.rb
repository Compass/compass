require 'erb'
require 'compass-core'
require 'compass/sprites/sass_extensions/sprites'
require 'compass/sprites/importer/binding'

module Compass
  module Sprites
    class Importer < Sass::Importers::Base
      VAILD_FILE_NAME       = /\A#{Sass::SCSS::RX::IDENT}\Z/
      SPRITE_IMPORTER_REGEX = %r{((.+\/)?([^\*.]+))\/(.+?)}

      TEMPLATE_FOLDER       = File.join(File.expand_path('../', __FILE__), 'importer')
      CONTENT_TEMPLATE_FILE = File.join(TEMPLATE_FOLDER, 'content.erb')
      CONTENT_TEMPLATE      = ERB.new(File.read(CONTENT_TEMPLATE_FILE))

      # finds all sprite files
      def self.find_all_sprite_map_files(path)
        hex = "[0-9a-f]"
        glob = "*-s#{hex*10}{#{valid_extensions.join(",")}}"
        Sass::Util.glob(File.join(path, "**", glob))
      end

      def find(uri, options)
        if uri =~ self.class.sprite_importer_regex_with_ext
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

      def key(uri, options={})
        [self.class.name + ":sprite:" + File.dirname(File.expand_path(uri)), File.basename(uri)]
      end

      def public_url(*args)
        nil
      end

      def self.path_and_name(uri)
        if uri =~ sprite_importer_regex_with_ext
          [$1, $3]
        else
          raise Compass::Error, "invalid sprite path"
        end
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
        if uri =~ sprite_importer_regex_with_ext
          [$1, $3]
        else
          raise Compass::Error, "invalid sprite path"
        end
      end

      # The on-disk location of this sprite
      def self.path(uri)
        path, _ = path_and_name(uri)
        path
      end

      # Returns the Glob of image files for the uri
      def self.files(uri)
        resolved_files = Compass.configuration.sprite_resolver.glob(:image, uri, :match_all => true)
        resolved_files = resolved_files.inject({}) do |basenames, file|
          basename = File.basename(file, '.png')
          unless basenames.has_key?(basename)
            basenames[basename] = true
            basenames[:files] ||= []
            basenames[:files] << file
          end
          basenames
        end[:files]
        return resolved_files.sort if resolved_files.any?
        path = Compass.configuration.sprite_resolver.asset_collections.map{|ac| ac.images_path }.join(", ")
        raise Compass::SpriteException, %Q{No images were found in the sprite path matching "#{uri}". Your current load paths are: #{path}}
      end

      # Name of this spite
      def self.sprite_name(uri)
        _, name = path_and_name(uri)
        name
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

    private

      def self.valid_extensions
        @valid_extensions ||= Compass::Sprites::SassExtensions::SpriteMap.sprite_engine_class::VALID_EXTENSIONS
      end

      def self.sprite_importer_regex_with_ext
        @importer_regex ||= %r{#{SPRITE_IMPORTER_REGEX}(#{valid_extensions.join('|')})}
      end
    end
  end
end

