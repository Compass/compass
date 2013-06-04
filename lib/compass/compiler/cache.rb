require 'thread_safe'

module Compass
  class CompilerCache < ::ThreadSafe::Cache

    # This class is passed into a compiler instance to allow in memory caching of objects at run time.

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
      compute_if_absent(key) do
        if block_given?
          block.call
        else
          value
        end
      end
    end

  end

end