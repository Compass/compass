module Compass
  module Version
    VERSION_DETAILS = {
      :major => 0,
      :minor => 12,
      :build => 7,
      :name => "Alnilam"
    }

    # Returns a hash representing the version.
    # The :major, :minor, and :teeny keys have their respective numbers.
    # The :string key contains a human-readable string representation of the version.
    # The :rev key will have the current revision hash.
    #
    # This method swiped from Haml and then modified, some credit goes to Nathan Weizenbaum
    def version
      if defined?(@version)
        @version
      else
        read_version
      end
    end

    protected

    def scope(file) # :nodoc:
      File.join(File.dirname(__FILE__), '..', '..', file)
    end

    def read_version
      @version = VERSION_DETAILS.dup
      @version[:teeny]  = @version[:patch]
      @version[:string] = "#{@version[:major]}.#{@version[:minor]}"
      @version[:string] << ".#{@version[:patch]}" if @version[:patch]
      @version[:string] << ".#{@version[:build]}" if @version[:build]
      @version[:string] << ".#{@version[:state]}" if @version[:state]
      @version[:string] << ".#{@version[:iteration]}" if @version[:iteration]
      if !ENV['OFFICIAL'] && r = revision
        @version[:string] << ".#{r[0..6]}"
      end
      @version
    end

    def revision
      revision_from_git
    end

    def revision_from_git
      if File.exists?(scope('.git/HEAD'))
        Dir.chdir scope(".") do
          `git rev-parse HEAD`
        end
      end
    rescue
      nil
    end

  end

  extend Compass::Version

  VERSION = version[:string]
end
