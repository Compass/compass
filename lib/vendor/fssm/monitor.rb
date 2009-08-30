class FSSM::Monitor
  def initialize(options={})
    @options = options
    @backend = FSSM::Backends::Default.new
  end
  
  def path(*args, &block)
    path = FSSM::Path.new(*args)
    if block && block.arity == 0
      path.instance_eval(&block)
    elsif block && block.arity == 1
      block.call(path)
    end
    @backend.add_path(path)
    path
  end
  
  def run
    @backend.run
  end
end
