Feature: Rails Integration
  In order to provide an integrated experience
  As a Ruby on Rails user
  I want to easily access the Compass functionality

  Scenario: Configure Compass from my Application
    Given I'm in a rails3.1 application named 'exemplar'
     When I edit 'config/application.rb' and save it with the following value:
          """
          require File.expand_path('../boot', __FILE__)
          require 'rails/all'
          Bundler.require(:default, Rails.env) if defined?(Bundler)
          module Exemplar
            class Application < Rails::Application
              config.encoding = "utf-8"
              config.filter_parameters += [:password]
          
              config.compass.fonts_dir = "app/assets/fonts"
            end
          end
          """
      And I run: compass config -p fonts_dir
     Then the command should print out "app/assets/fonts"
  Scenario: Rails gets access to the compass config file
    Given I'm in a rails3.1 application named 'exemplar'
     When I edit 'config/compass.rb' and save it with the following value:
          """
          fonts_dir = "app/assets/fonts"
          """
      And I run: ruby -I. -rconfig/environment -e 'puts Compass.configuration.fonts_dir'
     Then the command should print out "app/assets/fonts"
      
