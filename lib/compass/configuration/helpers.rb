module Compass
  module Configuration
    @callbacks_loaded = false
    # The helpers are available as methods on the Compass module. E.g. Compass.configuration
    module Helpers
      def configuration
        @configuration ||= default_configuration
        if block_given?
          yield @configuration
        end
        @configuration
      end

      def default_configuration
        Data.new('defaults').extend(Defaults).extend(Comments)
      end

      def add_configuration(config, filename = nil)
        return if config.nil?


        data = configuration_for(config, filename)

        # puts "New configuration: #{data.name}"
        # puts caller.join("\n")
        data.inherit_from!(configuration)
        data.on_top!
        @configuration = data
      end

      def configuration_for(config, filename = nil, defaults = nil)
        if config.nil?
          nil
        elsif config.is_a?(Compass::Configuration::Data)
          config
        elsif config.respond_to?(:read)
          filename ||= config.to_s if config.is_a?(Pathname)
          Compass::Configuration::FileData.new_from_string(config.read, filename, defaults)
        elsif config.is_a?(Hash)
          Compass::Configuration::Data.new(filename, config)
        elsif config.is_a?(String)
          Compass::Configuration::FileData.new_from_file(config, defaults)
        elsif config.is_a?(Symbol)
          Compass::AppIntegration.lookup(config).configuration
        else
          raise "I don't know what to do with: #{config.inspect}"
        end
      end

      # Support for testing.
      def reset_configuration!
        @configuration = nil
      end

      def sass_plugin_configuration
        configuration.to_sass_plugin_options
      end

      def configure_sass_plugin!
        require 'sass/plugin'
        config = sass_plugin_configuration
        locations = config.delete(:template_location)
        Sass::Plugin.options.merge!(config)
        locations.each do |sass_dir, css_dir|
          unless Sass::Plugin.engine_options[:load_paths].include?(sass_dir)
            Sass::Plugin.add_template_location sass_dir, css_dir
          end
        end
        unless @callbacks_loaded
          on_saved = Proc.new do |sass_file, css_file|
                       Compass.configuration.run_stylesheet_saved(css_file)
                     end
          if Sass::Plugin.respond_to?(:on_updated_stylesheet)
            Sass::Plugin.on_updated_stylesheet(&on_saved)
          else
            Sass::Plugin.on_updating_stylesheet(&on_saved)
          end
          
          Sass::Plugin.on_compilation_error do |e, filename, css|
            Compass.configuration.run_stylesheet_error(filename, e.message)
          end
          
          @callbacks_loaded = true
        end
      end

      def sass_engine_options
        configuration.to_sass_engine_options
      end

      # Read the configuration file for this project
      def add_project_configuration(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        configuration_file_path = args.shift || detect_configuration_file

        raise ArgumentError, "Too many arguments" if args.any?
        if AppIntegration.default? && data = configuration_for(configuration_file_path, nil, configuration_for(options[:defaults]))
          if data.raw_project_type
            add_configuration(data.raw_project_type.to_sym)
          elsif options[:project_type]
            add_configuration(options[:project_type])
          else
            add_configuration(:stand_alone)
          end
          add_configuration(data)
        else
          add_configuration(options[:project_type] || configuration.project_type_without_default || (yield if block_given?) || :stand_alone)  
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
      end

      # Returns a full path to the relative path to the project directory
      def projectize(path, project_path = nil)
        project_path ||= configuration.project_path
        File.join(project_path, *path.split('/'))
      end

      def deprojectize(path, project_path = nil)
        project_path ||= configuration.project_path
        if path[0..(project_path.size - 1)] == project_path
          path[(project_path.size + 1)..-1]
        else
          path
        end
      end

      # TODO: Deprecate the src/config.rb location.
      KNOWN_CONFIG_LOCATIONS = ['config/compass.rb', ".compass/config.rb", "config/compass.config", "config.rb", "src/config.rb"]

      # Finds the configuration file, if it exists in a known location.
      def detect_configuration_file(project_path = nil)
        possible_files = KNOWN_CONFIG_LOCATIONS.map{|f| projectize(f, project_path) }
        possible_files.detect{|f| File.exists?(f)}
      end

      def handle_configuration_change!
        if (compiler = Compass.compiler).new_config?
          compiler.clean!
        end
      end

      def compiler
        Compass::Compiler.new(*Compass.configuration.to_compiler_arguments)
      end
    end
  end

  extend Configuration::Helpers
  
end
