module QuickCache

  # cache a value in memory for just a few seconds
  # This can speed up reads of values that change relatively infrequently
  # but might be read many times in a short burst of reads.
  def quick_cache(key, ttl = 1)
    @quick_cache ||= {}
    if @quick_cache[key] && @quick_cache[key].first > Time.now - ttl
      @quick_cache[key].last
    else
      (@quick_cache[key] = [Time.now, yield]).last
    end
  end

end
