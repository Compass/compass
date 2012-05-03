path = "#{File.dirname(__FILE__)}/lib"
require File.join(path, 'compass/version')

Gem::Specification.new do |gemspec|
  gemspec.name = "compass"
  gemspec.date = Date.today
  gemspec.version = Compass::VERSION # Update VERSION.yml file to set this.
  gemspec.description = "Compass is a Sass-based Stylesheet Framework that streamlines the creation and maintainance of CSS."
  gemspec.homepage = "http://compass-style.org"
  gemspec.authors = ["Chris Eppstein", "Scott Davis", "Eric A. Meyer", "Brandon Mathis", "Anthony Short", "Nico Hagenburger"]
  gemspec.email = "chris@eppsteins.net"
  #gemspec.default_executable = "compass" #deprecated
  gemspec.executables = %w(compass)
  #gemspec.has_rdoc = false #deprecated
  gemspec.require_paths = %w(lib)
  gemspec.rubygems_version = "1.3.5"
  gemspec.summary = %q{A Real Stylesheet Framework}

  gemspec.add_dependency 'sass', '~> 3.1'
  gemspec.add_dependency 'chunky_png', '~> 1.2'
  gemspec.add_dependency 'fssm', '>= 0.2.7'

  gemspec.files = %w(README.markdown LICENSE.markdown VERSION.yml Rakefile)
  gemspec.files += Dir.glob("bin/*")
  gemspec.files += Dir.glob("examples/**/*.*")
  gemspec.files -= Dir.glob("examples/**/*.css")
  gemspec.files -= Dir.glob("examples/**/*.html")
  gemspec.files -= Dir.glob("examples/*/extensions/**/*")
  gemspec.files += Dir.glob("examples/css3/extensions/fancy-fonts/**/*")
  gemspec.files -= Dir.glob("examples/*/stylesheets/**/*.*")
  gemspec.files += Dir.glob("frameworks/**/*")
  gemspec.files += Dir.glob("lib/**/*")
  gemspec.files += Dir.glob("test/**/*.*")
  gemspec.files -= Dir.glob("test/fixtures/stylesheets/*/saved/**/*.*")
  gemspec.test_files = Dir.glob("test/**/*.*")
  gemspec.test_files -= Dir.glob("test/fixtures/stylesheets/*/saved/**/*.*")
  gemspec.test_files += Dir.glob("features/**/*.*")
end

