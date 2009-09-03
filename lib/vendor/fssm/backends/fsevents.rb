require 'fssm/fsevents'

module FSSM::Backends
  class FSEvents
    def initialize
      @handlers = {}
      @fsevents = []
    end
    
    def add_path(path, preload=true)
      handler = FSSM::State.new(path, preload)
      @handlers["#{path}"] = handler
      
      fsevent = Rucola::FSEvents.new("#{path}") do |events|
        events.each do |event|
          handler.refresh(event.path)
        end
      end
      
      fsevent.create_stream
      fsevent.start
      @fsevents << fsevent
    end
    
    def run
      begin
        OSX.CFRunLoopRun
      rescue Interrupt
        @fsevents.each do |fsev|
          fsev.stop
        end
      end
    end

  end
end
