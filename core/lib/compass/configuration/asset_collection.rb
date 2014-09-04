class Compass::Configuration::AbstractAssetCollection
  include Compass::Core::HTTPUtil

  attr_writer :configuration

  def configuration
    @configuration || Compass.configuration
  end

  def as_filesystem_path(url_path)
    if File::SEPARATOR == '/'
      url_path
    else
      relative_path = url_path.gsub(%r{/}, File::SEPARATOR)
    end
  end

  def globs?(type, glob)
    # Treat root relative urls (without a protocol) like normal if they start with  the images path.
    asset_http_path = send(:"http_#{type}s_path")
    if glob.start_with?("#{asset_http_path}/")
      glob = glob[(asset_http_path.size + 1)..-1]
    end
    fs_glob = as_filesystem_path(glob)
    absolute_glob = File.join(send(:"#{type}s_path"), fs_glob)
    resolved_files = Dir.glob(absolute_glob)
    if resolved_files.any?
      [glob, resolved_files]
    else
      nil
    end

  end

  def includes_image?(relative_path)
    # Treat root relative urls (without a protocol) like normal if they start with  the images path.
    if relative_path.start_with?("#{http_images_path}/")
      relative_path = relative_path[(http_images_path.size + 1)..-1]
    end
    fs_relative_path = as_filesystem_path(relative_path)
    absolute_path = File.join(images_path, fs_relative_path)
    if File.exists?(absolute_path)
      [relative_path, absolute_path]
    else
      nil
    end
  end

  def includes_font?(relative_path)
    # Treat root relative urls (without a protocol) like normal if they start with  the fonts path.
    if relative_path.start_with?("#{http_fonts_path}/")
      relative_path = relative_path[(http_fonts_path.size + 1)..-1]
    end
    fs_relative_path = as_filesystem_path(relative_path)
    absolute_path = File.join(fonts_path, fs_relative_path)
    if File.exists?(absolute_path)
      [relative_path, absolute_path]
    end
  end

  def includes_generated_image?(relative_path)
    nil
  end

  def root_path
    Sass::Util.abstract!
  end

  def http_path
    Sass::Util.abstract!
  end

  def sass_path
    Sass::Util.abstract!
  end

  def images_path
    Sass::Util.abstract!
  end

  def http_images_path
    Sass::Util.abstract!
  end

  def fonts_path
    Sass::Util.abstract!
  end

  def http_fonts_path
    Sass::Util.abstract!
  end

  def asset_host
    Sass::Util.abstract!
  end

  def asset_cache_buster
    Sass::Util.abstract!
  end
end

class Compass::Configuration::AssetCollection < Compass::Configuration::AbstractAssetCollection
  include Compass::Util

  attr_reader :options

  # @param options The paths to the asset collection.
  # @option :root_path The absolute path to the asset collection
  # @option :root_dir A relative path to the asset collection from the project path.
  # @option :http_path Web root location of assets in this collection.
  #   Starts with '/'.
  # @option :http_dir Web root location of assets in this collection.
  #   Relative to the project's `http_path`.
  # @option :sass_dir Sass directory to be added to the Sass import paths.
  #   Relative to the :root_path or :root_dir. Defaults to `sass`.
  # @option :fonts_dir Directory of fonts to be added to the font look up path.
  #   Relative to the :root_path or :root_dir. Defaults to `fonts`.
  # @option :http_fonts_dir Where to find fonts on the webserver relative to
  #   the http_path or http_dir. Defaults to <http_path>/<fonts_dir>.
  #   Can be overridden by setting :http_fonts_path.
  # @option :http_fonts_path Where to find fonts on the webserver.
  # @option :images_dir Directory of images to be added to the image look up path.
  #   Relative to the :root_path or :root_dir. Defaults to `images`.
  # @option :http_images_dir Where to find images on the webserver relative to
  #   the http_path or http_dir. Defaults to <http_path>/<images_dir>.
  #   Can be overridden by setting :http_images_path.
  # @option :http_images_path Where to find images on the webserver.
  # @option :asset_host A string starting with 'http://' for a single host,
  #   or a lambda or proc that will compute the asset host for assets in this collection.
  #   If :http_dir is set instead of http_path, this defaults to the project's asset_host.
  # @option :asset_cache_buster A string, :none, or
  #   or a lambda or proc that will compute the cache_buster for assets in this collection.
  #   If :http_dir is set instead of http_path, this defaults to the project's asset_cache_buster.
  def initialize(options, configuration = nil)
    assert_valid_keys(options, :root_path, :root_dir, :http_path, :http_dir, :sass_dir,
                               :fonts_dir, :http_fonts_dir, :http_fonts_path,
                               :images_dir, :http_images_dir, :http_images_path,
                               :asset_host, :asset_cache_buster)
    symbolize_keys!(options)
    unless options.has_key?(:root_path) || options.has_key?(:root_dir)
      raise ArgumentError, "Either :root_path or :root_dir must be specified."
    end
    unless options.has_key?(:http_path) || options.has_key?(:http_dir)
      raise ArgumentError, "Either :http_path or :http_dir must be specified."
    end
    @options = options
    @configuration = configuration
  end

  def root_path
    return @root_path if defined?(@root_path)
    @root_path = @options[:root_path] || File.join(configuration.project_path, @options[:root_dir])
    @root_path = File.expand_path(@root_path)
  end

  def http_path
    return @http_path if defined?(@http_path)
    @http_path = @options[:http_path] || url_join(configuration.http_path, @options[:http_dir])
  end

  def sass_path
    return @sass_path if defined?(@sass_path)
    @sass_path = if options[:sass_dir]
      File.expand_path File.join(root_path, options[:sass_dir])
    end
  end

  def images_path
    return @images_path if defined?(@images_path)
    @images_path = if options[:images_dir]
      File.expand_path File.join(root_path, options[:images_dir])
    end
  end

  def http_images_path
    return @http_images_path if defined?(@http_images_path)
    @http_images_path = if options[:http_images_path]
                          options[:http_images_path]
                        elsif options[:http_images_dir]
                          url_join(http_path, options[:http_images_dir])
                        elsif options[:images_dir]
                          url_join(http_path, options[:images_dir])
                        end
  end


  def fonts_path
    return @fonts_path if defined?(@fonts_path)
    @fonts_path = if options[:fonts_dir]
      File.expand_path File.join(root_path, options[:fonts_dir])
    end
  end

  def http_fonts_path
    return @http_fonts_path if defined?(@http_fonts_path)
    @http_fonts_path = if options[:http_fonts_path]
                         options[:http_fonts_path]
                       elsif options[:http_fonts_dir]
                         url_join(http_path, options[:http_fonts_dir])
                       elsif options[:fonts_dir]
                         url_join(http_path, options[:fonts_dir])
                       end
  end

  def asset_host
    return options[:asset_host] if options.has_key?(:asset_host)
    if options[:http_dir]
      configuration.asset_host
    end
  end

  def asset_cache_buster
    return options[:asset_cache_buster] if options.has_key?(:asset_cache_buster)
    if options[:http_dir]
      configuration.asset_cache_buster
    end
  end
end

class Compass::Configuration::DefaultAssetCollection < Compass::Configuration::AbstractAssetCollection
  def includes_generated_image?(relative_path)
    # Treat root relative urls (without a protocol) like normal if they start with  the images path.
    if relative_path.start_with?("#{http_generated_images_path}/")
      relative_path = relative_path[(http_generated_images_path.size + 1)..-1]
    end
    fs_relative_path = as_filesystem_path(relative_path)
    absolute_path = File.join(generated_images_path, fs_relative_path)
    if File.exists?(absolute_path)
      [relative_path, absolute_path]
    else
      nil
    end
  end

  def root_path
    configuration.project_path
  end

  def http_path
    configuration.http_path
  end

  def sass_path
    configuration.sass_path
  end

  def images_path
    configuration.images_path
  end

  def http_images_path
    configuration.http_images_path
  end

  def generated_images_path
    configuration.generated_images_path
  end

  def http_generated_images_path
    configuration.http_generated_images_path
  end

  def fonts_path
    configuration.fonts_path
  end

  def http_fonts_path
    configuration.http_fonts_path
  end

  def asset_host
    configuration.asset_host
  end

  def asset_cache_buster
    configuration.asset_cache_buster
  end
end
