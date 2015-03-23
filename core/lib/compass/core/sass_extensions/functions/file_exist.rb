module Compass::SassExtensions::Functions::FileExist
  def file_exist(image_file)
    image_file = image_file.value # get to the string value of the literal.

    # Compute the real path to the image on the file stystem if the generated_images_dir is set.
    real_path = if Compass.configuration.images_path
      images_path = Compass.configuration.images_path
      if Pathname.new(images_path).relative? && Rails.present? && Rails.root.present?
        File.join(Rails.root, "app", "assets", images_path, image_file)
      else
        File.join(images_path, image_file)
      end
    else
      images_path = Compass.configuration.project_path
      if Pathname.new(images_path).relative? && Rails.present? && Rails.root.present?
        File.join(Rails.root, "public", images_path, image_file)
      else
        File.join(images_path, image_file)
      end
    end

    return Sass::Script::Bool.new(File.exist?(real_path))
  end
end