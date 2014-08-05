#!/usr/bin/env ruby
require 'test_helper'
require 'fileutils'

# These are useful in debugging.
module Sass::Script::Functions
  def filename
    if @options[:filename]
      Sass::Script::String.new(@options[:filename], true)
    else
      Sass::Script::Null.new
    end
  end
  def importer
    if @options[:importer]
      Sass::Script::String.new(@options[:importer].inspect, true)
    else
      Sass::Script::Null.new
    end
  end
  def importer_is_import_onced
    Sass::Script::Bool.new(@options[:importer].is_a?(Compass::ImportOnce::Importer))
  end
end

class ImportOnceTest < Test::Unit::TestCase
  FIXTURES_DIR = File.join(File.expand_path(File.dirname(__FILE__)), "fixtures")
  Dir.glob(File.join(FIXTURES_DIR, "**", "*.scss")).each do |scss_file|
    if ENV["FIXTURE"]
      next unless File.expand_path(ENV["FIXTURE"]) == scss_file
    end
    dir = File.dirname(scss_file)
    basename = File.basename(scss_file, ".scss")
    next if basename.start_with?("_")
    define_method "test_#{basename}" do
      assert_compilation_result(
        File.join(dir, "#{basename}.scss"),
        File.join(dir, "#{basename}.css"))
    end
  end

  protected

  def assert_compilation_result(sass_file, css_file, options = {})
    options[:style] ||= :expanded
    actual_result = Sass.compile_file(sass_file, options)
    expected_result = File.read(css_file)
    assert expected_result == actual_result, diff_as_string(expected_result, actual_result)
    FileUtils.rm_f("#{css_file}.error") # cleanup from old tests now that it's passing
  rescue Exception => e
    open("#{css_file}.error", "w") {|f| f.write(actual_result) }
    raise
  end
end
