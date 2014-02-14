require 'test_helper'
require 'compass'

class ActionsTest < Test::Unit::TestCase
  class BaseActionExtender
    include Compass::Actions
    def options
      @@options ||= {}
    end
    def working_path
      "/tmp"
    end
  end
  
  # When log4r is included, it sometimes breaks the Actions
  test "test_quiet_option" do
    b = BaseActionExtender.new
    b.logger = ""
    b.options[:quiet] = true

    # logger shouldn't be called... if it is, this will error
    b.directory("/tmp/#{(rand * 1000000).to_i}")
  end
end