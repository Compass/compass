module Compass::SassExtensions::Functions::ImageSize
  def image_width(image_file)    
    width = compute_size(image_file).first
    Sass::Script::Number.new(width,["px"])
  end
  
  def image_height(image_file)
    height = compute_size(image_file).last
    Sass::Script::Number.new(height, ["px"])
  end
  
private
  # Returns an array [width,height] containing image dimensions
  def compute_size(image_path)
    path = image_path.value
    # Compute the real path to the image on the file stystem if the images_dir is set.
     real_path = if Compass.configuration.images_dir
       File.join(Compass.configuration.project_path, Compass.configuration.images_dir, path)
     else
       File.join(Compass.configuration.project_path, path)
     end
    case real_path
    when /\.png$/i
      IO.read(real_path)[0x10..0x18].unpack('NN')
    when /\.gif$/i
      IO.read(real_path)[6..10].unpack('SS')
    when /\.jpe?g$/i
      # FIXME jpgs are not straightforward
      raise Compass::Error, "JPEG files are not supported yet."      
    else
      raise Compass::Error, "File is either not an image, or is not supported."
    end    
  end  
end
