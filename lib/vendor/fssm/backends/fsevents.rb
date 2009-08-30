module FSSM::Backends
  class FSEvents    
    def initialize(options={})
      @streams   = []
      @handlers  = {}
      @allocator = options[:allocator] || OSX::KCFAllocatorDefault
      @context   = options[:context]   || nil
      @since     = options[:since]     || OSX::KFSEventStreamEventIdSinceNow
      @latency   = options[:latency]   || 0.0
      @flags     = options[:flags]     || 0
    end
    
    def add_path(path, preload=true)
      @handlers["#{path}"] = FSSM::State.new(path, preload)
      
      cb = lambda do |stream, context, number, paths, flags, ids|
        paths.regard_as('*')
        watched = OSX.FSEventStreamCopyPathsBeingWatched(stream).first
        @handlers["#{watched}"].refresh
        # TODO: support this level of granularity
        # number.times do |n|
        #   @handlers["#{watched}"].refresh_path(paths[n])
        # end
      end
      
      @streams << create_stream(cb, "#{path}")
    end
    
    def run
      @streams.each do |stream|
        schedule_stream(stream)
        start_stream(stream)
      end
      
      begin
        OSX.CFRunLoopRun
      rescue Interrupt
        @streams.each do |stream|
          stop_stream(stream)
          invalidate_stream(stream)
          release_stream(stream)
        end
      end
      
    end
    
    private
    
    def create_stream(callback, paths)
      paths = [paths] unless paths.is_a?(Array)
      OSX.FSEventStreamCreate(@allocator, callback, @context, paths, @since, @latency, @flags)
    end
    
    def schedule_stream(stream, options={})
      run_loop  = options[:run_loop]  || OSX.CFRunLoopGetCurrent
      loop_mode = options[:loop_mode] || OSX::KCFRunLoopDefaultMode
      
      OSX.FSEventStreamScheduleWithRunLoop(stream, run_loop, loop_mode)
    end
    
    def start_stream(stream)
      OSX.FSEventStreamStart(stream)
    end
    
    def stop_stream(stream)
      OSX.FSEventStreamStop(stream)
    end
    
    def invalidate_stream(stream)
      OSX.FSEventStreamInvalidate(stream)
    end
    
    def release_stream(stream)
      OSX.FSEventStreamRelease(stream)
    end
    
  end
end
