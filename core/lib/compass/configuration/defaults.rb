module Compass
  module Configuration
    module Defaults
      def default_project_path
        "."
      end

      def default_project_type
        :stand_alone
      end

      def default_http_path
        "/"
      end

      def default_extensions_dir
        "extensions"
      end

      def default_css_dir
        "stylesheets"
      end

      def default_sass_dir
        "sass"
      end

      def default_fonts_dir
        "fonts"
      end

      def default_images_dir
        "images"
      end

      def default_environment
        :development
      end

      def default_output_style
        if top_level.environment == :development
          :expanded
        else
          :compressed
        end
      end

      def default_line_comments
        top_level.environment == :development
      end

      def default_color_output
        true
      end

      def default_sass_path
        if (pp = top_level.project_path) && (dir = top_level.sass_dir)
          Compass.projectize(dir, pp)
        end
      end

      def default_css_path
        if (pp = top_level.project_path) && (dir = top_level.css_dir)
          Compass.projectize(dir, pp)
        end
      end

      def default_images_path
        if (pp = top_level.project_path) && (dir = top_level.images_dir)
          Compass.projectize(dir, pp)
        end
      end

      def default_generated_images_path
        if (pp = top_level.project_path) && (dir = top_level.generated_images_dir)
          Compass.projectize(dir, pp)
        else
          top_level.images_path
        end
      end

      def default_javascripts_path
        if (pp = top_level.project_path) && (dir = top_level.javascripts_dir)
          Compass.projectize(dir, pp)
        end
      end

      def default_extensions_path
        if (pp = top_level.project_path) && (dir = top_level.extensions_dir)
          Compass.projectize(dir, pp)
        end
      end

      def default_fonts_path
        if (pp = top_level.project_path) && (dir = top_level.fonts_dir)
          Compass.projectize(dir, pp)
        end
      end

      def default_cache_dir
        ".sass-cache"
      end

      def default_cache_path
        if (pp = top_level.project_path) && (dir = top_level.cache_dir_without_default)
          Compass.projectize(dir, pp)
        # TODO We should make Sass::Plugin.options a configuration source instead of
        # TODO one-offing it like this.
        elsif defined?(Sass::Plugin) && Sass::Plugin.options[:cache_location]
          File.expand_path(Sass::Plugin.options[:cache_location])
        elsif (pp = top_level.project_path) && (dir = top_level.cache_dir)
          Compass.projectize(dir, pp)
        end
      end

      def default_generated_images_dir
        top_level.images_dir
      end

      def default_http_generated_images_dir
        top_level.http_images_dir
      end

      def default_http_images_dir
        top_level.images_dir
      end

      def default_sprite_load_path
        [top_level.images_path]
      end

      def default_http_images_path
        http_root_relative top_level.http_images_dir
      end

      def default_http_stylesheets_dir
        top_level.css_dir
      end

      def default_http_stylesheets_path
        http_root_relative top_level.http_stylesheets_dir
      end

      def default_http_generated_images_path
        http_root_relative top_level.http_generated_images_dir
      end

      def default_http_fonts_dir
        top_level.fonts_dir
      end

      def default_http_fonts_path
        http_root_relative top_level.http_fonts_dir
      end

      def default_http_javascripts_dir
        top_level.javascripts_dir
      end

      def default_http_javascripts_path
        http_root_relative top_level.http_javascripts_dir
      end

      def default_cache
        true
      end

      def default_preferred_syntax
        :scss
      end

      def default_sprite_engine
        :chunky_png
      end

      def default_chunky_png_options
        if defined?(::Zlib)
          {:compression => Zlib::BEST_COMPRESSION}
        else
          {}
        end
      end

      # helper functions

      def http_join(*segments)
        segments.map do |segment|
          next unless segment
          segment = http_pathify(segment)
          segment[-1..-1] == "/" ? segment[0..-2] : segment
        end.join("/")
      end

      def http_pathify(path)
        if File::SEPARATOR == "/"
          path
        else
          path.gsub(File::SEPARATOR, "/")
        end
      end

      def http_root_relative(path)
        http_join top_level.http_path, path
      end
    end
  end
end
