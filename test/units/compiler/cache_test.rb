require 'test_helper'
require 'compass'

class CompilerCacheTest < Test::Unit::TestCase

  def setup
    @cache = Compass::CompilerCache.new
  end

  def teardown
    @cache = nil
  end

  test "should cache and return value passed in by a block" do
    assert_equal 15, @cache.cache('foo') { 15 }
    assert_equal 15, @cache['foo']
  end

  test "should cache and return a value" do
    assert_equal 'bar', @cache.cache('foo', 'bar')
    assert_equal 'bar', @cache['foo']
  end

  test "should verify cache is cacheing" do
    assert_equal 15, @cache.cache('foo') { 15 }
    assert_equal 15, @cache.cache('foo') { 16 }
    assert_equal 15, @cache['foo']
  end


  test "should delete a item in the cache" do
    @cache['foo'] = 'bar'
    assert_equal 'bar', @cache['foo']
    @cache.delete('foo')
    assert_equal nil, @cache['foo']
  end

end