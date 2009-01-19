require  File.dirname(__FILE__)+'/test_helper'
require 'fileutils'
require 'compass'
require 'compass/exec'

class CommandLineTest < Test::Unit::TestCase
  include Compass::TestCaseHelper
  def test_basic_install
    within_tmp_directory do
      compass "basic"
      assert File.exists?("basic/src/screen.sass")
      assert File.exists?("basic/stylesheets/screen.css")
      assert_action_performed :directory, "basic/"
      assert_action_performed    :create, "basic/src/screen.sass"
      assert_action_performed   :compile, "basic/src/screen.sass"
      assert_action_performed    :create, "basic/stylesheets/screen.css"
    end
  end

  def test_framework_installs
    Compass::Frameworks::ALL.each do |framework|
      within_tmp_directory do
        compass *%W(--framework #{framework.name} #{framework.name}_project)
        assert File.exists?("#{framework.name}_project/src/screen.sass")
        assert File.exists?("#{framework.name}_project/stylesheets/screen.css")
        assert_action_performed :directory, "#{framework.name}_project/"
        assert_action_performed    :create, "#{framework.name}_project/src/screen.sass"
        assert_action_performed   :compile, "#{framework.name}_project/src/screen.sass"
        assert_action_performed    :create, "#{framework.name}_project/stylesheets/screen.css"
      end
    end
  end

  def test_basic_update
    within_tmp_directory do
      compass "basic"
      Dir.chdir "basic" do
        compass
        assert_action_performed :compile, "src/screen.sass"
        assert_action_performed :overwrite, "stylesheets/screen.css"
      end
    end
  end

  # def test_rails_install
  #   within_tmp_directory do
  #     generate_rails_app("compass_rails")
  #     Dir.chdir "compass_rails" do
  #       compass "--rails"
  #     end
  #   end
  # rescue LoadError
  #   puts "Skipping rails test. Couldn't Load rails"
  # end

  protected
  def compass(*arguments)
    @last_result = capture_output do
      execute *arguments
    end
  end

  def assert_action_performed(action, path)
    @last_result.split("\n").each do |line|
      line = line.split
      return if line.first == action.to_s && line.last == path
    end
    fail "Action #{action.inspect} was not performed on: #{path}"
  end

  def within_tmp_directory(dir = "tmp")
    d = absolutize(dir)
    FileUtils.mkdir_p(d)
    Dir.chdir(d) do
      yield
    end
  ensure
    FileUtils.rm_r(d)
  end

  def capture_output
    real_stdout, $stdout = $stdout, StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = real_stdout
  end

  def execute(*arguments)
    Compass::Exec::Compass.new(arguments).run!
  end

  # def generate_rails_app(name)
  #   `rails #{name}`
  # end
end