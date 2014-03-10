module Compass
  module Frameworks
    extend self

    ALL = []

    class Framework
      attr_accessor :name
      attr_accessor :path
      attr_accessor :version
      attr_accessor :templates_directory, :stylesheets_directory
      def initialize(name, *arguments)
        options = arguments.last.is_a?(Hash) ? arguments.pop : {}
        self.path = path = options[:path] || arguments.shift
        @name = name
        @templates_directory = options[:templates_directory]
        @templates_directory ||= File.join(path, 'templates') if path
        @stylesheets_directory = options[:stylesheets_directory]
        @stylesheets_directory ||= File.join(path, 'stylesheets') if path
        @version = options[:version]
      end

      def template_directories
        if templates_directory
          Dir.glob(File.join(templates_directory, "*")).map{|f| File.basename(f)}
        else
          []
        end
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
      opts = if arguments.last.is_a?(Hash)
               arguments.last
             else
               o = {}
               arguments << o
               o
             end
      opts[:version] ||= guess_gem_version(caller[0])
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

    def guess_gem_version(line_reference)
      if line_reference =~ %r{/gems/([^/]*-[^/]*)/}
        split_at = $1.rindex("-")
        name = $1[1...split_at]
        version = $1[(split_at + 1)..-1]
        version unless name == "compass"
      end
    end

    def discover(frameworks_directory)
      if frameworks_directory == :defaults
        warn("The :defaults argument to Compass::Frameworks.discover is no longer necessary")
        return
      end
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
      if (framework = self[framework_name]) && framework.templates_directory
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

    def pretty_print(skip_patterns = false)
      result = ""
      max = Compass::Frameworks::ALL.inject(0) do |gm, framework|
        fm = framework.template_directories.inject(0) do |lm,pattern|
          [lm, 7 + framework.name.size + pattern.size].max
        end
        [gm, fm].max
      end
      Compass::Frameworks::ALL.each do |framework|
        next if framework.name =~ /^_/
        result << "  * #{framework.name}\n"
        unless skip_patterns
          framework.template_directories.each do |pattern|
            result << "    - #{framework.name}/#{pattern}".ljust(max)
            if description = framework.manifest(pattern).description
              result << " - #{description}"
            end
            result << "\n"
          end
        end
      end
      result
    end
  end

  class << self
    def discover_gem_extensions!
      if defined?(Gem)
        Gem.find_files("compass-*").map{|f| File.basename(f, ".rb")}.each do |compass_extension|
          begin
            require compass_extension
          rescue Gem::LoadError, LoadError
            Compass::Util.compass_warn "Unable to load extension: #{compass_extension}"
          end
        end
      end
    end

    def discover_extensions!
      Compass.shared_extension_paths.each do |extensions_path|
        if File.directory?(extensions_path)
          Compass::Frameworks.discover(extensions_path)
        end
      end
      if File.directory?(configuration.extensions_path)
        Compass::Frameworks.discover(configuration.extensions_path)
      end
      discover_gem_extensions!
    end
  end
end
