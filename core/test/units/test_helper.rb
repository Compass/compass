lib_directory = File.expand_path("../../lib", File.dirname(__FILE__))
$: << lib_directory unless $:.include? lib_directory
require 'fileutils'
require 'compass/core'

require "minitest/autorun"
require File.expand_path(File.join(File.dirname(__FILE__), "..", "helpers", "diff"))

include Compass::Diff

class Minitest::Test
  def assert_raise_message(klass, message)
    begin
      yield
      fail "Exception not raised."
    rescue klass => e
      assert_equal message, e.message
    end
  end
end

