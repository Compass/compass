# TODO figure something out so image_path works with rails integration
%w(railtie helpers).each do |lib|
  require "compass/app_integration/rails/actionpack31/#{lib}"
end

