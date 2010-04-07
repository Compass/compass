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
      def template_directories
        Dir.glob(File.join(templates_directory, "*")).map{|f| File.basename(f)}
      end
      def manifest_file(pattern)
        File.join(templates_directory, pattern.to_s, "manifest.rb")
      end
      def manifest(pattern, options = {})
        options[:pattern_name] ||= pattern
        Compass::Installers::Manifest.new(manifest_file(pattern), options)
      end
    end

    def detect_registration
      @registered = nil
      yield
      @registered
    ensure
      @registered = nil
    end

    def register(name, *arguments)
      @registered = Framework.new(name, *arguments)
      if idx = ALL.index(self[name])
        ALL[idx] = @registered
      else
        ALL << @registered
      end
    end

    def [](name)
      ALL.detect{|f| f.name.to_s == name.to_s}
    end

    def discover(frameworks_directory)
      frameworks_directory = DEFAULT_FRAMEWORKS_PATH if frameworks_directory == :defaults
      frameworks_directory = Dir.new(frameworks_directory) unless frameworks_directory.is_a?(Dir)
      dirs = frameworks_directory.entries.reject{|e| e =~ /^\./}.sort_by{|n| n =~ /^_/ ? n[1..-1] : n}
      dirs.each do |framework|
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
      registered_framework = detect_registration do
        require loader if loader
      end
      unless registered_framework
        register File.basename(directory), directory
      end
    end

    def template_exists?(template)
      framework_name, template = template.split(%r{/}, 2)
      template ||= "project"
      if framework = self[framework_name]
        return File.directory?(File.join(framework.templates_directory, template))
      end
      false
    end

    def template_usage(template)
      framework_name, template = template.split(%r{/}, 2)
      framework = self[framework_name]
      template ||= "project"
      usage_file = File.join(framework.templates_directory, template, "USAGE.markdown")
      if File.exists?(usage_file)
        File.read(usage_file)
      elsif help = framework.manifest(template).help
        help
      else
        <<-END.gsub(/^ {8}/, '')
          No Usage!
        END
      end
    end

  end
end

Compass::Frameworks.discover(:defaults)
