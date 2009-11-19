class FSSM::State
  def initialize(path, preload=true)
    @path = path
    @snapshot = {}
    snapshot if preload
  end
  
  def refresh
    previous = @snapshot
    current = snapshot
    
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
  
  def snapshot
    snap = {}
    @path.glob.each {|glob| add_glob(snap, glob)}
    @snapshot = snap
  end
  
  def add_glob(snap, glob)
    Pathname.glob(@path.to_pathname.join(glob).to_s).each do |fn|
      next unless fn.file?
      snap["#{fn}"] = fn.mtime
    end
  end
  
end
