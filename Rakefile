require 'rubygems'
if ENV["PKG"]
  $: << File.expand_path(File.dirname(__FILE__))+"/lib"
else
  require 'bundler'
  Bundler.setup
end

unless ENV['CI']
  require 'colorize'
  require 'fileutils'
end

begin
  require 'rake/dsl_definition'
rescue LoadError
  #pass
end
require 'compass'

# ----- Default: Testing ------

task :default => [:test, :features]

require 'rake/testtask'
require 'fileutils'

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

desc "Download the latest browser stats data."
task :caniuse do
  require 'uri'
  require 'net/http'
  require 'net/https'
  uri = URI.parse("https://raw.github.com/Fyrd/caniuse/master/data.json")
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  req = Net::HTTP::Get.new(uri.path)
  res = https.request(req)
  filename = File.join(File.dirname(__FILE__), "data", "caniuse.json")
  open(filename, "wb") do |file|
    file.write(res.body)
  end
  puts "#{filename} (#{res.body.size} bytes)"
end

desc "Compile Examples into HTML and CSS"
task :examples do
  linked_haml = "tests/haml"
  if File.exists?(linked_haml) && !$:.include?(linked_haml + '/lib')
    puts "[ using linked Haml ]"
    $:.unshift linked_haml + '/lib'
  end
  require 'haml'
  require 'sass'
  require 'pathname'
  require 'compass'
  require 'compass/exec'
  FileList['examples/*'].each do |example|
    next unless File.directory?(example)
    puts "\nCompiling #{example}"
    puts "=" * "Compiling #{example}".length
    Dir.chdir example do
      load "bootstrap.rb" if File.exists?("bootstrap.rb")
      Compass::Exec::SubCommandUI.new(%w(compile --force)).run!
    end
    # compile any haml templates to html
    FileList["#{example}/**/*.haml"].each do |haml_file|
      basename = haml_file[0..-6]
      engine = Haml::Engine.new(open(haml_file).read, :filename => haml_file)
      puts "     haml #{File.basename(basename)}"
      output = open(basename,'w')
      output.write(engine.render)
      output.close
    end
  end
end

namespace :examples do
  desc "clean up the example directories"
  task :clean do
    puts "Cleaning Examples"
    Dir.glob('examples/*/clean.rb').each do |cleaner|
      load cleaner
    end
  end
end

task "gemspec:generate" => "examples:clean"

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

begin
  require 'packager/rake_task'
  require 'compass/version'
  # Building a package:
  # 1. Get packager installed and make sure your system is setup correctly according to their docs.
  # 2. Make sure you are actually using a universal binary that has been nametooled.
  # 3. PKG=1 OFFICIAL=1 rake packager:pkg
  Packager::RakeTask.new(:pkg) do |t|
    t.package_name = "Compass"
    t.version = Compass::VERSION
    t.domain = "compass-style.org"
    t.bin_files = ["compass"]
    t.resource_files = FileList["frameworks/**/*"] + ["VERSION.yml", "LICENSE.markdown"]
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
        diff = diff.gsub(/^Only in .*\/css\/(.*)\:.*[^.css]/, '')
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