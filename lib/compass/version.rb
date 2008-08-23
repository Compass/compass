module Compass
  module Version
    # Returns a hash representing the version.
    # The :major, :minor, and :teeny keys have their respective numbers.
    # The :string key contains a human-readable string representation of the version.
    # If checked out from Git,
    # the :rev key will have the revision hash.
    #
    # This method swiped from Haml and then modified, some credit goes to Nathan Weizenbaum
    attr_writer :version
    def version
      return @version if defined?(@version)

      @version = {
        :string => File.read(scope('VERSION')).strip
      }
      dotted_string, label = @version[:string].split(/-/, 2)
      numbers = dotted_string.split('.').map { |n| n.to_i }
      @version[:major] = numbers[0]
      @version[:minor] = numbers[1]
      @version[:teeny] = numbers[2]
      @version[:label] = label

      if File.exists?(scope('REVISION'))
        rev = File.read(scope('REVISION')).strip
        rev = nil if rev !~ /[a-f0-9]+/
      end

      if rev.nil? && File.exists?(scope('.git/HEAD'))
        rev = File.read(scope('.git/HEAD')).strip
        if rev =~ /^ref: (.*)$/
          rev = File.read(scope(".git/#{$1}")).strip
        end
      end

      if rev
        @version[:rev] = rev
        @version[:string] << " [#{rev[0...7]}]"
      end

      @version
    end
    
    def scope(file) # :nodoc:
      File.join(File.dirname(__FILE__), '..', '..', file)
    end
  end
end
