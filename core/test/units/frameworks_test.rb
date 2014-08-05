#! /usr/bin/env ruby
test_directory = File.expand_path(File.dirname(__FILE__))
$: << test_directory unless $:.include? test_directory
require 'test_helper'

class FrameworksTest < Test::Unit::TestCase

  def test_compass_has_the_compass_framework
    names = []
    Compass::Frameworks::ALL.each do |framework|
      names << framework.name
    end
    assert names.include?("compass")
  end

end

