%w(manifest template_context base).each do |f|
  require File.join(File.dirname(__FILE__), 'installers', f)
end
