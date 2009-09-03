class Pathname
  class << self
    def for(path)
      path.is_a?(Pathname) ? path : new(path)
    end
  end

  def names
    prefix, names = split_names(@path)
    names
  end
end
