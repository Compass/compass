require 'yaml'
class FSSM::State
  def initialize(path, preload=true)
    @path = path
    @cache = FSSM::Cache.new
    snapshot(@path.to_pathname) if preload
  end

  def refresh(base=nil)
    previous, current = recache(base || @path.to_pathname)

    deleted(previous, current)
    created(previous, current)
    modified(previous, current)
  end

  private

  def created(previous, current)
    (current.keys - previous.keys).each {|created| @path.create(created)}
  end

  def deleted(previous, current)
    (previous.keys - current.keys).each {|deleted| @path.delete(deleted)}
  end

  def modified(previous, current)
    (current.keys & previous.keys).each do |file|
      @path.update(file) if (current[file] <=> previous[file]) != 0
    end
  end

  def recache(base)
    base = Pathname.for(base)
    previous = @cache.files
    snapshot(base)
    current = @cache.files
    [previous, current]
  end

  def snapshot(base)
    base = Pathname.for(base)
    @cache.unset(base)
    @path.glob.each {|glob| add_glob(base, glob)}
  end

  def add_glob(base, glob)
    Pathname.glob(base.join(glob)).each do |fn|
      @cache.set(fn)
    end
  end

end
