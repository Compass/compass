require 'test_helper'
require 'fileutils'
require 'compass'
require 'compass/logger'
require 'sass/plugin'

class CompassTest < Test::Unit::TestCase

  def setup
    Compass.reset_configuration!
  end

  def teardown
    [:blueprint, :empty, :compass, :image_urls, :relative].each do |project_name|
      ::FileUtils.rm_rf tempfile_path(project_name)
    end
  end

  def test_on_stylesheet_saved_callback
    saved = false
    path = nil
    config = nil
    before_compile = Proc.new do |config|
      config.on_stylesheet_saved {|filepath| path = filepath; saved = true }
    end
    within_project(:blueprint, before_compile)
    assert saved, "Stylesheet callback didn't get called"
    assert path.is_a?(String), "Path is not a string. Got: #{path.class.name}"
  end

  # no project with errors exists to test aginst - leep of FAITH!
  # *chriseppstein flogs himself*
  def test_on_stylesheet_error_callback
      error = false
      file = nil
      before_compile = Proc.new do |config|
        config.on_stylesheet_error {|filename, message| file = filename; error = true }
      end
      within_project(:error, before_compile) rescue nil;
      assert error, "Project did not throw a compile error"
      assert file.is_a?(String), "Filename was not a string"
    end

  def test_empty_project
    # With no sass files, we should have no css files.
    within_project(:empty) do |proj|
      return unless proj.css_path && File.exists?(proj.css_path)
      Dir.new(proj.css_path).each do |f|
        fail "This file should not have been generated: #{f}" unless f == "." || f == ".."
      end
    end
  end

  def test_blueprint
    within_project(:blueprint) do |proj|
      each_css_file(proj.css_path) do |css_file|
        assert_no_errors css_file, :blueprint
      end
      each_sass_file do |sass_file|
        assert_renders_correctly sass_file, :ignore_charset => true
      end
    end
  end

  def test_compass
    within_project('compass') do |proj|
      each_css_file(proj.css_path) do |css_file|
        assert_no_errors css_file, 'compass'
      end
      each_sass_file do |sass_file|
        assert_renders_correctly sass_file, :ignore_charset => true
      end
    end
  end

  def test_env_in_development
    within_project('envtest', lambda {|c| c.environment = :development }) do |proj|
      each_css_file(proj.css_path) do |css_file|
        assert_no_errors css_file, 'envtest'
      end
      each_sass_file do |sass_file|
        assert_renders_correctly sass_file, :ignore_charset => true, :environment => "development"
      end
    end
  end

  def test_env_in_production
    within_project('envtest', lambda {|c| c.environment = :production }) do |proj|
      each_css_file(proj.css_path) do |css_file|
        assert_no_errors css_file, 'envtest'
      end
      each_sass_file do |sass_file|
        assert_renders_correctly sass_file, :ignore_charset => true, :environment => "production"
      end
    end
  end

  def test_busted_image_urls
    within_project('busted_image_urls') do |proj|
      each_css_file(proj.css_path) do |css_file|
        assert_no_errors css_file, 'busted_image_urls'
      end
      each_sass_file do |sass_file|
        assert_renders_correctly sass_file
      end
    end
  end

  def test_image_urls
    within_project('image_urls') do |proj|
      each_css_file(proj.css_path) do |css_file|
        assert_no_errors css_file, 'image_urls'
      end
      each_sass_file do |sass_file|
        assert_renders_correctly sass_file
      end
    end
  end

  def test_relative
    within_project('relative') do |proj|
      each_css_file(proj.css_path) do |css_file|
        assert_no_errors css_file, 'relative'
      end
      each_sass_file do |sass_file|
        assert_renders_correctly sass_file
      end
    end
  end

private
  def assert_no_errors(css_file, project_name)
    file = css_file[(tempfile_path(project_name).size+1)..-1]
    msg = "Syntax Error found in #{file}. Results saved into #{save_path(project_name)}/#{file}"
    assert_equal 0, open(css_file).readlines.grep(/Sass::SyntaxError/).size, msg
  end

  def assert_renders_correctly(*arguments)
    options = arguments.last.is_a?(Hash) ? arguments.pop : {}
    for name in arguments
      actual_result_file = "#{tempfile_path(@current_project)}/#{name}.css"
      expected_result_file = "#{result_path(@current_project)}/#{name}.css"
      actual_lines = File.read(actual_result_file)
      actual_lines.gsub!(/^@charset[^;]+;/,'') if options[:ignore_charset]
      actual_lines = actual_lines.split("\n").reject{|l| l=~/\A\Z/}
      expected_lines = ERB.new(File.read(expected_result_file)).result(binding)
      expected_lines.gsub!(/^@charset[^;]+;/,'') if options[:ignore_charset]
      expected_lines = expected_lines.split("\n").reject{|l| l=~/\A\Z/}
      expected_lines.zip(actual_lines).each_with_index do |pair, line|
        if pair.first == pair.last
          assert(true)
        else
          assert false, "Error in #{result_path(@current_project)}/#{name}.css:#{line + 1}\n"+diff_as_string(pair.first.inspect, pair.last.inspect)
        end
      end
      if expected_lines.size < actual_lines.size
        assert(false, "#{actual_lines.size - expected_lines.size} Trailing lines found in #{actual_result_file}.css: #{actual_lines[expected_lines.size..-1].join('\n')}")
      end
    end
  end

  def within_project(project_name, config_block = nil)
    @current_project = project_name
    Compass.add_configuration(configuration_file(project_name)) if File.exists?(configuration_file(project_name))
    Compass.configuration.project_path = project_path(project_name)
    Compass.configuration.environment = :production
    args = Compass.configuration.to_compiler_arguments(:logger => Compass::NullLogger.new)

    if config_block
      config_block.call(Compass.configuration)
    end

    if Compass.configuration.sass_path && File.exists?(Compass.configuration.sass_path)
      compiler = Compass::Compiler.new *args
      compiler.clean!
      compiler.run
    end
    yield Compass.configuration if block_given?
  rescue
    save_output(project_name)
    raise
  end

  def each_css_file(dir, &block)
    Dir.glob("#{dir}/**/*.css").each(&block)
  end

  def each_sass_file(sass_dir = nil)
    sass_dir ||= template_path(@current_project)
    Dir.glob("#{sass_dir}/**/*.s[ac]ss").each do |sass_file|
      yield sass_file[(sass_dir.length+1)..-6]
    end
  end

  def save_output(dir)
    FileUtils.rm_rf(save_path(dir))
    FileUtils.cp_r(tempfile_path(dir), save_path(dir)) if File.exists?(tempfile_path(dir))
  end

  def project_path(project_name)
    absolutize("fixtures/stylesheets/#{project_name}")
  end

  def configuration_file(project_name)
    File.join(project_path(project_name), "config.rb")
  end

  def tempfile_path(project_name)
    File.join(project_path(project_name), "tmp")
  end

  def template_path(project_name)
    File.join(project_path(project_name), "sass")
  end

  def result_path(project_name)
    File.join(project_path(project_name), "css")
  end

  def save_path(project_name)
    File.join(project_path(project_name), "saved")
  end

end
