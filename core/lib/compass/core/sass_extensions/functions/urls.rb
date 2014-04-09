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
      # Compute the path to the stylesheet, either root relative or stylesheet relative
      # or nil if the http_images_path is not set in the configuration.
      http_stylesheets_path = if relative?
        compute_relative_path(Compass.configuration.css_path)
      elsif Compass.configuration.http_stylesheets_path
        Compass.configuration.http_stylesheets_path
      else
        Compass.configuration.http_root_relative(Compass.configuration.css_dir)
      end

      path = "#{http_stylesheets_path}/#{path.value}"
      if only_path.to_bool
        unquoted_string(clean_path(path))
      else
        clean_url(path)
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
      path = path.value # get to the string value of the literal.

      # Short curcuit if they have provided an absolute url.
      if absolute_path?(path)
        return unquoted_string("url(#{path})")
      end

      # Compute the path to the font file, either root relative or stylesheet relative
      # or nil if the http_fonts_path cannot be determined from the configuration.
      http_fonts_path = if relative?
                          compute_relative_path(Compass.configuration.fonts_path)
                        else
                          Compass.configuration.http_fonts_path
                        end

      # Compute the real path to the font on the file system if the fonts_dir is set.
      real_path = if Compass.configuration.fonts_dir
        File.join(Compass.configuration.fonts_path, path.gsub(/[?#].*$/,""))
      end

      # prepend the path to the font if there's one
      if http_fonts_path
        http_fonts_path = "#{http_fonts_path}/" unless http_fonts_path[-1..-1] == "/"
        path = "#{http_fonts_path}#{path}"
      end

      # Compute the asset host unless in relative mode.
      asset_host = if !relative? && Compass.configuration.asset_host
        Compass.configuration.asset_host.call(path)
      end

      # Compute and append the cache buster if there is one.
      if cache_buster.to_bool
        path, anchor = path.split("#", 2)
        if cache_buster.is_a?(Sass::Script::Value::String)
          path += "#{path["?"] ? "&" : "?"}#{cache_buster.value}"
        else
          path = cache_busted_path(path, real_path)
        end
        path = "#{path}#{"#" if anchor}#{anchor}"
      end

      # prepend the asset host if there is one.
      path = "#{asset_host}#{'/' unless path[0..0] == "/"}#{path}" if asset_host

      if only_path.to_bool
        unquoted_string(clean_path(path))
      else
        clean_url(path)
      end
    end
  end

  module ImageUrl
    def self.included(base)
      if base.respond_to?(:declare)
        base.declare :image_url,      [:path]
        base.declare :image_url,      [:path, :only_path]
        base.declare :image_url,      [:path, :only_path, :cache_buster]
      end
    end
    def image_url(path, only_path = bool(false), cache_buster = bool(true))
      path = path.value # get to the string value of the literal.

      if path =~ %r{^#{Regexp.escape(Compass.configuration.http_images_path)}/(.*)}
        # Treat root relative urls (without a protocol) like normal if they start with
        # the images path.
        path = $1
      elsif absolute_path?(path)
        # Short curcuit if they have provided an absolute url.
        return unquoted_string("url(#{path})")
      end

      # Compute the path to the image, either root relative or stylesheet relative
      # or nil if the http_images_path is not set in the configuration.
      http_images_path = if relative?
        compute_relative_path(Compass.configuration.images_path)
      elsif Compass.configuration.http_images_path
        Compass.configuration.http_images_path
      else
        Compass.configuration.http_root_relative(Compass.configuration.images_dir)
      end

      # Compute the real path to the image on the file stystem if the images_dir is set.
      real_path = if Compass.configuration.images_path
        File.join(Compass.configuration.images_path, path.gsub(/#.*$/,""))
      else
        File.join(Compass.configuration.project_path, path.gsub(/#.*$/,""))
      end

      # prepend the path to the image if there's one
      if http_images_path
        http_images_path = "#{http_images_path}/" unless http_images_path[-1..-1] == "/"
        path = "#{http_images_path}#{path}"
      end

      # Compute the asset host unless in relative mode.
      asset_host = if !relative? && Compass.configuration.asset_host
        Compass.configuration.asset_host.call(path)
      end

      # Compute and append the cache buster if there is one.
      if cache_buster.to_bool
        path, anchor = path.split("#", 2)
        if cache_buster.is_a?(Sass::Script::Value::String)
          path += "#{path["?"] ? "&" : "?"}#{cache_buster.value}"
        else
          path = cache_busted_path(path, real_path)
        end
        path = "#{path}#{"#" if anchor}#{anchor}"
      end

      # prepend the asset host if there is one.
      path = "#{asset_host}#{'/' unless path[0..0] == "/"}#{path}" if asset_host

      if only_path.to_bool
        unquoted_string(clean_path(path))
      else
        clean_url(path)
      end
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
      path = path.value # get to the string value of the literal.

      if path =~ %r{^#{Regexp.escape(Compass.configuration.http_generated_images_path)}/(.*)}
        # Treat root relative urls (without a protocol) like normal if they start with
        # the generated_images path.
        path = $1
      elsif absolute_path?(path)
        # Short curcuit if they have provided an absolute url.
        return unquoted_string("url(#{path})")
      end

      # Compute the path to the image, either root relative or stylesheet relative
      # or nil if the http_generated_images_path is not set in the configuration.
      http_generated_images_path = if relative?
        compute_relative_path(Compass.configuration.generated_images_path)
      elsif Compass.configuration.http_generated_images_path
        Compass.configuration.http_generated_images_path
      else
        Compass.configuration.http_root_relative(Compass.configuration.generated_images_dir)
      end

      # Compute the real path to the image on the file stystem if the generated_images_dir is set.
      real_path = if Compass.configuration.generated_images_path
        File.join(Compass.configuration.generated_images_path, path.gsub(/#.*$/,""))
      else
        File.join(Compass.configuration.project_path, path.gsub(/#.*$/,""))
      end

      # prepend the path to the image if there's one
      if http_generated_images_path
        http_generated_images_path = "#{http_generated_images_path}/" unless http_generated_images_path[-1..-1] == "/"
        path = "#{http_generated_images_path}#{path}"
      end

      # Compute the asset host unless in relative mode.
      asset_host = if !relative? && Compass.configuration.asset_host
        Compass.configuration.asset_host.call(path)
      end

      # Compute and append the cache buster if there is one.
      if cache_buster.to_bool
        path, anchor = path.split("#", 2)
        if cache_buster.is_a?(Sass::Script::Value::String)
          path += "#{path["?"] ? "&" : "?"}#{cache_buster.value}"
        else
          path = cache_busted_path(path, real_path)
        end
        path = "#{path}#{"#" if anchor}#{anchor}"
      end

      # prepend the asset host if there is one.
      path = "#{asset_host}#{'/' unless path[0..0] == "/"}#{path}" if asset_host

      clean_url(path)
    end
  end

  private

  # Emits a path, taking off any leading "./"
  def clean_path(url)
    url = url.to_s
    url = url[0..1] == "./" ? url[2..-1] : url
  end

  # Emits a url, taking off any leading "./"
  def clean_url(url)
    unquoted_string("url('#{clean_path(url)}')")
  end

  def relative?
    Compass.configuration.relative_assets?
  end

  def absolute_path?(path)
    path[0..0] == "/" || path[0..3] == "http"
  end

  def compute_relative_path(path)
    if (target_css_file = options[:css_filename])
      target_path = Pathname.new(File.expand_path(path))
      source_path = Pathname.new(File.dirname(File.expand_path(target_css_file)))
      target_path.relative_path_from(source_path).to_s
    end
  end

  def cache_busted_path(path, real_path)
    cache_buster = compute_cache_buster(path, real_path)
    if cache_buster.nil?
      return path
    elsif cache_buster.is_a?(String)
      cache_buster = {:query => cache_buster}
    else
      path = cache_buster[:path] if cache_buster[:path]
    end
    
    if cache_buster[:query]
      "#{path}#{path["?"] ? "&" : "?"}#{cache_buster[:query]}"
    else
      path
    end
  end

  def compute_cache_buster(path, real_path)
    file = nil
    if Compass.configuration.asset_cache_buster
      args = [path]
      if Compass.configuration.asset_cache_buster.arity > 1
        begin
          file = File.new(real_path) if real_path
        rescue Errno::ENOENT
          # pass
        end
        args << file
      end
      Compass.configuration.asset_cache_buster.call(*args)
    elsif real_path
      default_cache_buster(path, real_path)
    end
  ensure
    file.close if file
  end

  def default_cache_buster(path, real_path)
    if File.readable?(real_path)
      File.mtime(real_path).to_i.to_s
    else
      $stderr.puts "WARNING: '#{File.basename(path)}' was not found (or cannot be read) in #{File.dirname(real_path)}"
    end
  end

end
