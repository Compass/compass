require 'compass'
require 'rails'
module Compass
  class Railtie < Rails::Railtie
    config.to_prepare do
      # putting this here allows compass to detect
      # and adjust to changes to the project configuration
      Compass.reset_configuration!
      Compass::AppIntegration::Rails.initialize!
    end

    # Might need to do this...
    # initializer "compass/railtie.configure_rails_initialization" do |app|
    #   puts "Initializing compass"
    # end
  end
end