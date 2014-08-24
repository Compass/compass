module Compass::Core::HTTPUtil
  # like File#join, but always uses '/' instead of File::SEPARATOR
  def url_join(*args)
    args.inject("") do |m, a|
      m << "/" unless m.end_with?('/') || a.start_with?('/') if m.length > 0
      m.gsub!(%r{/+$}, '') if a.start_with?('/')
      m << a
    end
  end

  # Eliminates parent directory references (E.g. "..") and
  # self directory references references (E.g. ".") from urls.
  # Removes any duplicated separators (E.g. //)
  # path should not include the protol, host, query param or target.
  def expand_url_path(url)
    # We remove the leading path otherwise we think there's an extra segment that can be removed
    prefix = "/" if url.start_with?("/")
    segments = url.gsub(%r{//+}, '/').split("/")
    segments.shift if prefix
    segments.push("") if url.end_with?("/")
    segments.reverse!
    result_segments = []
    parent_count = 0
    segments.each do |segment|
      if segment == ".."
        parent_count += 1
      elsif segment == "."
        # skip it
      elsif parent_count > 0
        parent_count -= 1
      else
        result_segments << segment
      end
    end
    if parent_count > 0
      raise ArgumentError, "Invalid URL: #{url} (not enough parent directories)"
    end
    result_segments.reverse!
    prefix.to_s + result_segments.join("/")
  end

  # Compute a relative path from one url to another
  # the urls should be only the path component (no host, query, or target)
  def compute_relative_path(from_url, to_url)
    from_components = expand_url_path(from_url).split("/")
    from_components.pop # drop the filename from the source
    to_components = expand_url_path(to_url).split("/")
    to_base = to_components.pop
    while from_components.first == to_components.first
      break if from_components.empty?
      from_components.shift
      to_components.shift
    end

    ([".."] * from_components.size + to_components + [to_base]).join("/")
  end
end
