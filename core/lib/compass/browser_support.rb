module Compass
  module BrowserSupport
    extend self

    ASPECTS = %w(webkit moz o ms svg css2)

    SIMPLE_FUNCTIONS = {
           "image" => %w(webkit),
      "cross-fade" => %w(webkit),
      "repeating-linear-gradient" => %w(webkit moz), # Hacky implementation
      "repeating-radial-gradient" => %w(webkit moz)  # Hacky implementation
    }

    # Adds support for one or more aspects for the given simple function
    # Example:
    #
    #   Compass::BrowserSupport.add_support("image", "moz", "webkit")
    #   # => Adds support for moz and webkit to the image() function.
    #
    # This function can be called one or more times in a compass configuration
    # file in order to add support for new, simple browser functions without
    # waiting for a new compass release.
    def add_support(function, *aspects)
      aspects.each do |aspect|
        unless ASPECTS.include?(aspect)
          Compass::Util.compass_warn "Unknown support aspect: #{aspect}"
          next
        end
        unless supports?(function, aspect)
          SIMPLE_FUNCTIONS[function.to_s] ||= []
          SIMPLE_FUNCTIONS[function.to_s] << aspect.to_s
        end
      end
    end

    # Removes support for one or more aspects for the given simple function
    # Example:
    #
    #   Compass::BrowserSupport.remove_support("image", "o", "ms")
    #   # => Adds support for moz and webkit to the image() function.
    #
    # This function can be called one or more times in a compass configuration
    # file in order to remove support for simple functions that no longer need to
    # a prefix without waiting for a new compass release.
    def remove_support(function, *aspects)
      aspects.each do |aspect|
        unless ASPECTS.include?(aspect)
          Compass::Util.compass_warn "Unknown support aspect: #{aspect}"
          next
        end
        SIMPLE_FUNCTIONS[function.to_s].reject!{|a| a == aspect.to_s}
      end
    end

    def supports?(function, aspect)
      SIMPLE_FUNCTIONS.has_key?(function.to_s) && SIMPLE_FUNCTIONS[function.to_s].include?(aspect.to_s)
    end

    def has_aspect?(function)
      SIMPLE_FUNCTIONS.has_key?(function.to_s) && SIMPLE_FUNCTIONS[function.to_s].size > 0
    end

  end
end
