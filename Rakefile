require 'rubygems'
if ENV["PKG"]
  $: << File.expand_path(File.dirname(__FILE__))+"/lib"
else
  require 'bundler'
  Bundler.setup 
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
  t.cucumber_opts = "features --format progress"
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
Rake::Task[:test].send(:add_comment, <<END)
To run with an alternate version of Rails, make test/rails a symlink to that version.
To run with an alternate version of Haml & Sass, make test/haml a symlink to that version.
END

Rake::TestTask.new :units do |t|
  t.libs << 'lib'
  t.libs << 'test'
  test_files = FileList['test/units/**/*_test.rb']
  test_files.exclude('test/rails/*', 'test/haml/*')
  t.test_files = test_files
  t.verbose = true
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
