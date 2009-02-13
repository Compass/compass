require 'singleton'

module Compass
  class Configuration
    include Singleton
    attr_accessor :project_path, :css_dir, :sass_dir, :images_dir, :javascripts_dir, :required_libraries

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
      [:css_dir, :sass_dir, :images_dir, :javascripts_dir].each do |prop|
        value = eval(prop.to_s, binding) rescue nil
        self.send("#{prop}=", value) if value
      end
    end

    def serialize
      contents = ""
      required_libraries.each do |lib|
        contents << %Q{require '#{lib}'\n}
      end
      contents << "\n" if required_libraries.any?
      [:css_dir, :sass_dir, :images_dir, :javascripts_dir].each do |prop|
        value = send(prop)
        contents << %Q(#{prop} = "#{value}"\n) if value
      end
      contents
    end

    # Support for testing.
    def reset!
      [:project_path, :css_dir, :sass_dir, :images_dir, :javascripts_dir].each do |attr|
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
      proj_sass_path = File.join(configuration.project_path, configuration.sass_dir)
      proj_css_path = File.join(configuration.project_path, configuration.css_dir)
      locations = {proj_sass_path => proj_css_path}
      Compass::Frameworks::ALL.each do |framework|
        locations[framework.stylesheets_directory] = proj_css_path
      end
      {:template_location => locations}
    end

    def configure_sass_plugin!
      Sass::Plugin.options.merge!(sass_plugin_configuration)
    end

    def sass_engine_options
      load_paths = []
      if configuration.project_path && configuration.sass_dir
        load_paths << File.join(configuration.project_path, configuration.sass_dir)
      end
      Compass::Frameworks::ALL.each do |framework|
        load_paths << framework.stylesheets_directory
      end
      {:load_paths => load_paths}
    end
  end

  extend ConfigHelpers

end
