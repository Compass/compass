lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(lib_dir) unless $:.include?(lib_dir)
test_dir = File.dirname(__FILE__)
$:.unshift(test_dir) unless $:.include?(test_dir)

require 'compass'
require 'test/unit'
require "mocha/setup"
require 'true'


class String
  def name
    to_s
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'test', 'common', 'helpers'))

module Compass::Test::TestCaseHelper

  def absolutize(path)
    File.join(File.expand_path('../', __FILE__), path)
  end
end

class Test::Unit::TestCase
  include Compass::Test::Diff
  include Compass::Test::TestCaseHelper
  include Compass::Test::IoHelper
  extend  Compass::Test::TestCaseHelper::ClassMethods
  
  def fixture_path
    File.join(File.expand_path('../', __FILE__), 'fixtures')
  end

end 
