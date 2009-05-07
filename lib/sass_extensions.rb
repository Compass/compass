require 'sass/plugin'

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
    if absolute_path?(path.value)
      return Sass::Script::String.new("url(#{path})")
    end
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

  private
  def absolute_path?(path)
    path[0..0] == "/" || path[0..3] == "http"
  end
end

# XXX: We can remove this check and monkeypatch once Sass 2.2 is released.
module Sass::Plugin
  class << self
    unless method_defined?(:exact_stylesheet_needs_update?)
      def stylesheet_needs_update?(name, template_path, css_path)
        css_file = css_filename(name, css_path)
        template_file = template_filename(name, template_path)
        exact_stylesheet_needs_update?(css_file, template_file)
      end
      def exact_stylesheet_needs_update?(css_file, template_file)
        if !File.exists?(css_file)
          return true
        else
          css_mtime = File.mtime(css_file)
          File.mtime(template_file) > css_mtime ||
            dependencies(template_file).any?(&dependency_updated?(css_mtime))
        end
      end
    end
  end
end