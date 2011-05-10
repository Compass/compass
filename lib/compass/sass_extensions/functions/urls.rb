module Compass::SassExtensions::Functions::Urls

  def stylesheet_url(path, only_path = Sass::Script::Bool.new(false))
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
      Sass::Script::String.new(clean_path(path))
    else
      clean_url(path)
    end
  end
  Sass::Script::Functions.declare :stylesheet_url, [:path]
  Sass::Script::Functions.declare :stylesheet_url, [:path, :only_path]

  def font_url(path, only_path = Sass::Script::Bool.new(false))
    path = path.value # get to the string value of the literal.

    # Short curcuit if they have provided an absolute url.
    if absolute_path?(path)
      return Sass::Script::String.new("url(#{path})")
    end

    # Compute the path to the font file, either root relative or stylesheet relative
    # or nil if the http_fonts_path cannot be determined from the configuration.
    http_fonts_path = if relative?
                        compute_relative_path(Compass.configuration.fonts_path)
                      else
                        Compass.configuration.http_fonts_path
                      end

    path = "#{http_fonts_path}/#{path}"

    if only_path.to_bool
      Sass::Script::String.new(clean_path(path))
    else
      clean_url(path)
    end
  end
  Sass::Script::Functions.declare :font_url, [:path]
  Sass::Script::Functions.declare :font_url, [:path, :only_path]

  def image_url(path, only_path = Sass::Script::Bool.new(false), cache_buster = Sass::Script::Bool.new(true))
    path = path.value # get to the string value of the literal.

    if path =~ %r{^#{Regexp.escape(Compass.configuration.http_images_path)}/(.*)}
      # Treat root relative urls (without a protocol) like normal if they start with
      # the images path.
      path = $1
    elsif absolute_path?(path)
      # Short curcuit if they have provided an absolute url.
      return Sass::Script::String.new("url(#{path})")
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
    real_path = if Compass.configuration.images_dir
      File.join(Compass.configuration.project_path, Compass.configuration.images_dir, path)
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
      if cache_buster.is_a?(Sass::Script::String)
        path += "?#{cache_buster.value}"
      else
        path = cache_busted_path(path, real_path)
      end
    end

    # prepend the asset host if there is one.
    path = "#{asset_host}#{'/' unless path[0..0] == "/"}#{path}" if asset_host

    if only_path.to_bool
      Sass::Script::String.new(clean_path(path))
    else
      clean_url(path)
    end
  end
  Sass::Script::Functions.declare :image_url, [:path]
  Sass::Script::Functions.declare :image_url, [:path, :only_path]
  Sass::Script::Functions.declare :image_url, [:path, :only_path, :cache_buster]

  private

  # Emits a path, taking off any leading "./"
  def clean_path(url)
    url = url.to_s
    url = url[0..1] == "./" ? url[2..-1] : url
  end

  # Emits a url, taking off any leading "./"
  def clean_url(url)
    Sass::Script::String.new("url('#{clean_path(url)}')")
  end

  def relative?
    Compass.configuration.relative_assets?
  end

  def absolute_path?(path)
    path[0..0] == "/" || path[0..3] == "http"
  end

  def compute_relative_path(path)
    if (target_css_file = options[:css_filename])
      Pathname.new(path).relative_path_from(Pathname.new(File.dirname(target_css_file))).to_s
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
      "%s?%s" % [path, cache_buster[:query]]
    else
      path
    end
  end

  def compute_cache_buster(path, real_path)
    if Compass.configuration.asset_cache_buster
      args = [path]
      if Compass.configuration.asset_cache_buster.arity > 1
        args << (File.new(real_path) if real_path)
      end
      Compass.configuration.asset_cache_buster.call(*args)
    elsif real_path
      default_cache_buster(path, real_path)
    end
  end

  def default_cache_buster(path, real_path)
    if File.readable?(real_path)
      File.mtime(real_path).to_i.to_s
    else
      $stderr.puts "WARNING: '#{File.basename(path)}' was not found (or cannot be read) in #{File.dirname(real_path)}"
    end
  end

end
