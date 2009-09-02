%w(configuration_defaults installer).each do |lib|
  require File.join(File.dirname(__FILE__), 'rails', lib)
end

require File.join(File.dirname(__FILE__), 'rails', 'runtime') if defined?(ActionController::Base)



