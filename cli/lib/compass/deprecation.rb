module Compass
  module Deprecation
    class << self
      attr_accessor :issued_deprecations
    end
    self.issued_deprecations = {}

    def self.deprecated!(identifier, message)
      return if Deprecation.issued_deprecations[identifier]
      Deprecation.issued_deprecations[identifier] = true
      warn message
      warn "Called from #{caller[1]}"
    end

    def self.mark_as_issued(identifier)
      Deprecation.issued_deprecations[identifier] = true
    end
  end
end
