require 'compass/generated_version'
module Compass
  module Version
    def scope(file) # :nodoc:
      File.join(File.dirname(__FILE__), '..', '..', file)
    end

    def parse_version(version, name)
      nil_or_int = lambda{|i| i.nil? ? nil : i.to_i}
      segments = version.split(".")
      {
        :string => version,
        :name => name,
        :major => nil_or_int.call(segments.shift),
        :minor => nil_or_int.call(segments.shift),
        :patch => nil_or_int.call(segments.shift),
        :state => segments.shift,
        :iteration => nil_or_int.call(segments.shift)
      }
    end

    # Returns a hash representing the version.
    # The :major, :minor, and :teeny keys have their respective numbers.
    # The :string key contains a human-readable string representation of the version.
    # The :rev key will have the current revision hash.
    #
    # This method swiped from Haml and then modified, some credit goes to Nathan Weizenbaum
    def version
      Compass::VERSION_DETAILS
    end
  end

  extend Compass::Version

  unless defined?(::Compass::VERSION)
    VERSION = File.read(scope("VERSION")).strip 
    VERSION_NAME = File.read(scope("VERSION_NAME")).strip
  end

  VERSION_DETAILS = parse_version(VERSION, VERSION_NAME)

end
