class Compass::Core::AssetUrlResolver
  include Compass::Core::HTTPUtil

  class AssetNotFound < Sass::SyntaxError
    def initialize(type, path, asset_collections)
      asset_search_paths = asset_collections.map{|ac| ac.send(:"#{type}s_path") }
      super("Could not find #{path} in #{ asset_search_paths.join(", ")}")
    end
  end

  attr_accessor :asset_collections
  attr_accessor :configuration

  def initialize(asset_collections, configuration = nil)
    @configuration = configuration || Compass.configuration
    @asset_collections = asset_collections.dup
    unless @asset_collections.find {|ac| Compass::Configuration::DefaultAssetCollection === ac }
      @asset_collections.unshift(Compass::Configuration::DefaultAssetCollection.new)
    end
    if configuration
      @asset_collections.each {|ac| ac.configuration = configuration }
    end
  end

  # Compute a url for a given asset type (:image or :font)
  def compute_url(type, relative_path, relative_to_css_url = nil, use_cache_buster = true)
    # pass through fully specified urls
    return relative_path if relative_path.start_with?("http://")

    # If the image has an target reference, remove it (Common with SVG)
    clean_relative_path, target = relative_path.split("#", 2)

    # If the image has a query, remove it
    clean_relative_path, query = clean_relative_path.split("?", 2)

    # Get rid of silliness in the url
    clean_relative_path = expand_url_path(clean_relative_path)

    # Find the asset collection that includes this asset
    asset_collection, clean_relative_path, real_path = find_collection(type, clean_relative_path)

    # Didn't find the asset, but it's a full url so just return it.
    return relative_path if asset_collection.nil? && relative_path.start_with?("/")

    # Raise an error for relative paths if we didn't find it on the search path.
    raise AssetNotFound.new(type, relative_path, @asset_collections) unless asset_collection

    # Make a root-relative url (starting with /)
    asset_url = url_join(asset_collection.send(:"http_#{type}s_path"), clean_relative_path)

    # Compute asset cache buster
    busted_path, busted_query = cache_buster(asset_collection, asset_url, real_path) if use_cache_buster
    asset_url = busted_path if busted_path
    query = [query, busted_query].compact.join("&") if busted_query

    # Convert path to a relative url if a css file is specified.
    relative_url = compute_relative_path(relative_to_css_url, asset_url) if relative_to_css_url

    # Compute asset host when not relative and one is provided
    asset_host = if asset_collection.asset_host && relative_url.nil?
                   asset_collection.asset_host.call(asset_url) 
                 end

    # build the full url
    url = url_join(asset_host || "", relative_url || asset_url)
    url << "?" if query
    url << query if query
    url << "#" if target
    url << target if target
    return url
  end

  protected

  def find_collection(type, relative_path)
    asset_collection = nil
    clean_relative_path = nil
    absolute_path = nil
    @asset_collections.each do |ac|
      cp, ap = ac.send(:"includes_#{type}?", relative_path)
      if ap 
        asset_collection = ac
        absolute_path = ap
        clean_relative_path = cp
        break
      end
    end
    [asset_collection, clean_relative_path, absolute_path]
  end

  def absolute_path?(path)
    path[0..0] == "/" || path[0..3] == "http"
  end

  def cache_buster(asset_collection, path, real_path)
    cache_buster = compute_cache_buster(asset_collection, path, real_path)
    return [path, nil] if cache_buster.nil?
    cache_buster = {:query => cache_buster} if cache_buster.is_a?(String)
    [cache_buster[:path] || path, cache_buster[:query]]
  end
  

  def compute_cache_buster(asset_collection, path, real_path)
    file = nil
    if asset_collection.asset_cache_buster == :none
      nil
    elsif asset_collection.asset_cache_buster
      args = [path]
      if asset_collection.asset_cache_buster.arity > 1
        file = File.new(real_path)
        args << file
      end
      asset_collection.asset_cache_buster.call(*args)
    else
      default_cache_buster(path, real_path)
    end
  ensure
    file.close if file
  end

  def default_cache_buster(path, real_path)
    if File.readable?(real_path)
      File.mtime(real_path).to_i.to_s
    else
      Compass::Util.compass_warn("WARNING: '#{real_path}' cannot be read.")
      nil
    end
  end

end
