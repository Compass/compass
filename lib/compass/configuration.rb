module Compass
  module Configuration

    def self.attributes_for_directory(dir_name, http_dir_name = dir_name)
      [
        "#{dir_name}_dir",
        "#{dir_name}_path",
        ("http_#{http_dir_name}_dir" if http_dir_name),
        ("http_#{http_dir_name}_path" if http_dir_name)
      ].compact.map{|a| a.to_sym}
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
      :environment,
      :relative_assets,
      :additional_import_paths,
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
      :sprite_load_path,
      :required_libraries,
      :loaded_frameworks,
      :framework_path
    ]
    # Registers a new configuration property.
    # Extensions can use this to add new configuration options to compass.
    #
    # @param [Symbol] name The name of the property.
    # @param [String] comment A comment for the property.
    # @param [Proc] default A method to calculate the default value for the property.
    #                       The proc is executed in the context of the project's configuration data.
    def self.add_configuration_property(name, comment = nil, &default)
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
        strip_trailing_separator(name)
      end
    end

    # For testing purposes
    def self.remove_configuration_property(name)
      ATTRIBUTES.delete(name)
    end

  end
end

['adapters', 'comments', 'defaults', 'helpers', 'inheritance', 'serialization', 'paths', 'data', 'file_data'].each do |lib|
  require "compass/configuration/#{lib}"
end
