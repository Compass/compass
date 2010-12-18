module Compass
  module AppIntegration
    module Rails
      module ConfigurationDefaults

        def project_type_without_default
          :rails
        end

        def default_sass_dir
          if Sass::Util.ap_geq?('3.1.0.beta')
            File.join("app", "assets", "stylesheets")
          else
            File.join("app", "stylesheets")
          end
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
          if Sass::Util.ap_geq?('3.1.0.beta')
            File.join("app", "assets", "javascripts")
          else
            File.join("public", "javascripts")
          end
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
