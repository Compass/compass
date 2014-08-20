module Compass::Util
  extend self

  def compass_warn(*args)
    Sass::Util.sass_warn(*args)
  end

  def blank?(value)
    case value
    when NilClass, FalseClass
      true
    when String, Array
      value.length.zero?
    else
      false
    end
  end

  def assert_valid_keys(hash, *keys)
    invalid_keys = hash.keys - keys
    if invalid_keys.any?
      raise ArgumentError, "Invalid key#{'s' if invalid_keys.size > 1} found: #{invalid_keys.map{|k| k.inspect}.join(", ")}"
    end
  end

end
