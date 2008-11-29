require  File.dirname(__FILE__)+'/test_helper'
require 'fileutils'
require 'compass'

class CompassTest < Test::Unit::TestCase
  def setup
    mkdir_clean absolutize("tmp")
    mkdir_clean absolutize("tmp/blueprint")
    mkdir_clean tempfile_loc("default")
    mkdir_clean tempfile_loc("yui")
    @original_options = Sass::Plugin.options
  end
  
  def teardown
    FileUtils.rm_rf absolutize("tmp")
    FileUtils.rm_rf absolutize("tmp/blueprint")
    FileUtils.rm_rf tempfile_loc("default")
    FileUtils.rm_rf tempfile_loc("yui")
    Sass::Plugin.options = @original_options
  end

  def test_blueprint_generates_no_files
    Sass::Plugin.options[:template_location][template_loc('default')] = tempfile_loc('default')
    Sass::Plugin.update_stylesheets

    Dir.new(absolutize("tmp/blueprint")).each do |f|
      fail "This file is not expected: #{f}" unless f == "." || f == ".."
    end
    
  end

  def test_default
    with_templates('default') do
      each_css_file(tempfile_loc('default')) do |css_file|
        assert_no_errors css_file, 'default'
      end
    end
  end
  def test_yui
    with_templates('yui') do
      each_css_file(tempfile_loc('yui')) do |css_file|
        assert_no_errors css_file, 'yui'
      end
    end
  end
  private
  def assert_no_errors(css_file, folder)
    file = css_file[(tempfile_loc(folder).size+1)..-1]
    msg = "Syntax Error found in #{file}. Results saved into #{save_loc(folder)}/#{file}"
    assert_equal 0, open(css_file).readlines.grep(/Sass::SyntaxError/).size, msg
  end

  def with_templates(folder)
    old_template_loc = Sass::Plugin.options[:template_location]
    Sass::Plugin.options[:template_location] = old_template_loc.dup
    begin
      Sass::Plugin.options[:template_location][template_loc(folder)] = tempfile_loc(folder)
      Compass::Frameworks::ALL.each do |framework|
        Sass::Plugin.options[:template_location][framework.stylesheets_directory] = tempfile_loc(folder)
      end
      Sass::Plugin.update_stylesheets
      yield
    ensure
      Sass::Plugin.options[:template_location] = old_template_loc
    end
  rescue
    save_output(folder)    
    raise
  end
  
  def each_css_file(dir)
    Dir.glob("#{dir}/**/*.css").each do |css_file|
      yield css_file
    end
  end

  def save_output(dir)
    FileUtils.rm_rf(save_loc(dir))
    FileUtils.cp_r(tempfile_loc(dir), save_loc(dir))
  end

  def mkdir_clean(dir)
    begin
      FileUtils.mkdir dir
    rescue Errno::EEXIST
      FileUtils.rm_r dir
      FileUtils.mkdir dir
    end
  end

  def tempfile_loc(folder)
    absolutize("fixtures/#{folder}/tmp")
  end
  
  def template_loc(folder)
    absolutize("fixtures/#{folder}/templates")
  end
  
  def result_loc(folder)
    absolutize("fixtures/#{folder}/results")
  end
  
  def save_loc(folder)
    absolutize("fixtures/#{folder}/saved")
  end

  def absolutize(path)
    if path.blank?
      File.dirname(__FILE__)
    elsif path[0] == ?/
      "#{File.dirname(__FILE__)}#{path}"
    else
      "#{File.dirname(__FILE__)}/#{path}"
    end
  end
end