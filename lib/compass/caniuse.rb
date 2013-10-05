require 'json'
require 'singleton'
class Compass::CanIUse
  include Singleton

  DATA_FILE_NAME = File.join(Compass.base_directory, "data", "caniuse.json")

  def initialize
   @data = JSON.parse(File.read(DATA_FILE_NAME))
  end

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

  def browsers
    @browsers ||= @data["agents"].keys.map{|b| PUBLIC_BROWSER_NAMES[b] }.sort
  end

  def prefix(browser)
    assert_valid_browser browser
    p = @data["agents"][CAN_I_USE_NAMES[browser]]["prefix"]
    "-#{p}"
  end

  def prefixes(browsers = browsers)
    result = browsers.map{|b| prefix(b) }
    result.uniq!
    result.sort!
    result
  end

  def browsers_with_prefix(prefix)
    assert_valid_prefix prefix
    prefix = prefix[1..-1] if prefix.start_with?("-")
    browsers.select {|b| @data["agents"][CAN_I_USE_NAMES[b]]["prefix"] == prefix }
  end

  def prefixed_usage(prefix, capability)
    assert_valid_prefix prefix
    assert_valid_capability capability
    usage = 0
    browsers_with_prefix(prefix).each do |browser|
      data = capability_data(capability)
      versions(browser).each do |version|
        if data["stats"][CAN_I_USE_NAMES[browser]][version].end_with?("x")
          usage += usage(browser, version)
        end
      end
    end
    usage
  end

  def requires_prefix(browser, min_version, capability)
    assert_valid_browser browser
    assert_valid_capability capability
    data = capability_data(capability)
    found_version = false
    versions(browser).each do |version|
      found_version ||= version == min_version
      next unless found_version
      if data["stats"][CAN_I_USE_NAMES[browser]][version].end_with?("x")
        return true
      end
    end
    raise ArgumentError, "#{min_version} is not a version for #{browser}" unless found_version
    false
  end

  # @param min_usage a decimal number betwee 0 and 100
  def versions(browser, min_usage = 0)
    assert_valid_browser browser
    versions = browser_data(browser)["versions"].compact
    return versions if min_usage == 0
    versions.select {|v| browser_data(browser)["usage_global"][v] > min_usage }
  end

  def capabilities
    @capabilities ||= @data["data"].keys.select do |cap|
      cats = @data["data"][cap]["categories"]
      cats.any?{|cat| cat =~ /CSS/ }
    end.sort
  end

  def capability_data(capability)
    @data["data"][capability]
  end

  def browser_data(browser)
    @data["agents"][CAN_I_USE_NAMES[browser]]
  end

  def usage(browser, version)
    browser_data(browser)["usage_global"][version]
  end

  def inspect
    "Compass::CanIUse(#{browsers.join(", ")})"
  end

  def assert_valid_prefix(prefix)
    @known_prefixes ||= Set.new(prefixes(browsers))
    unless @known_prefixes.include?(prefix)
      raise ArgumentError, "#{prefix} is not known browser prefix."
    end
  end

  def assert_valid_browser(browser)
    @known_browsers ||= Set.new(browsers)
    @known_browsers.include?(browser)
    unless @known_browsers.include?(browser)
      raise ArgumentError, "#{prefix} is not known browser."
    end
  end

  def assert_valid_capability(capability)
    @known_capabilities ||= Set.new(capabilities)
    unless @known_capabilities.include?(capability)
      raise ArgumentError, "#{capability} is not known browser capability."
    end
    nil
  end
end
