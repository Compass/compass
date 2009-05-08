require 'singleton'

module Compass
  class Configuration
    include Singleton

    ATTRIBUTES = [
      :project_type,
      :project_path,
      :css_dir,
      :sass_dir,
      :images_dir,
      :javascripts_dir,
      :output_style,
      :environment,
      :http_images_path
    ]

    attr_accessor *ATTRIBUTES

    attr_accessor :required_libraries

    def initialize
      self.required_libraries = []
    end

    # parses a manifest file which is a ruby script
    # evaluated in a Manifest instance context
    def parse(config_file)
      open(config_file) do |f|
        parse_string(f.read, config_file)
      end
    end

    def parse_string(contents, filename)
      eval(contents, binding, filename)
      ATTRIBUTES.each do |prop|
        value = eval(prop.to_s, binding) rescue nil
        self.send("#{prop}=", value) if value
      end
    end

    def set_all(options)
      ATTRIBUTES.each do |a|
        self.send("#{a}=", options[a]) if options.has_key?(a)
      end
    end

    def set_maybe(options)
      ATTRIBUTES.each do |a|
        self.send("#{a}=", options[a]) if options[a]
      end
    end

    def default_all(options)
      ATTRIBUTES.each do |a|
        set_default_unless_set(a, options[a])
      end
    end

    def set_default_unless_set(attribute, value)
      self.send("#{attribute}=", value) unless self.send(attribute)
    end

    def set_defaults!
      ATTRIBUTES.each do |a|
        set_default_unless_set(a, default_for(a))
      end
    end

    def default_for(attribute)
      method = "default_#{attribute}".to_sym
      self.send(method) if respond_to?(method)
    end

    def default_sass_dir
      "src"
    end

    def default_css_dir
      "stylesheets"
    end

    def default_images_dir
      "images"
    end

    def default_http_images_path
      "/#{images_dir}"
    end

    def comment_for_http_images_path
      "# To enable relative image paths using the images_url() function:\n# http_images_path = :relative\n"
    end

    def default_output_style
      if environment == :development
        :expanded
      else
        :compact
      end
    end

    def default_line_comments
      environment == :development
    end

    def sass_path
      if project_path && sass_dir
        File.join(project_path, sass_dir)
      end
    end

    def css_path
      if project_path && css_dir
        File.join(project_path, css_dir)
      end
    end

    def serialize
      contents = ""
      required_libraries.each do |lib|
        contents << %Q{require '#{lib}'\n}
      end
      contents << "# Require any additional compass plugins here.\n"
      contents << "\n" if required_libraries.any?
      ATTRIBUTES.each do |prop|
        value = send(prop)
        if respond_to?("comment_for_#{prop}")
          contents << send("comment_for_#{prop}")
        end
        if block_given? && (to_emit = yield(prop, value))
          contents << to_emit
        else
          contents << Configuration.serialize_property(prop, value) unless value.nil?
        end
      end
      contents
    end

    def self.serialize_property(prop, value)
      %Q(#{prop} = #{value.inspect}\n)
    end

    def to_compiler_arguments(additional_options)
      [project_path, sass_path, css_path, to_sass_engine_options.merge(additional_options)]
    end

    def to_sass_plugin_options
      locations = {}
      locations[sass_path] = css_path if sass_path && css_path
      Compass::Frameworks::ALL.each do |framework|
        locations[framework.stylesheets_directory] = css_path || css_dir || "."
      end
      plugin_opts = {:template_location => locations}
      plugin_opts[:style] = output_style if output_style
      plugin_opts[:line_comments] = default_line_comments if environment
      plugin_opts
    end

    def to_sass_engine_options
      engine_opts = {:load_paths => sass_load_paths}
      engine_opts[:style] = output_style if output_style
      engine_opts[:line_comments] = default_line_comments if environment
      engine_opts
    end

    def sass_load_paths
      load_paths = []
      load_paths << sass_path if sass_path
      Compass::Frameworks::ALL.each do |framework|
        load_paths << framework.stylesheets_directory
      end
      load_paths
    end

    # Support for testing.
    def reset!
      ATTRIBUTES.each do |attr|
        send("#{attr}=", nil)
      end
      self.required_libraries = []
    end

    def require(lib)
      required_libraries << lib
      super
    end

  end

  module ConfigHelpers
    def configuration
      if block_given?
        yield Configuration.instance
      end
      Configuration.instance
    end

    def sass_plugin_configuration
      configuration.to_sass_plugin_options
    end

    def configure_sass_plugin!
      Sass::Plugin.options.merge!(sass_plugin_configuration)
    end

    def sass_engine_options
      configuration.to_sass_engine_options
    end
  end

  extend ConfigHelpers

end
