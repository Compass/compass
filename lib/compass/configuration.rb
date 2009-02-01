module Compass
  class Configuration
    attr_accessor :css_dir, :sass_dir, :images_dir, :javascripts_dir

    # parses a manifest file which is a ruby script
    # evaluated in a Manifest instance context
    def parse(config_file)
      open(config_file) do |f|
        eval(f.read, instance_binding, config_file)
      end
    end

    def instance_binding
      binding
    end
  end
end
