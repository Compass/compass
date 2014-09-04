#! /usr/bin/env ruby
test_directory = File.expand_path(File.dirname(__FILE__))
$: << test_directory unless $:.include? test_directory
require 'test_helper'
require 'compass/util'

class UtilTest < Minitest::Test

  def test_assert_valid_keys
    Compass::Util.assert_valid_keys({:key1 => true}, :key1, :key2, :key3)
    begin
      Compass::Util.assert_valid_keys({:key1 => true, :invalid => true}, :key1, :key2, :key3)
      fail "Did not raise"
    rescue ArgumentError => e
      assert_equal "Invalid key found: :invalid", e.message
    end
    begin
      Compass::Util.assert_valid_keys({:key1 => true, :invalid => true, :another_invalid => true},
                                      :key1, :key2, :key3)
      fail "Did not raise"
    rescue ArgumentError => e
      assert_equal "Invalid keys found: :another_invalid, :invalid", e.message
    end
  end

  def test_assert_valid_keys_with_symbols_as_strings
    Compass::Util.assert_valid_keys({"key1" => true}, :key1, :key2, :key3)
    begin
      Compass::Util.assert_valid_keys({"key1" => true, "invalid" => true}, :key1, :key2, :key3)
      fail "Did not raise"
    rescue ArgumentError => e
      assert_equal %q{Invalid key found: "invalid"}, e.message
    end
  end


  private

  def options
    @options ||= {}
  end
end

