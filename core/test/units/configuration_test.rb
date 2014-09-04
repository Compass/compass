#! /usr/bin/env ruby
test_directory = File.expand_path(File.dirname(__FILE__))
$: << test_directory unless $:.include? test_directory
require 'test_helper'
require 'compass-core'

class ConfigurationTest < Minitest::Test

  def test_sass_engine_options
    result = Compass.configuration.to_sass_engine_options
    assert_kind_of Hash, result
  end

  def test_sass_plugin_options
    result = Compass.configuration.to_sass_plugin_options
    assert_kind_of Hash, result
  end

end

