require 'singleton'

module Compass
  class Configuration
    include Singleton
    attr_accessor :project_path, :css_dir, :sass_dir, :images_dir, :javascripts_dir

    # parses a manifest file which is a ruby script
    # evaluated in a Manifest instance context
    def parse(config_file)
      open(config_file) do |f|
        eval(f.read, instance_binding, config_file)
      end
    end

    def reset!
      [:project_path, :css_dir, :sass_dir, :images_dir, :javascripts_dir].each do |attr|
        send("#{attr}=", nil)
      end
    end

    def instance_binding
      binding
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
  end

  extend ConfigHelpers

end
