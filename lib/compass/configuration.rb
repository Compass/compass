module Compass
  module Configuration

    ATTRIBUTES = [
      :project_type,
      :project_path,
      :css_dir,
      :sass_dir,
      :images_dir,
      :javascripts_dir,
      :extensions_dir,
      :css_path,
      :sass_path,
      :images_path,
      :javascripts_path,
      :extensions_path,
      :http_path,
      :http_images_dir,
      :http_stylesheets_dir,
      :http_javascripts_dir,
      :http_images_path,
      :http_stylesheets_path,
      :http_javascripts_path,
      :output_style,
      :environment,
      :relative_assets,
      :additional_import_paths,
      :sass_options,
      :asset_host,
      :asset_cache_buster
    ]

  end
end

['adapters', 'comments', 'defaults', 'helpers', 'inheritance', 'serialization', 'data'].each do |lib|
  require File.join(File.dirname(__FILE__), 'configuration', lib)
end
