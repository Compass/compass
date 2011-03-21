module Compass::Util
  extend self

  if defined?(Sass::Util)
    WARN_METHOD = :sass_warn
    include Sass::Util
    extend Sass::Util
  else
    WARN_METHOD = :haml_warn
    include Haml::Util
    extend Haml::Util
  end

  def compass_warn(*args)
    send(WARN_METHOD, *args)
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

end
