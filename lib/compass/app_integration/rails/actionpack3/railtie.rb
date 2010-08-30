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

    initializer "compass/railtie.configure_rails_initialization" do |app|
      # XXX How do I only do this if it's not done yet?
      # require 'sass/plugin/rack'
      # app.middleware.use Sass::Plugin::Rack
    end
  end
end