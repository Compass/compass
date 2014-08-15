require 'digest/md5'

module Compass::Core::SassExtensions::Functions::Files
  extend Compass::Core::SassExtensions::Functions::SassDeclarationHelper
  extend Sass::Script::Value::Helpers

  def md5sum(file, format = nil)
    assert_type file, :String
    filename = nil
    if options[:css_filename] && File.exists?(options[:css_filename])
      filename = File.expand_path(file.value, File.dirname(options[:css_filename]))
    elsif Pathname.new(file.value).absolute?
      filename = file.value
    end
    if filename && File.exist?(filename)
      assert_type file, :String if format
      digest = Digest::MD5.new()
      digest << File.read(filename)
      if !format || format.value == "hex"
        unquoted_string(digest.hexdigest)
      elsif format && format.value == "integer"
        number(digest.hexdigest.hex)
      elsif format
        raise Sass::SyntaxError, "Unknown format '#{format}' for md5sum"
      end
    else
      raise Sass::SyntaxError, "File not found: #{file}"
    end
  end
  declare :md5sum, [:file]
  declare :md5sum, [:file, :format]
end

