class Pathname
  class << self
    def for(path)
      path.is_a?(Pathname) ? path : new(path)
    end
  end
end
