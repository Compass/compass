%w(manifest template_context base).each do |f|
  require "compass/installers/#{f}"
end
