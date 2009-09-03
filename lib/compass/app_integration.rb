%w(stand_alone rails merb).each do |lib|
  require "compass/app_integration/#{lib}"
end
