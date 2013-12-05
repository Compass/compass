module Compass
  module Version
    # Returns a hash representing the semantic version of the current compass release.
    # See http://semver.org/ for more details.
    #
    # The :major, :minor, and :patch keys have their respective release numbers.
    # The :string key contains a human-readable string representation of the version.
    # The :prerelease key will have the current pre-release state
    # The :build key will have the current pre-release build
    def version
      @version ||= read_version
    end

    protected

    def scope(file) # :nodoc:
      File.join(File.dirname(__FILE__), '..', '..', file)
    end

    def read_version
      version_file = File.exist?(scope("RELEASE_VERSION")) ? scope("RELEASE_VERSION") : scope("VERSION")
      v = File.read(version_file).strip
      segments = v.split(".")
      version_hash = {:string => v}
      version_hash[:major] = segments.shift
      version_hash[:minor] = segments.shift
      version_hash[:patch] = segments.shift
      version_hash[:prerelease] = segments.shift
      version_hash[:build] = segments.shift
      version_hash
    end
  end

  extend Compass::Version

  def self.const_missing(const)
    # This avoid reading from disk unless the VERSION is requested.
    if const == :VERSION
      version[:string]
    else
      super
    end
  end
end
