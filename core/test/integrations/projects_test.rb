#! /usr/bin/env ruby
test_directory = File.expand_path(File.dirname(__FILE__))
$: << test_directory unless $:.include? test_directory
require 'test_helper'
require 'fileutils'
require 'compass/core'
require 'sass/plugin'
require 'pathname'
require 'true'
require 'timecop'

class ProjectsTest < Minitest::Test
  def setup
    Compass.reset_configuration!
  end

  def verbose?
    false
  end

  def test_compass
    compile_project("compass", &method(:standard_checks))
  end

  def test_busted_font_urls
    compile_project("busted_font_urls", {:style => :compact}, &method(:standard_checks))
  end

  def test_relative
    compile_project("relative", {:style => :compact}, &method(:standard_checks))
  end

  def test_valid
    compile_project("valid", {:line_comments => true, :style => :expanded}, &method(:standard_checks))
  end

  def test_busted_image_urls
    compile_project("busted_image_urls", {:style => :compact}, &method(:standard_checks))
  end

  def test_envtest
    Timecop.travel(Time.local(2013, "nov", 4, 12, 0)) do
      compile_project("envtest", &method(:standard_checks))
    end
  end

  def test_image_urls
    compile_project("image_urls", {:style => :compact}, &method(:standard_checks))
  end

  def test_uses_only_stylesheets_ext
    compile_project("uses_only_stylesheets_ext", {:style => :expanded}, &method(:standard_checks))
  end

private

  def standard_checks(compiler)
    compiler.on_updated_stylesheet do |sass, css, map|
      sass_file = Pathname.new(sass).relative_path_from(
                    Pathname.new(template_path(@current_project))).to_s
      if verbose?
        puts "sass_file = #{sass_file} (#{(((Time.now - @last_compile) - (@last_compile - @diff_start)) * 1000).round}ms)"
      end
      @diff_start = Time.now
      assert_renders_correctly sass_file, :ignore_charset => true
      @last_compile = Time.now
    end
    compiler.on_compilation_error do |error, sass, css|
      raise error
    end
  end

  def assert_renders_correctly(*arguments)
    options = arguments.last.is_a?(Hash) ? arguments.pop : {}
    for name in arguments
      actual_result_file = "#{tempfile_path(@current_project)}/#{name}".gsub(/s[ac]ss/, "css")
      expected_result_file = "#{result_path(@current_project)}/#{name}.#{Sass.version[:major]}.#{Sass.version[:minor]}".gsub(/s[ac]ss/, "css")
      expected_result_file = "#{result_path(@current_project)}/#{name}".gsub(/s[ac]ss/, "css") unless File.exists?(expected_result_file)
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
          assert false, "Error in #{actual_result_file}:#{line + 1}\n"+diff_as_string(pair.first.inspect, pair.last.inspect)
        end
      end
      if expected_lines.size < actual_lines.size
        assert(false, "#{actual_lines.size - expected_lines.size} Trailing lines found in #{actual_result_file}: #{actual_lines[expected_lines.size..-1].join('\n')}")
      end
    end
  end

  def compile_project(project_name, options = {})
    @last_compile = Time.now
    @diff_start = Time.now
    @current_project = project_name
    options = {
      :always_update => true,
      :load_paths => [],
      :sourcemap => false
    }.merge(options)
    options.update(
      :css_location => tempfile_path(project_name),
      :template_location => template_path(project_name)
    )
    options[:load_paths] = (load_paths + options[:load_paths] + sass_path_env).uniq
    compiler = Sass::Plugin::Compiler.new(options)
    yield compiler
    compiler.update_stylesheets
  rescue
    save_output(project_name)
    raise
  ensure
    @current_project = nil
  end

  def sass_path_env
    (ENV['SASSPATH'] || "").split(File::PATH_SEPARATOR).select {|d| File.directory?(d)}
  end

  def each_css_file(dir, &block)
    Dir.glob("#{dir}/**/*.css").each(&block)
  end

  def load_paths
    [Compass::Core.base_directory("stylesheets")]
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

  def projects
    Dir.glob(File.join(projects_path, "*")).map do |project_path|
      File.dirname(project_path)
    end
  end

  def projects_path
    File.join(File.dirname(__FILE__), "projects")
  end

  def project_path(project_name)
    File.join(projects_path, project_name)
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
