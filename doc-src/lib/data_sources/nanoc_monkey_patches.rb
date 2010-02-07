class Nanoc3::Site
  def cached(key)
    if cache.has_key?(key)
      cache[key]
    else
      cache[key]= yield
    end
  end
  def cache
    @cache ||= {}
  end
end
