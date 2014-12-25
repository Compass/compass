require 'multi_json'
require 'singleton'
class Compass::Core::CanIUse
  include Singleton

  DATA_FILE_NAME = File.join(Compass::Core.base_directory, "data", "caniuse.json")
  DATA_FEATURE_FILES = Dir.glob(File.join(Compass::Core.base_directory, "data", "caniuse_extras", "**", "*.json"))

  def initialize
    @data = MultiJson.load(File.read(DATA_FILE_NAME))
    # support ad-hoc features
    DATA_FEATURE_FILES.each do |feature_file|
      feature_name = File.basename(feature_file, ".json")
      # if the feature doesn't exist in the master `caniuse.json`
      if @data["data"][feature_name].nil?
        @data["data"][feature_name] = MultiJson.load(File.read(feature_file))
      end
    end
  end

  # The browser names from caniuse are ugly.
  PUBLIC_BROWSER_NAMES = Hash.new {|h, k| k}
  PUBLIC_BROWSER_NAMES.update(
    "and_chr" => "android-chrome",
    "and_ff"  => "android-firefox",
    "android" => "android",
    "bb"      => "blackberry",
    "chrome"  => "chrome",
    "firefox" => "firefox",
    "ie"      => "ie",
    "ie_mob"  => "ie-mobile",
    "ios_saf" => "ios-safari",
    "op_mini" => "opera-mini",
    "op_mob"  => "opera-mobile",
    "opera"   => "opera",
    "safari"  => "safari"
  )
  CAN_I_USE_NAMES = Hash.new {|h, k| k}
  CAN_I_USE_NAMES.update(PUBLIC_BROWSER_NAMES.invert)

  # Returns all the known browsers according to caniuse
  def browsers
    @browsers ||= @data["agents"].keys.map{|b| PUBLIC_BROWSER_NAMES[b] }.sort
  end

  # Returns the prefix corresponding to a particular browser
  def prefix(browser, version = nil)
    version = caniuse_version(browser, version)
    assert_valid_browser browser
    assert_valid_version browser, version if version
    data = browser_data(browser)
    p = if data["prefix_exceptions"] && data["prefix_exceptions"][version]
          data["prefix_exceptions"][version]
        else
          data["prefix"]
        end
    "-#{p}"
  end

  # returns all possible prefixes a browser might use.
  def all_prefixes(browser)
    assert_valid_browser browser
    data = browser_data(browser)
    prefixes = ["-#{data["prefix"]}"]
    if data["prefix_exceptions"]
      prefixes += data["prefix_exceptions"].values.uniq.map{|p| "-#{p}"}
    end
    prefixes
  end

  # returns the prefixes needed by the list of browsers given
  def prefixes(browsers = browsers())
    result = browsers.map{|b| all_prefixes(b) }
    result.flatten!
    result.uniq!
    result.sort!
    result
  end

  def browser_ranges(capability, prefix = nil, include_unprefixed_versions = true)
    assert_valid_capability capability
    browsers = prefix.nil? ? browsers() : browsers_with_prefix(prefix)
    browsers.inject({}) do |m, browser|
      browser_versions = versions(browser)
      min_version = find_first_prefixed_version(browser, browser_versions, capability, prefix)
      if min_version
        max_version = if include_unprefixed_versions
                        browser_versions.last
                      else
                        find_first_prefixed_version(browser, browser_versions.reverse, capability, prefix)
                      end
        m.update(browser => [min_version, max_version])
      end
      m
    end
  end

  def find_first_prefixed_version(browser, versions, capability, prefix)
    versions.find do |version|
      support = browser_support(browser, version, capability)
      if prefix.nil?
        support !~ /\b(n|p)\b/ && support !~ /\bx\b/
      else
        actual_prefix = prefix(browser, version)
        support !~ /\b(n|p)\b/ && support =~ /\bx\b/ && prefix == actual_prefix
      end
    end
  end

  # @overload omitted_usage(browser, min_supported_version)
  #   How many users would be omitted if support for the given browser starts
  #   with the given version.
  #
  # @overload omitted_usage(browser, min_unsupported_version, max_unsupported_version)
  #   How many users would be omitted if the browsers with version
  def omitted_usage(browser, min_version, max_version = nil)
    versions = versions(browser)
    min_version = caniuse_version(browser, min_version)
    max_version = caniuse_version(browser, max_version)
    if max_version.nil?
      assert_valid_version browser, min_version
    else
      assert_valid_version browser, min_version, max_version
    end
    usage = 0
    in_range = max_version.nil?
    versions.each do |version|
      break if max_version.nil? && version == min_version
      in_range = true if (!max_version.nil? && version == min_version)
      usage += usage(browser, version) if in_range
      break if !max_version.nil? && version == max_version
    end
    return usage
  end

  # returns the list of browsers that use the given prefix
  def browsers_with_prefix(prefix)
    assert_valid_prefix prefix
    prefix = "-" + prefix unless prefix.start_with?("-")
    browsers.select {|b| all_prefixes(b).include?(prefix) }
  end

  SPEC_VERSION_MATCHERS = Hash.new do |h, k|
    h[k] = /##{k}\b/
  end

  CAPABILITY_MATCHERS = {
    :full_support => lambda {|support, capability| !support ^ (capability =~ /\by\b/) },
    :partial_support => lambda {|support, capability| !support ^ (capability =~ /\ba\b/) },
    :prefixed => lambda {|support, capability| !support ^ (capability =~ /\bx\b/) },
    :spec_versions => lambda {|versions, capability| versions.any? {|v| capability =~ SPEC_VERSION_MATCHERS[v] } }
  }

  # Return whether the capability matcher the options specified.
  # For each capability option in the options the capability will need to match it.
  def capability_matches(support, capability_options_list)
    capability_options_list.any? do |capability_options|
      capability_options.all? {|c, v| CAPABILITY_MATCHERS[c].call(v, support)}
    end
  end

  # returns the percentage of users (0-100) that would be affected if the prefix
  # was not used with the given capability.
  def prefixed_usage(prefix, capability, capability_options_list)
    assert_valid_prefix prefix
    assert_valid_capability capability
    usage = 0
    browsers_with_prefix(prefix).each do |browser|
      versions(browser).each do |version|
        next unless prefix == prefix(browser, version)
        support = browser_support(browser, version, capability)
        if capability_matches(support, capability_options_list) and support =~ /\bx\b/
          usage += usage(browser, version)
        end
      end
    end
    usage
  end

  def next_version(browser, version)
    version = caniuse_version(browser, version)
    versions = versions(browser)
    index = versions.index(version)
    index < versions.length - 1 ? versions[index + 1] : nil
  end

  def previous_version(browser, version)
    version = caniuse_version(browser, version)
    versions = versions(browser)
    index = versions.index(version)
    index > 0 ? versions[index - 1] : nil
  end

  # Returns whether the given minimum version of a browser
  # requires the use of a prefix for the stated capability.
  def requires_prefix(browser, min_version, capability, capability_options_list)
    min_version = caniuse_version(browser, min_version)
    assert_valid_browser browser
    assert_valid_capability capability
    found_version = false
    versions(browser).each do |version|
      found_version ||= version == min_version
      next unless found_version
      support = browser_support(browser, version, capability)
      if capability_matches(support, capability_options_list) and support =~ /\bx\b/
        return prefix(browser, version)
      end
    end
    raise ArgumentError, "#{min_version} is not a version for #{browser}" unless found_version
    nil
  end

  # These are versions that users might reasonably type
  # mapped to the caniuse version.
  ALTERNATE_VERSIONS = {
    "android" => {
      "4.2" => "4.2-4.3",
      "4.3" => "4.2-4.3"
    },
    "opera" => {
      "9.5" => "9.5-9.6",
      "9.6" => "9.5-9.6",
      "10.0" => "10.0-10.1",
      "10.1" => "10.0-10.1",
    },
    "opera-mobile" => {
      "14" => "0"
    }
  }

  # Returns the versions of a browser. If the min_usage parameter is provided,
  # only those versions having met the threshold of user percentage.
  #
  # @param min_usage a decimal number betwee 0 and 100
  def versions(browser, min_usage = 0)
    assert_valid_browser browser
    versions = browser_data(browser)["versions"].compact
    return versions if min_usage == 0
    versions.select {|v| browser_data(browser)["usage_global"][v] > min_usage }
  end

  # The list of capabilities tracked by caniuse.
  def capabilities
    @capabilities ||= @data["data"].keys.select do |cap|
      cats = @data["data"][cap]["categories"]
      cats.any?{|cat| cat =~ /CSS/ }
    end.sort
  end

  # the usage % for a given browser version.
  def usage(browser, version)
    browser_data(browser)["usage_global"][version]
  end

  # returns a valid version given the version provided by the user
  # This is used to maintain API compatibility when caniuse removes
  # a version from their data (which seems to be replaced with a semantic equivalent).
  def caniuse_version(browser, version)
    return unless version
    ALTERNATE_VERSIONS[browser] && ALTERNATE_VERSIONS[browser][version] || version
  end

  def inspect
    "#{self.class.name}(#{browsers.join(", ")})"
  end

  # the browser data assocated with a given capability
  def capability_data(capability)
    @data["data"][capability]
  end

  def browser_support(browser, version, capability)
    version = caniuse_version(browser, version)
    capability_data(capability)["stats"][CAN_I_USE_NAMES[browser]][version]
  end

  # the metadata assocated with a given browser
  def browser_data(browser)
    @data["agents"][CAN_I_USE_NAMES[browser]]
  end

  # efficiently checks if a prefix is valid
  def assert_valid_prefix(prefix)
    @known_prefixes ||= Set.new(prefixes(browsers))
    unless @known_prefixes.include?(prefix)
      raise ArgumentError, "#{prefix} is not known browser prefix."
    end
  end

  # efficiently checks if a browser is valid
  def assert_valid_browser(browser)
    @known_browsers ||= Set.new(browsers)
    unless @known_browsers.include?(browser)
      raise ArgumentError, "#{browser} is not known browser."
    end
  end

  # efficiently checks if a capability is valid
  def assert_valid_capability(capability)
    @known_capabilities ||= Set.new(capabilities)
    unless @known_capabilities.include?(capability)
      raise ArgumentError, "#{capability} is not known browser capability."
    end
    nil
  end

  def assert_valid_version(browser, *versions)
    versions.each do |v|
      unless versions(browser).include?(v)
        raise ArgumentError, "#{v} is not known version for #{browser}."
      end
    end
  end
end
