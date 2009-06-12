require  File.join(File.dirname(__FILE__),'test_helper')
require  File.join(File.dirname(__FILE__),'test_rails_helper')
require 'fileutils'
require 'compass'
require 'compass/exec'
require 'timeout'

class RailsIntegrationTest < Test::Unit::TestCase
  include Compass::TestCaseHelper
  include Compass::CommandLineHelper

  def setup
    Compass.configuration.reset!
  end

  def test_rails_install
    within_tmp_directory do
      generate_rails_app("compass_rails")
      Dir.chdir "compass_rails" do
        compass("--rails", '--trace', ".") do |responder|
          responder.respond_to "Is this OK? (Y/n) ", :with => "Y", :required => true
          responder.respond_to "Emit compiled stylesheets to public/stylesheets/compiled/? (Y/n) ", :with => "Y", :required => true
        end
        # puts ">>>#{@last_result}<<<"
        assert_action_performed :create, "./app/stylesheets/screen.sass"
        assert_action_performed :create, "./config/initializers/compass.rb"
      end
    end
  rescue LoadError
    puts "Skipping rails test. Couldn't Load rails"
  end

end