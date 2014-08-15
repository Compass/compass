module Compass
  module Configuration

    class << self
      def attributes_for_directory(dir_name, http_dir_name = dir_name)
        [
          "#{dir_name}_dir",
          "#{dir_name}_path",
          ("http_#{http_dir_name}_dir" if http_dir_name),
          ("http_#{http_dir_name}_path" if http_dir_name)
        ].compact.map{|a| a.to_sym}
      end

      # Registers a new configuration property.
      # Extensions can use this to add new configuration options to compass.
      #
      # @param [Symbol] name The name of the property.
      # @param [String] comment A comment for the property.
      # @param [Proc] default A method to calculate the default value for the property.
      #                       The proc is executed in the context of the project's configuration data.
      def add_configuration_property(name, comment = nil, &default)
        ATTRIBUTES << name
        if comment.is_a?(String)
          unless comment[0..0] == "#"
            comment = "# #{comment}"
          end
          unless comment[-1..-1] == "\n"
            comment = comment + "\n"
          end
          Data.class_eval <<-COMMENT
          def comment_for_#{name}
          #{comment.inspect}
          end
          COMMENT
        end
        Data.send(:define_method, :"default_#{name}", &default) if default
        Data.inherited_accessor(name)
        if name.to_s =~ /dir|path/
          Data.strip_trailing_separator(name)
        end
      end

      # For testing purposes
      def remove_configuration_property(name)
        ATTRIBUTES.delete(name)
      end

    end

    ATTRIBUTES = [
      # What kind of project?
      :project_type,
      # Where is the project?
      :project_path,
      :http_path,
      # Where are the various bits of the project
      attributes_for_directory(:css, :stylesheets),
      attributes_for_directory(:sass, nil),
      attributes_for_directory(:images),
      attributes_for_directory(:generated_images),
      attributes_for_directory(:javascripts),
      attributes_for_directory(:fonts),
      attributes_for_directory(:extensions, nil),
      # Compilation options
      :output_style,
      :sourcemap,
      :environment,
      :relative_assets,
      :sass_options,
      attributes_for_directory(:cache, nil),
      :cache,
      # Helper configuration
      :asset_host,
      :asset_cache_buster,
      :line_comments,
      :color_output,
      :preferred_syntax,
      :disable_warnings,
      :sprite_engine,
      :chunky_png_options
    ].flatten

    ARRAY_ATTRIBUTES = [
      :additional_import_paths,
      :sprite_load_path,
      :required_libraries,
      :loaded_frameworks,
      :framework_path
    ]

    ARRAY_ATTRIBUTE_OPTIONS = {
      :sprite_load_path => { :clobbers => true }
    }

    RUNTIME_READONLY_ATTRIBUTES = [
      :cache,
      attributes_for_directory(:cache, nil),
      :chunky_png_options,
      :color_output,
      attributes_for_directory(:css, :stylesheets),
      :environment,
      attributes_for_directory(:extensions, nil),
      :framework_path,
      attributes_for_directory(:javascripts),
      :line_comments,
      :loaded_frameworks,
      :output_style,
      :preferred_syntax,
      :project_path,
      :project_type,
      :required_libraries,
      attributes_for_directory(:sass, nil),
      :sass_options,
      :sourcemap,
      :sprite_engine,
    ].flatten

  end

  class << self
    # The Compass configuration singleton.
    def configuration
      @configuration ||= default_configuration
      if block_given?
        yield @configuration
      end
      @configuration
    end

    def default_configuration
      Compass::Configuration::Data.new('defaults').extend(Compass::Configuration::Defaults)
    end

    def add_configuration(data, filename = nil)
      return if data.nil?


      unless data.is_a?(Compass::Configuration::Data)
        # XXX HAX Need to properly factor this apart from the main compass project
        if respond_to?(:configuration_for)
          data = configuration_for(data, filename)
        else
          raise ArgumentError, "Invalid argument: #{data.inspect}"
        end
      end

      data.inherit_from!(configuration) if configuration
      data.on_top!
      @configuration = data
    end

    def reset_configuration!
      @configuration = nil
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
  end
end

%w(defaults inheritance paths data watch adapters).each do |lib|
  require "compass/configuration/#{lib}"
end
