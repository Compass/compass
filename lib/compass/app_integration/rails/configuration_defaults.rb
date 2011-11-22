module Compass
  module AppIntegration
    module Rails

      module ConfigurationDefaultsWithAssetPipeline
        # These methods overwrite the old rails defaults
        # when rails 3.1 is detected.

        def default_sass_dir
          File.join("app", "assets", "stylesheets")
        end

        def default_images_dir
          File.join("app", "assets", "images")
        end

        def default_fonts_dir
          File.join("app", "assets", "fonts")
        end

        def default_javascripts_dir
          File.join("app", "assets", "javascripts")
        end

        def default_http_path
          ::Rails.application.config.assets.prefix
        end

        def default_http_images_path
          "#{top_level.http_path}"
        end

        def default_http_generated_images_path
          "#{top_level.http_path}"
        end

        def default_http_javascripts_path
          "#{top_level.http_path}"
        end

        def default_http_fonts_path
          "#{top_level.http_path}"
        end

        def default_http_stylesheets_path
          "#{top_level.http_path}"
        end
      end

      module ConfigurationDefaults

        def project_type_without_default
          :rails
        end

        def default_sass_dir
          File.join("app", "stylesheets")
        end

        def default_css_dir
          File.join("public", "stylesheets")
        end

        def default_images_dir
          File.join("public", "images")
        end

        def default_fonts_dir
          File.join("public", "fonts")
        end

        def default_javascripts_dir
          File.join("public", "javascripts")
        end

        def default_http_images_path
          # Relies on the fact that this will be loaded after the "normal"
          # defaults, so that method_missing finds http_root_relative
          http_root_relative "images"
        end

        def default_http_javascripts_path
          http_root_relative "javascripts"
        end

        def default_http_fonts_path
          http_root_relative "fonts"
        end

        def default_http_stylesheets_path
          http_root_relative "stylesheets"
        end

        def default_extensions_dir
          File.join("vendor", "plugins", "compass_extensions")
        end

        def default_cache_dir
          File.join("tmp", "sass-cache")
        end

        def default_project_path
          project_path = Compass::AppIntegration::Rails.root
        end

        def default_http_path
          "/" # XXX Where is/was this stored in the Rails config?
        end

        def default_environment
          Compass::AppIntegration::Rails.env
        end

      end
    end
  end
end
