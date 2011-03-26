module Compass
  class Sprites < Sass::Importers::Base
    attr_accessor :name, :path
    @@maps = {}
    class << self
      
      def path_and_name(uri)
        if uri =~ %r{((.+/)?(.+))/(.+?)\.png}
          [$1, $3, $4]
        end
      end

      def discover_sprites(uri)
        self.load_map(uri, options).files
      end

      def sprite_name(file)
        File.basename(file, '.png')
      end
    end
  
    def self.load_map(uri, options)
      key = self.key(uri, options)
      @@maps[key] ||= SpriteMap.new(uri, options)
    end
  
  
    # Called by the sass engine to build a new SpriteMap
    def find(uri, options)
      if uri =~ /\.png$/
        map = Compass::Sprites.load_map(uri, options)
        self.path, self.name = map.path, map.name
        return map.sass_engine
      end
    end
  
    # Called by the sass engine to identify the SpriteMap
    def self.key(uri, options={})
     [self.class.name + ":" + File.dirname(File.expand_path(uri)), File.basename(uri)]
    end

    def self.mtime(uri, options)
      Compass.quick_cache("mtime:#{uri}") do
        map = Compass::Sprites.load_map(uri, options)
        map.files.inject(Time.at(0)) do |max_time, file|
          (t = File.mtime(file)) > max_time ? t : max_time
        end
      end
    end
  
    def to_s
      ""
    end
  end
end
