%w(traversal browser_support).each do |patch|
  require "compass/sass_extensions/monkey_patches/#{patch}"
end
