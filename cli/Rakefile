sh "git checkout lib/compass/generated_version.rb"
require 'rubygems'
require 'rubygems/package_task'
require 'rake/testtask'
require 'fileutils'


if ENV["PKG"]
  $: << File.expand_path(File.dirname(__FILE__))+"/lib"
else
  require 'bundler/setup'
end

unless ENV['CI']
  require 'colorize'
  require 'fileutils'
end

begin
  require 'rake/dsl_definition'
rescue LoadError
  # pass
end

# ----- Default: Testing ------
task :default => [:test, :features]

begin
  require 'cucumber'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    #t.cucumber_opts = %w{--format progress}
  end
rescue LoadError
  $stderr.puts "cannot load cucumber"
end

Rake::TestTask.new :test do |t|
  t.libs << 'lib'
  t.libs << 'test'
  test_files = FileList['test/**/*_test.rb']
  test_files.exclude('test/rails/*', 'test/haml/*')
  t.test_files = test_files
  t.verbose = true
end

Rake::TestTask.new :units do |t|
  t.libs << 'lib'
  t.libs << 'test'
  test_files = FileList['test/units/**/*_test.rb']
  test_files.exclude('test/rails/*', 'test/haml/*')
  t.test_files = test_files
  t.verbose = true
end

Rake::TestTask.new :integrations do |t|
  t.libs << 'lib'
  t.libs << 'test'
  test_files = FileList['test/integrations/**/*_test.rb']
  test_files.exclude('test/rails/*', 'test/haml/*')
  t.test_files = test_files
  t.verbose = true
end

namespace :git do
  task :clean do
    sh "git", "clean", "-fdx"
  end
end


begin
  require 'cucumber/rake/task'
  require 'rcov/rcovtask'
  namespace :rcov do
    Cucumber::Rake::Task.new(:cucumber) do |t|
      t.rcov = true
      t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
      t.rcov_opts << %[-o "coverage"]
    end

    Rcov::RcovTask.new(:units) do |rcov|
      rcov.libs << 'lib'
      test_files = FileList['test/**/*_test.rb']
      test_files.exclude('test/rails/*', 'test/haml/*')
      rcov.pattern    = test_files
      rcov.output_dir = 'coverage'
      rcov.verbose    = true
      rcov.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
      rcov.rcov_opts << %[-o "coverage" --sort coverage]
    end


    desc "Run both specs and features to generate aggregated coverage"
    task :all do |t|
      rm "coverage.data" if File.exist?("coverage.data")
      Rake::Task["rcov:units"].invoke
      Rake::Task["rcov:cucumber"].invoke
    end
  end
rescue LoadError => e
  puts "WARNING: #{e}"
end

namespace :test do
  debug = false
  desc "update test expectations if needed"
  task :update do
    Rake::Task['test:update:fixtures'].invoke
  end
  task :debug do
    debug = true
    Rake::Task['test:update:fixtures'].invoke
  end
  namespace :update do
    EXPECTED = 'css'
    TMP = 'tmp'
    #desc "update fixture expectations for test cases if needed"
    task :fixtures do
      fixtures = File.join('test/fixtures/stylesheets/compass'.split('/'))
      # remove any existing temporary files
      FileUtils.rm_rf(File.join(File.dirname(__FILE__), fixtures, TMP, '.'))
      # compile the fixtures
      puts "checking test cases..."
      CHECKMARK = "\u2713 "
      filter = debug ? '--trace' : "| grep 'error.*#{fixtures}'"
      errors = %x[compass compile #{fixtures} #{filter}]
      # check for compilation errors
      if not errors.empty?
        puts "Please fix the following errors before proceeding:".colorize(:red) if not debug
        puts errors
      else
        # check to see what's changed
        diff = %x[diff -r #{File.join(fixtures, EXPECTED, '')} #{File.join(fixtures, TMP, '')}]
        # ignore non-CSS files in css/
        diff.gsub!(/^Only in .*\/css\/(.*)\:.*[^.]/, '')
        if diff.empty?
          puts "#{CHECKMARK}Cool! Looks like all the tests are up to date".colorize(:green)
        else
          puts "The following changes were found:"
          puts "===================================="
          # check for new or removed expectations
          diff.scan(/^Only in .*\/(#{EXPECTED}|#{TMP})\/(.*)\: (.*).css/).each do |match|
            config = (match[0] == TMP) ? [:green, '>', 'NEW TEST'] : [:red, '<', 'DELETED']
            puts "[#{File.join(match[1], match[2])}]  #{config[2].colorize(config[0])}".colorize(:cyan)
            new_file = File.join(File.dirname(__FILE__), fixtures, match[0], match[1], match[2]) + '.css'
            puts File.read(new_file).gsub(/^(.*)/, config[1] + ' \1').colorize(config[0])
          end
          diff = diff.gsub(/^diff\s\-r\s.*\/tmp\/(.*).css/, '[\1]'.colorize(:cyan))
          diff = diff.gsub(/^Only in .*\n?/, '')
          diff = diff.gsub(/^(\<.*)/, '\1'.colorize(:red))
          diff = diff.gsub(/^(\>.*)/, '\1'.colorize(:green))
          diff = diff.gsub(/^(\d+.*)/, '\1'.colorize(:cyan))
          puts diff
          puts "===================================="
          puts "Are all of these changes expected? [y/n]".colorize(:yellow)
          if (($stdin.gets.chomp)[0] == 'y')
            FileUtils.rm_rf(File.join(File.dirname(__FILE__), fixtures, EXPECTED, '.'))
            FileUtils.cp_r(File.join(File.dirname(__FILE__), fixtures, TMP, '.'), File.join(File.dirname(__FILE__), fixtures, EXPECTED))
            puts "#{CHECKMARK}Thanks! The test expectations have been updated".colorize(:green)
          else
            puts "Please manually update the test cases and expectations".colorize(:red)
          end
        end
      end
    end
  end
end

# Release tasks
gemspec_file = FileList['compass.gemspec'].first
spec = eval(File.read(gemspec_file), binding, gemspec_file)
spec.files.delete("VERSION")
spec.files.delete("VERSION_NAME")

def spec.bump!
  segments = version.to_s.split(".")
  segments[-1] = segments.last.succ
  self.version = Gem::Version.new(segments.join("."))
end

# Set SAME_VERSION when moving to a new major version and you want to specify the new version
# explicitly instead of bumping the current version.
# E.g. rake build SAME_VERSION=true
spec.bump! unless ENV["SAME_VERSION"]

desc "Run tests and build compass-#{spec.version}.gem"
task :build => [:default, :gem]

task :gem => :release_version

task :release_version do
  open("lib/compass/generated_version.rb", "w") do |f|
    f.write(<<VERSION_EOF)
module Compass
  VERSION = "#{spec.version}"
  VERSION_NAME = "#{File.read('VERSION_NAME').strip}"
end
VERSION_EOF
  end
end

desc "Make the prebuilt gem compass-#{spec.version}.gem public."
task :publish => [:record_version, :push_gem, :tag]

desc "Build & Publish version #{spec.version}" 
task :release => [:build, :publish]

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

desc "Record the new version in version control for posterity"
task :record_version do
  unless ENV["SAME_VERSION"]
    open(FileList["VERSION"].first, "w") do |f|
      f.write(spec.version.to_s)
    end
    sh "git add VERSION"
    sh "git checkout lib/compass/generated_version.rb"
    sh %Q{git commit -m "Bump version to #{spec.version}."}
  end
end

desc "Tag the repo as #{spec.version} and push the code and tag."
task :tag do
  sh "git tag -a -m 'Version #{spec.version}' #{spec.version}"
  sh "git push --tags origin #{`git rev-parse --abbrev-ref HEAD`}"
end

desc "Push compass-#{spec.version}.gem to the rubygems server"
task :push_gem do
  sh "gem push pkg/compass-#{spec.version}.gem"
end

