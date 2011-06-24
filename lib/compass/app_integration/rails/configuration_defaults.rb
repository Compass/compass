module Compass
  module AppIntegration
    module Rails

      module ConfigurationDefaultsWithAssetPipeline
        # These methods overwrite the old rails defaults
        # when rails 3.1 is detected.

        # Assets dir is configurable, but rails doesn't provide the default
        def default_assets_dir
          ::Rails.application.config.assets.assets_dir.presence || File.join("app", "assets")
        end

        # These two have special case overrides:

        def default_sass_dir
          ::Rails.application.config.assets.stylesheets_dir.presence || File.join(default_assets_dir, "stylesheets")
        end

        def default_javascripts_dir
          ::Rails.application.config.assets.javascripts_dir.presence || File.join(default_assets_dir, "javascripts")
        end

        # These two are just conventions:

        def default_images_dir
          File.join(default_assets_dir, "images")
        end

        def default_fonts_dir
          File.join(default_assets_dir, "fonts")
        end

        # For HTTP paths, everything is now overlaid and served from the assets path

        def default_http_assets_path
          # XXX: Should this take asset_host into account?
          ::Rails.application.config.assets.prefix
        end

        # These are all cascaded in the asset pipeline
        alias default_http_images_path default_http_assets_path
        alias default_http_javascripts_path default_http_assets_path
        alias default_http_fonts_path default_http_assets_path
        alias default_http_stylesheets_path default_http_assets_path

        # Use Sprockets to figure out paths to assets:

        def asset_paths
          @asset_paths ||= Sprockets::Helpers::RailsHelper::AssetPaths.new ::Rails.application.config.action_controller, nil
        end

        # These use the sprockets helpers:
        def http_font_path source
          asset_paths.compute_public_path(source, 'fonts')
        end

        def http_image_path source
          asset_paths.compute_public_path(source, 'images')
        end

        def http_javascript_path source
          asset_paths.compute_public_path(source, 'javascripts')
        end

        def http_stylesheet_path source
          asset_paths.compute_public_path(source, 'stylesheets')
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
          "#{top_level.http_path}images"
        end

        def default_http_javascripts_path
          "#{top_level.http_path}javascripts"
        end

        def default_http_fonts_path
          "#{top_level.http_path}fonts"
        end

        def default_http_stylesheets_path
          "#{top_level.http_path}stylesheets"
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
