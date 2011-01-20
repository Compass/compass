path = "#{File.dirname(__FILE__)}/lib"
require File.join(path, 'compass/version')

Gem::Specification.new do |gemspec|
  gemspec.name = "compass"
  gemspec.version = Compass::VERSION # Update the VERSION.yml file to set this.
  gemspec.date = "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}" # Automatically update for each build
  gemspec.description = "Compass is a Sass-based Stylesheet Framework that streamlines the creation and maintainance of CSS."
  gemspec.homepage = "http://compass-style.org"
  gemspec.authors = ["Chris Eppstein", "Eric A. Meyer", "Brandon Mathis", "Nico Hagenburger"]
  gemspec.email = "chris@eppsteins.net"
  gemspec.default_executable = "compass"
  gemspec.executables = %w(compass)
  gemspec.has_rdoc = false
  gemspec.require_paths = %w(lib)
  gemspec.rubygems_version = "1.3.5"
  gemspec.summary = %q{A Real Stylesheet Framework}

  gemspec.add_dependency 'sass', '>= 3.1.0.alpha.50'
  gemspec.add_dependency 'chunky_png', '~> 0.12.0'

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

