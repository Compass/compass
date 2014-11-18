lib_directory = File.expand_path("../../lib", File.dirname(__FILE__))
$: << lib_directory unless $:.include? lib_directory
require 'fileutils'
require 'compass/core'

require "test/unit"
require File.join(File.dirname(__FILE__), "..", "..", "..", "test", "common", "helpers", "diff")

include Compass::Test::Diff

class Test::Unit::TestCase
  def assert_raise_message(klass, message)
    begin
      yield
      fail "Exception not raised."
    rescue klass => e
      assert_equal message, e.message
    end
  end
end

