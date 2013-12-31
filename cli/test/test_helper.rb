lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(lib_dir) unless $:.include?(lib_dir)
test_dir = File.dirname(__FILE__)
$:.unshift(test_dir) unless $:.include?(test_dir)

require 'compass'
require 'test/unit'
require 'true'


class String
  def name
    to_s
  end
end

%w(command_line diff io rails test_case).each do |helper|
  require "helpers/#{helper}"
end


class Test::Unit::TestCase
  include Compass::Diff
  include Compass::TestCaseHelper
  include Compass::IoHelper
  extend Compass::TestCaseHelper::ClassMethods
  
  def fixture_path
    File.join(File.expand_path('../', __FILE__), 'fixtures')
  end

end 
