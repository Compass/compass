module Compass::Core::SassExtensions::Functions::CrossBrowserSupport
  extend Compass::Core::SassExtensions::Functions::SassDeclarationHelper

  class CSS2FallbackValue < Sass::Script::Value::Base
    attr_accessor :value, :css2_value
    def children
      [value, css2_value]
    end
    def initialize(value, css2_value)
      self.value = value
      self.css2_value = css2_value
    end
    def inspect
      to_s
    end
    def to_s(options = self.options)
      value.to_s(options)
    end
    def supports?(aspect)
      aspect == "css2"
    end
    def has_aspect?
      true
    end
    def to_css2(options = self.options)
      css2_value
    end
  end

  # Check if any of the arguments passed require a vendor prefix.
  def prefixed(prefix, *args)
    assert_type prefix, :String
    aspect = prefix.value.sub(/^-/,"")
    needed = args.any?{|a| a.respond_to?(:supports?) && a.supports?(aspect)}
    bool(needed)
  end

  %w(webkit moz o ms svg css2 owg).each do |prefix|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      # Syntactic sugar to apply the given prefix
      # -moz($arg) is the same as calling prefix(-moz, $arg)
      def _#{prefix}(*args)
        prefix("#{prefix}", *args)
      end
    RUBY
  end

  def prefix(prefix, *objects)
    assert_type prefix, :String if prefix.is_a?(Sass::Script::Value::Base)
    prefix = prefix.value if prefix.is_a?(Sass::Script::Value::String)
    prefix = prefix[1..-1] if prefix[0] == ?-
    if objects.size > 1
      self.prefix(prefix, list(objects, :comma))
    else
      object = objects.first
      if object.is_a?(Sass::Script::Value::List)
        list(object.value.map{|e|
          self.prefix(prefix, e)
        }, object.separator)
      elsif object.respond_to?(:supports?) && object.supports?(prefix) && object.respond_to?(:"to_#{prefix}")
        object.options = options
        object.send(:"to_#{prefix}")
      else
        object
      end
    end
  end

  def css2_fallback(value, css2_value)
    CSS2FallbackValue.new(value, css2_value)
  end

  # The known browsers.
  #
  # If prefix is given, limits the returned browsers to those using the specified prefix.
  def browsers(prefix = nil)
    browsers = if prefix
                 assert_type prefix, :String
                 Compass::Core::CanIUse.instance.browsers_with_prefix(prefix.value)
               else
                 Compass::Core::CanIUse.instance.browsers
               end
    list(browsers.map{|b| identifier(b)}, :comma)
  end
  declare(:browsers, [])
  declare(:browsers, [:prefix])

  # The known capabilities of browsers.
  def browser_capabilities
    list(Compass::Core::CanIUse.instance.capabilities.map{|c| identifier(c)}, :comma)
  end
  declare(:browser_capabilities, [])

  # The versions for the given browser.
  def browser_versions(browser)
    assert_type browser, :String
    list(Compass::Core::CanIUse.instance.versions(browser.value).map{|v| quoted_string(v)}, :comma)
  rescue ArgumentError => e
    raise Sass::SyntaxError.new(e.message)
  end
  declare(:browser_versions, [:browser])

  # whether the browser uses a prefix for the given capability at the version
  # specified or a later version. Returns the prefix it requires, or null.
  def browser_requires_prefix(browser, version, capability, capability_options)
    assert_type browser, :String
    assert_type version, :String
    assert_type capability, :String
    p = Compass::Core::CanIUse.instance.requires_prefix(browser.value,
                                                  version.value,
                                                  capability.value,
                                                  unbox_capability_options_list(capability_options))
    p ? identifier(p) : null()
  rescue ArgumentError => e
    raise Sass::SyntaxError.new(e.message)
  end
  declare(:browser_requires_prefix, [:browser, :version, :capability])

  # the prefix for the given browser.
  def browser_prefix(browser, version = nil)
    assert_type browser, :String
    identifier(Compass::Core::CanIUse.instance.prefix(browser.value))
  rescue ArgumentError => e
    raise Sass::SyntaxError.new(e.message)
  end
  declare(:browser_prefix, [:browser])
  declare(:browser_prefix, [:browser, :version])

  # The prefixes used by the given browsers.
  def browser_prefixes(browsers)
    browsers = list(browsers, :comma) if browsers.is_a?(Sass::Script::Value::String)
    assert_type browsers, :List
    browser_strings = browsers.value.map {|b| assert_type(b, :String); b.value }
    prefix_strings = Compass::Core::CanIUse.instance.prefixes(browser_strings)
    list(prefix_strings.map {|p| identifier(p)}, :comma)
  rescue ArgumentError => e
    raise Sass::SyntaxError.new(e.message)
  end
  declare(:browser_prefixes, [:browsers])

  # The percent of users that are omitted by setting the min_version of browser
  # as specified.
  def omitted_usage(browser, min_version, max_version = nil)
    assert_type browser, :String
    assert_type min_version, :String, :min_version
    assert_type(max_version, :String, :max_version) if max_version
    versions = [min_version.value]
    versions << max_version.value if max_version
    number(Compass::Core::CanIUse.instance.omitted_usage(browser.value, *versions))
  end
  declare(:omitted_usage, [:browser, :min_version])
  declare(:omitted_usage, [:browser, :min_version, :max_version])

  # The version before the version for the browser specified
  def previous_version(browser, version)
    assert_type browser, :String
    assert_type version, :String
    previous = Compass::Core::CanIUse.instance.previous_version(browser.value, version.value)
    previous.nil? ? null() : quoted_string(previous)
  end
  declare(:previous_version, [:browser, :version])

  # The version before the version for the browser specified
  def next_version(browser, version)
    assert_type browser, :String
    assert_type version, :String
    next_version = Compass::Core::CanIUse.instance.next_version(browser.value, version.value)
    next_version.nil? ? null() : quoted_string(next_version)
  end
  declare(:next_version, [:browser, :version])

  # The percent of users relying on a particular prefix
  def prefix_usage(prefix, capability, capability_options)
    assert_type prefix, :String
    assert_type capability, :String
    number(Compass::Core::CanIUse.instance.prefixed_usage(prefix.value,
                                                    capability.value,
                                                    unbox_capability_options_list(capability_options)))
  rescue ArgumentError => e
    raise Sass::SyntaxError.new(e.message)
  end
  declare(:prefix_usage, [:prefix, :capability])

  # Compares two browser versions. Returning:
  #
  # * 0 if they are the same
  # * <0 if the first version is less than the second
  # * >0 if the first version is more than the second
  def compare_browser_versions(browser, version1, version2)
    assert_type browser, :String, :browser
    assert_type version1, :String, :version1
    assert_type version2, :String, :version2
    index1 = index2 = nil
    Compass::Core::CanIUse.instance.versions(browser.value).each_with_index do |v, i|
      index1 = i if v == version1.value
      index2 = i if v == version2.value
      break if index1 && index2
    end
    unless index1
      raise Sass::SyntaxError.new("#{version1} is not a version for #{browser}")
    end
    unless index2
      raise Sass::SyntaxError.new("#{version2} is not a version for #{browser}")
    end
    number(index1 <=> index2)
  end
  declare(:compare_browser_versions, [:browser, :version1, :version2])

  # Returns a map of browsers to the first version the capability became available
  # without a prefix.
  #
  # If a prefix is provided, only those browsers using that prefix will be returned
  # and the minimum version will be when it first became available as a prefix or
  # without a prefix.
  #
  # If a browser does not have the capability, it will not included in the map.
  def browser_ranges(capability, prefix = null(), include_unprefixed_versions = bool(true))
    assert_type capability, :String
    assert_type(prefix, :String) unless prefix == null()
    mins = Compass::Core::CanIUse.instance.browser_ranges(capability.value,
                                                          prefix.value,
                                                          include_unprefixed_versions.to_bool)
    Sass::Script::Value::Map.new(mins.inject({}) do |m, (h, range)|
      m[identifier(h)] = list(range.map{|version| quoted_string(version)}, :space)
      m
    end)
  end
  declare(:browser_minimums, [:capability])
  declare(:browser_minimums, [:capability, :prefix])

  private

  def unbox_capability_options_list(capability_options_list)
    if capability_options_list.is_a?(Sass::Script::Value::Map)
      [unbox_capability_options(capability_options_list)]
    elsif capability_options_list.is_a?(Sass::Script::Value::List)
      capability_options_list.to_a.map{|opts| unbox_capability_options(opts) }
    else
      assert_type capability_options_list, :List
    end
  end

  CAPABILITY_OPTION_KEYS = {
    "full-support" => :full_support,
    "partial-support" => :partial_support,
    "prefixed" => :prefixed,
    "spec-versions" => :spec_versions,
  }

  CAPABILITY_OPTION_UNBOXER = {
    :full_support => lambda {|v| v.to_bool },
    :partial_support => lambda {|v| v.to_bool },
    :prefixed => lambda {|v| v.to_bool },
    :spec_versions => lambda {|versions| versions.to_a.map {|v| v.value } }
  }

  def unbox_capability_options(capability_options)
    assert_type capability_options, :Map
    result = {}
    capability_options.value.each do |k, v|
      assert_type k, :String
      key = CAPABILITY_OPTION_KEYS[k.value]
      unless key
        raise Sass::SyntaxError, "#{k} is not valid capability option"
      end
      result[key] = CAPABILITY_OPTION_UNBOXER[key].call(v)
    end
    result
  end
end
