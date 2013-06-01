require 'test_helper'
require 'compass'

class CompilerCacheTest < Test::Unit::TestCase

  def setup
    @cache = Compass::CompilerCache.new
  end

  def teardown
    @cache = nil
  end


  test "should use setter and getter to access data" do
    @cache.write('foo', 'bar')

    assert_equal 'bar', @cache.read('foo')
  end

  test "short hand setter and getter" do
    @cache['foo'] = 'bar'

    assert_equal 'bar', @cache['foo']
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


  test "should invalidate a item in the cache" do
    @cache['foo'] = 'bar'
    assert_equal 'bar', @cache['foo']
    @cache.invalidate!('foo')
    assert_equal nil, @cache['foo']
  end


  test "should clear cache instance" do
    old_id = @cache.hash.object_id
    @cache.clear!
    assert old_id != @cache.hash.object_id
  end

  test "should raise exception if no value" do
    begin
      @cache.write('foo', nil)
    rescue ArgumentError => e
      assert e.is_a?(ArgumentError)
      assert e.message.include? 'No value'
    end
  end

  test "should raise exception if no key" do
    begin
      @cache.write(nil, nil)
    rescue ArgumentError => e
      assert e.is_a?(ArgumentError)
      assert e.message.include? 'No key'
    end
  end
  

end