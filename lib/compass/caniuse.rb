require 'json'
require 'singleton'
class Compass::CanIUse
  include Singleton

  DATA_FILE_NAME = File.join(Compass.base_directory, "data", "caniuse.json")

  def initialize
    @data = JSON.parse(File.read(DATA_FILE_NAME))
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
  def prefixes(browsers = browsers)
    result = browsers.map{|b| all_prefixes(b) }
    result.flatten!
    result.uniq!
    result.sort!
    result
  end

  def browser_minimums(capability, prefix = nil)
    assert_valid_capability capability
    browsers = prefix.nil? ? browsers() : browsers_with_prefix(prefix)
    data = capability_data(capability)
    browsers.inject({}) do |m, browser|
      version = versions(browser).find do |version|
                  support = data["stats"][CAN_I_USE_NAMES[browser]][version]
                  if prefix.nil?
                    !support.start_with?("n") && !support.end_with?("x")
                  else
                    actual_prefix = prefix(browser, version)
                    !support.start_with?("n") && support.end_with?("x") && prefix == actual_prefix
                  end

                end
      m.update(browser => version) if version
      m
    end
  end

  # How many users would be omitted if support for the given browser starts
  # with the given version.
  def omitted_usage(browser, min_version)
    assert_valid_browser browser
    usage = 0
    versions(browser).each do |version|
      return usage if version == min_version
      usage += usage(browser, version)
    end
    raise ArgumentError, "#{min_version} is not a version for #{browser}"
  end

  # returns the list of browsers that use the given prefix
  def browsers_with_prefix(prefix)
    assert_valid_prefix prefix
    prefix = "-" + prefix unless prefix.start_with?("-")
    browsers.select {|b| all_prefixes(b).include?(prefix) }
  end

  # returns the percentage of users (0-100) that would be affected if the prefix
  # was not used with the given capability.
  def prefixed_usage(prefix, capability)
    assert_valid_prefix prefix
    assert_valid_capability capability
    usage = 0
    browsers_with_prefix(prefix).each do |browser|
      data = capability_data(capability)
      versions(browser).each do |version|
        next unless prefix == prefix(browser, version)
        if data["stats"][CAN_I_USE_NAMES[browser]][version].end_with?("x")
          usage += usage(browser, version)
        end
      end
    end
    usage
  end

  # Returns whether the given minimum version of a browser
  # requires the use of a prefix for the stated capability.
  def requires_prefix(browser, min_version, capability)
    assert_valid_browser browser
    assert_valid_capability capability
    data = capability_data(capability)
    found_version = false
    versions(browser).each do |version|
      found_version ||= version == min_version
      next unless found_version
      if data["stats"][CAN_I_USE_NAMES[browser]][version].end_with?("x")
        return prefix(browser, version)
      end
    end
    raise ArgumentError, "#{min_version} is not a version for #{browser}" unless found_version
    nil
  end

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


  def inspect
    "Compass::CanIUse(#{browsers.join(", ")})"
  end

  private

  # the browser data assocated with a given capability
  def capability_data(capability)
    @data["data"][capability]
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
    @known_browsers.include?(browser)
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
