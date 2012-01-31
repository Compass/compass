require 'test_helper'
require 'fileutils'

class CompilerTest < Test::Unit::TestCase
  
  it "should strip css from file name and reappend" do
    compiler = Compass::Compiler.new(Dir.pwd, 'foo', 'bar', {})
    assert_equal 'screen', compiler.stylesheet_name(File.join(Dir.pwd, 'foo', 'screen.css.scss'))
  end

end