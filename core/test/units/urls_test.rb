#! /usr/bin/env ruby
test_directory = File.expand_path(File.dirname(__FILE__))
$: << test_directory unless $:.include? test_directory
require 'test_helper'
require 'fileutils'
require 'compass/core'

class UrlsTest < Test::Unit::TestCase
  include Compass::Core::SassExtensions::Functions::Urls

  def test_compute_relative_path
    options[:css_filename] = File.expand_path("./test.css")
    assert_equal ".", compute_relative_path(".")
    assert_equal ".", compute_relative_path(File.expand_path("."))
    options[:css_filename] = "./test.css"
    assert_equal ".", compute_relative_path(".")
    assert_equal ".", compute_relative_path(File.expand_path("."))
  end

  private

  def options
    @options ||= {}
  end
end
