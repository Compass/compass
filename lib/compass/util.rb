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

end
