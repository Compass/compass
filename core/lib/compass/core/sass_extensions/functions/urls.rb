module Compass::Core::SassExtensions::Functions::Urls


  def self.has?(base, instance_method)
    Sass::Util.has?(:instance_method, base, instance_method)
  end

  def self.included(base)
    base.send(:include, StylesheetUrl) unless has?(base, :stylesheet_url)
    base.send(:include, FontUrl) unless has?(base, :font_url)
    base.send(:include, ImageUrl) unless has?(base, :image_url)
    base.send(:include, GeneratedImageUrl) unless has?(base, :generated_image_url)
  end

  module StylesheetUrl
    def self.included(base)
      if base.respond_to?(:declare)
        base.declare :stylesheet_url, [:path]
        base.declare :stylesheet_url, [:path, :only_path]
      end
    end
    def stylesheet_url(path, only_path = bool(false))
      url = url_join(Compass.configuration.http_stylesheets_path, path.value)
      if Compass.configuration.relative_assets?
        url = compute_relative_path(current_css_url_path, url)
      end

      if only_path.to_bool
        unquoted_string(expand_url_path(url))
      else
        unquoted_string("url('#{expand_url_path(url)}')")
      end
    end
  end

  module FontUrl
    def self.included(base)
      if base.respond_to?(:declare)
        base.declare :font_url,       [:path]
        base.declare :font_url,       [:path, :only_path]
        base.declare :font_url,       [:path, :only_path, :cache_buster]
      end
    end
    def font_url(path, only_path = bool(false), cache_buster = bool(true))
      resolve_asset_url(:font, path, only_path, cache_buster)
    end
  end

  module ImageUrl
    include Compass::Core::HTTPUtil
    def self.included(base)
      if base.respond_to?(:declare)
        base.declare :image_url,      [:path]
        base.declare :image_url,      [:path, :only_path]
        base.declare :image_url,      [:path, :only_path, :cache_buster]
      end
    end
    def image_url(path, only_path = bool(false), cache_buster = bool(true))
      resolve_asset_url(:image, path, only_path, cache_buster)
    end
  end

  module GeneratedImageUrl
    def self.included(base)
      if base.respond_to?(:declare)
        base.declare :generated_image_url, [:path]
        base.declare :generated_image_url, [:path, :cache_buster]
      end
    end
    def generated_image_url(path, cache_buster = bool(false))
      resolve_asset_url(:generated_image, path, bool(false), cache_buster)
    end
  end

  private

  def current_css_url_path
    if options[:css_filename] && options[:css_filename].start_with?("#{Compass.configuration.css_path}/")
      url_join(Compass.configuration.http_stylesheets_path, options[:css_filename][(Compass.configuration.css_path.size + 1)..-1])
    end
  end

  def resolve_asset_url(type, path, only_path, cache_buster)
    path = path.value # get to the string value of the literal.
    css_file = current_css_url_path if Compass.configuration.relative_assets?
    url = Compass.configuration.url_resolver.compute_url(type, path, css_file, cache_buster.to_bool)
    if only_path.to_bool
      unquoted_string(url)
    else
      unquoted_string("url('#{url}')")
    end
  end
end
