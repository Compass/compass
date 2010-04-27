module Compass
end

%w(dependencies sass_extensions core_ext version errors).each do |lib|
  require "compass/#{lib}"
end

module Compass
  def base_directory
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
  def lib_directory
    File.expand_path(File.join(File.dirname(__FILE__)))
  end
  module_function :base_directory, :lib_directory
end

%w(configuration frameworks app_integration actions compiler).each do |lib|
  require "compass/#{lib}"
end
