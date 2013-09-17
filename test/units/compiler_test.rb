require 'test_helper'
require 'fileutils'

class CompilerTest < Test::Unit::TestCase

  it "should strip css from file name and reappend" do
    compiler = Compass::Compiler.new(Dir.pwd, 'foo', 'bar', {})
    assert_equal 'screen', compiler.stylesheet_name(File.join(Dir.pwd, 'foo', 'screen.css.scss'))
  end

  it "should traverse symlinked directories up to 1 level deep" do
    compiler = Compass::Compiler.new(Dir.pwd, File.join(fixture_path, 'stylesheets', 'symlinked'), nil, {})
    assert_equal compiler.sass_files, [
      File.join(Dir.pwd, "test/fixtures/stylesheets/symlinked/foo.sass"),
      File.join(Dir.pwd, "test/fixtures/stylesheets/symlinked/sub1/sub1-1/sub1-1.sass"),
      File.join(Dir.pwd, "test/fixtures/stylesheets/symlinked/sub1/sub1.sass"),
      File.join(Dir.pwd, "test/fixtures/stylesheets/symlinked/sub1/sub2/sub2.sass"),
      File.join(Dir.pwd, "test/fixtures/stylesheets/symlinked/sub2/sub2.sass"),
      File.join(Dir.pwd, "test/fixtures/stylesheets/symlinked/symlinked/sub1-1/sub1-1.sass"),
      File.join(Dir.pwd, "test/fixtures/stylesheets/symlinked/symlinked/sub1.sass"),
      File.join(Dir.pwd, "test/fixtures/stylesheets/symlinked/symlinked_foo.sass")
    ]
  end

end
