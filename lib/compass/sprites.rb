module Compass
  class Sprites < Sass::Importers::Base
    def find_relative(*args)
      nil
    end

    def find(uri, options)
      if uri =~ /\.png$/
        SpriteMap.new(uri, options).sass_engine
      end
    end

    def key(uri, options)
      [self.class.name + ":" + File.dirname(File.expand_path(uri)),
        File.basename(uri)]
    end

    def mtime(uri, options)
      SpriteMap.new(uri, options).mtime
    end
    
    def to_s
      ""
    end
  end
end
