module Compass::SassExtensions::Functions::Utility
  extend Compass::SassExtensions::Functions::SassDeclarationHelper

  def file_exists(path_to_file)
    path = path_to_file.respond_to?(:value) ? path_to_file.value : path_to_file
    Sass::Script::Bool.new(File.exists?(path));
  end

  register_sass_function :file_exists, [:path_to_file]

end
