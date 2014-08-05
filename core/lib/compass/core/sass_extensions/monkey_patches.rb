%w(traversal browser_support).each do |patch|
  require "compass/core/sass_extensions/monkey_patches/#{patch}"
end
