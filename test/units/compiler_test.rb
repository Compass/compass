require 'test_helper'
require 'fileutils'

class CompilerTest < Test::Unit::TestCase
  
  it "should strip css from file name and reappend" do
    compiler = Compass::Compiler.new(Dir.pwd, 'foo', 'bar', {})
    assert_equal 'screen', compiler.stylesheet_name(File.join(Dir.pwd, 'foo', 'screen.css.scss'))
  end

  it "should accept a compiler cache" do
    @cache = Compass::CompilerCache.new
    compiler = Compass::Compiler.new(Dir.pwd, 'foo', 'bar', {}, @cache)
    assert_equal @cache, compiler.sass_options[:compass][:cache]
  end

  it "should create its own compiler cache if cache is nil" do
    compiler = Compass::Compiler.new(Dir.pwd, 'foo', 'bar', {}, nil)
    assert compiler.sass_options[:compass][:cache].is_a?(Compass::CompilerCache)
  end

end