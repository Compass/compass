module Compass
  module AppIntegration
    module WordPress
      module ConfigurationDefaults
        def default_project_type
          :word_press
        end

        def sass_dir_without_default
          "sass"
        end

        def javascripts_dir_without_default
          "js"
        end

        def css_dir_without_default
          "."
        end

        def images_dir_without_default
          "images"
        end

        def default_cache_dir
          ".sass-cache"
        end
      end

    end
  end
end
