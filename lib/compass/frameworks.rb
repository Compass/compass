module Compass
  module Frameworks
    extend self

    ALL = []
    DEFAULT_FRAMEWORKS_PATH = File.join(Compass.base_directory, 'frameworks')

    class Framework
      attr_accessor :name
      attr_accessor :templates_directory, :stylesheets_directory
      def initialize(name, *arguments)
        options = arguments.last.is_a?(Hash) ? arguments.pop : {}
        path = options[:path] || arguments.shift
        @name = name
        @templates_directory = options[:templates_directory] || File.join(path, 'templates')
        @stylesheets_directory = options[:stylesheets_directory] || File.join(path, 'stylesheets')
      end
    end

    def register(name, *arguments)
      ALL << Framework.new(name, *arguments)
    end

    def [](name)
      ALL.detect{|f| f.name.to_s == name.to_s}
    end

    def discover(frameworks_directory)
      frameworks_directory = DEFAULT_FRAMEWORKS_PATH if frameworks_directory == :defaults
      frameworks_directory = Dir.new(frameworks_directory) unless frameworks_directory.is_a?(Dir)
      frameworks_directory.entries.reject{|e| e[0] == ?.}.each do |framework|
        register_directory File.join(frameworks_directory.path, framework)
      end
    end

    def register_directory(directory)
      loaders = [
        File.join(directory, "compass_init.rb"),
        File.join(directory, 'lib', File.basename(directory)+".rb"),
        File.join(directory, File.basename(directory)+".rb")
      ]
      loader = loaders.detect{|l| File.exists?(l)}
      if loader
        require loader
      else
        register File.basename(directory), directory
      end
    end

  end
end

Compass::Frameworks.discover(:defaults)
