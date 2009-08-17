%w(manifest template_context base stand_alone rails).each do |f|
  require File.join(File.dirname(__FILE__), 'installers', f)
end
