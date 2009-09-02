%w(stand_alone rails merb).each do |lib|
  require File.join(File.dirname(__FILE__), 'app_integration', lib)
end
