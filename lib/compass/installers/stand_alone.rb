module Compass
  module Installers
    
    class StandAloneInstaller < Base

      def configure
        if File.exists?(config_file)
          Compass.configuration.parse(config_file)
        elsif File.exists?(old_config_file)
          Compass.configuration.parse(old_config_file)
        end
        super
      end

      def prepare
        directory ""
        directory css_dir
        directory sass_dir
        directory images_dir if manifest.has_image?
        directory javascripts_dir if manifest.has_javascript?
      end

      def default_css_dir
        Compass.configuration.css_dir || "stylesheets"
      end

      def default_sass_dir
        Compass.configuration.sass_dir ||"src"
      end

      def default_images_dir
        Compass.configuration.images_dir || "images"
      end

      def default_javascripts_dir
        Compass.configuration.javascripts_dir || "javascripts"
      end

      # Read the configuration file for this project
      def config_file
        @config_file ||= targetize('config.rb')
      end

      def old_config_file
        @old_config_file ||= targetize('src/config.rb')
      end
    end

  end
end
