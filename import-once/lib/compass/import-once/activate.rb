require 'compass/import-once'
module Sass
  class Engine
    def self.new(*args)
      instance = super
      instance.extend(Compass::ImportOnce::Engine)
      if i = instance.options[:importer]
        i.extend(Compass::ImportOnce::Importer) unless i.is_a?(Compass::ImportOnce::Importer)
      end
      instance.options[:load_paths].each do |path|
        if path.is_a?(Sass::Importers::Base) && !path.is_a?(Compass::ImportOnce::Importer)
          path.extend(Compass::ImportOnce::Importer)
        elsif !path.is_a?(Sass::Importers::Base)
          Sass::Util.sass_warn "WARNING: #{path.inspect} is on the load path and is not an importer."
        end
      end
      instance
    end
  end
end
