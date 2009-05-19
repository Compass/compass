module Compass::SassExtensions::Functions::ImageUrl
  def image_url(path)
    path = path.value # get to the string value of the literal.
    if absolute_path?(path)
      return Sass::Script::String.new("url(#{path})")
    end
    http_images_path = if Compass.configuration.http_images_path == :relative
      compute_relative_path
    else
      Compass.configuration.http_images_path
    end

    real_path = if Compass.configuration.images_dir
      File.join(Compass.configuration.project_path, Compass.configuration.images_dir, path)
    end

    if http_images_path
      http_images_path = "#{http_images_path}/" unless http_images_path[-1..-1] == "/"
      path = "#{http_images_path}#{path}"
    end

    if real_path && File.exists?(real_path)
      path += "?#{File.mtime(real_path).strftime("%s")}"
    elsif real_path
      $stderr.puts "WARNING: '#{File.basename(path)}' was not found in #{File.dirname(real_path)}"
    end

    Sass::Script::String.new("url(#{path})")
  end

  private

  def absolute_path?(path)
    path[0..0] == "/" || path[0..3] == "http"
  end

  def compute_relative_path
    if (target_css_file = options[:css_filename])
      images_path = File.join(Compass.configuration.project_path, Compass.configuration.images_dir)
      Pathname.new(images_path).relative_path_from(Pathname.new(File.dirname(target_css_file))).to_s
    end
  end
end