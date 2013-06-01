require 'thread'
require 'forwardable'
module Compass
  class CompilerCache

    # This class is passed into a compiler instance to allow in memory caching of objects at run time.


    extend Forwardable
    attr_reader :hash, :semaphore

    # use the delgator pattern to pass through methods to hash
    # I didn't extend hash because we have a need to beable to clear and re initalize the hash
    # and you can not reassign self within a class instance

    def_delegator :@hash, :delete, :invalidate!
    def_delegator :@hash, :[], :read
    def_delegator :@hash, :[], :[]
    def_delegator :@hash, :has_key?

    def initialize
      @semaphore = Mutex.new
      @hash = Hash.new
    end

    # Returns and caches the value or the block passed to it.
    #
    # ==== Attributes
    #
    # * key - the key to store the return value in the cache
    # * value - the value to pass into the cache (Default: nil) if a block is passed the value passed in is ignored.
    #
    # ==== Examples
    #
    # Basic Usage with block
    #     foo = @cache.cache('foo') { 15 }
    #     foo will return 15
    # Basic Usage without block
    #     foo = @cache.cache('foo', 15)
    #     foo will return 15
    def cache(key, value=nil, &block)
      return read(key) if has_key?(key) #return the object if it already in the cache

      value = block_given? ? block.call : value
      write(key, value)


      read(key)
    end


    # Alias of write
    def []=(key, value)
      write(key, value)
    end

    # Writes a value to the cache within a thread safe semaphore
    # Please note writes are destrutive.
    #
    # ==== Attributes
    #
    # * key - the key to store the return value in the cache (Required)
    # * value - the value to pass into the cache. (Required)
    def write(key, value)

      if key.nil?
        raise ArgumentError, 'No key for cache given'
      end

      if value.nil?
        raise ArgumentError, 'No value given to cache'
      end

      semaphore.synchronize do
        @hash[key] = value
      end
    end

    def clear!
      @hash = nil
      @hash = Hash.new
    end

  end

end