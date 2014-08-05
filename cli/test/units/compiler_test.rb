require 'test_helper'
require 'fileutils'

class CompilerTest < Test::Unit::TestCase
  
  it "should strip css from file name and reappend" do
    config = Compass::Configuration::Data.new("test",
                                              :project_path => Dir.pwd,
                                              :sass_dir => "foo",
                                              :css_dir => "bar")
    config.extend(Compass::Configuration::Defaults)
    compiler = Compass.sass_compiler({}, config)
    assert_equal 'screen', compiler.stylesheet_name(File.join(Dir.pwd, 'foo', 'screen.css.scss'))
  end

end
