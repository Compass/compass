class Nanoc3::Site
  def cached(key)
    if cached_stuff.has_key?(key)
      cached_stuff[key]
    else
      cached_stuff[key]= yield
    end
  end
  def cached_stuff
    @cached_stuff ||= {}
  end
end
