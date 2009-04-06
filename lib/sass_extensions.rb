require 'sass'

module Sass::Script::Functions
  COMMA_SEPARATOR = /\s*,\s*/

  def nest(*arguments)
    nested = arguments.map{|a| a.value}.inject do |memo,arg|
      ancestors = memo.split(COMMA_SEPARATOR)
      descendants = arg.split(COMMA_SEPARATOR)
      ancestors.map{|a| descendants.map{|d| "#{a} #{d}"}.join(", ")}.join(", ")
    end
    Sass::Script::String.new(nested)
  end

  def enumerate(prefix, from, through)
    selectors = (from.value..through.value).map{|i| "#{prefix.value}-#{i}"}.join(", ")
    Sass::Script::String.new(selectors)
  end

  def image_url(path)
    http_images_path = if Compass.configuration.http_images_path == :relative
      if (target_css_file = options[:css_filename])
        images_path = File.join(Compass.configuration.project_path, Compass.configuration.images_dir)
        Pathname.new(images_path).relative_path_from(Pathname.new(File.dirname(target_css_file))).to_s
      else
        nil
      end
    else
      Compass.configuration.http_images_path
    end
    if http_images_path
      http_images_path = "#{http_images_path}/" unless http_images_path[-1..-1] == "/"
      path = "#{http_images_path}#{path}"
    end
    Sass::Script::String.new("url(#{path})")
  end
end