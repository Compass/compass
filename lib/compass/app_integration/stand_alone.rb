%w(configuration_defaults installer).each do |lib|
  require "compass/app_integration/stand_alone/#{lib}"
end