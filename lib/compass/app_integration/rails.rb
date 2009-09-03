%w(configuration_defaults installer).each do |lib|
  require "compass/app_integration/rails/#{lib}"
end

require 'compass/app_integration/rails/runtime' if defined?(ActionController::Base)



