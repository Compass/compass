require 'test_helper'
require 'fileutils'
require 'compass'
require 'compass/exec'
require 'timeout'

class RailsIntegrationTest < Test::Unit::TestCase
  include Compass::CommandLineHelper
  include Compass::IoHelper
  include Compass::RailsHelper

  def setup
    Compass.reset_configuration!
  end

  def test_rails_install
    within_tmp_directory do
    begin
      generate_rails_app_directories("compass_rails")
      Dir.chdir "compass_rails" do
        compass(*%w(init rails --trace --boring .)) do |responder|
          responder.respond_to %r{^\s*Is this OK\? \(Y/n\)\s*$}, :with => "Y"
          responder.respond_to %r{^\s*Emit compiled stylesheets to public/stylesheets/compiled/\? \(Y/n\)\s*$}, :with => "Y"
        end
        # puts ">>>#{@last_result}<<<"
        assert_action_performed :create, "./app/stylesheets/screen.scss"
        assert_action_performed :create, "./config/initializers/compass.rb"
      end
    ensure
      FileUtils.rm_rf "compass_rails"
    end
    end
  rescue LoadError
    puts "Skipping rails test. Couldn't Load rails"
  rescue NotImplementedError => e
    puts "Skipping rails test: #{e}"
  end

  def test_rails_install_with_no_dialog
    within_tmp_directory do
      generate_rails_app_directories("compass_rails")
      Dir.chdir "compass_rails" do
        compass(*%w(init rails --trace --boring --sass-dir app/stylesheets --css-dir public/stylesheets/compiled .))
        assert_action_performed :create, "./app/stylesheets/screen.scss"
        assert_action_performed :create, "./config/initializers/compass.rb"
      end
    end
  rescue LoadError
    puts "Skipping rails test. Couldn't Load rails"
  end
end
