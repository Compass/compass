module Compass::SassExtensions::Functions::Utility

  def file_exists(path_to_file)
    path = path_to_file.respond_to?(:value) ? path_to_file.value : path_to_file
    Sass::Script::Bool.new(File.exists?(path));
  end

  Sass::Script::Functions.declare :file_exists, [:path_to_file]

end