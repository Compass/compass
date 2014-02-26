path = "#{File.dirname(__FILE__)}/lib"
require File.join(path, 'compass/version')

Gem::Specification.new do |gemspec|
  gemspec.name = "compass"
  gemspec.version = Compass::VERSION # Update VERSION file to set this.
  gemspec.description = "Compass is a Sass-based Stylesheet Framework that streamlines the creation and maintenance of CSS."
  gemspec.homepage = "http://compass-style.org"
  gemspec.authors = ["Chris Eppstein", "Scott Davis", "Eric M. Suzanne", "Brandon Mathis", "Nico Hagenburger"]
  gemspec.email = "chris@eppsteins.net"
  gemspec.executables = %w(compass)
  gemspec.require_paths = %w(lib)
  gemspec.rubygems_version = "1.3.5"
  gemspec.summary = %q{A Real Stylesheet Framework}

  gemspec.add_dependency 'sass', '~> 3.3.0.rc.3'
  gemspec.add_dependency 'compass-core', "~> #{File.read(File.join(File.dirname(__FILE__),"..","core","VERSION")).strip}"
  gemspec.add_dependency 'compass-import-once', "~> #{File.read(File.join(File.dirname(__FILE__),"..","import-once","VERSION")).strip}"
  gemspec.add_dependency 'chunky_png', '~> 1.2'
  gemspec.add_dependency 'listen', '~> 1.1.0'
  gemspec.add_dependency 'json'

  gemspec.post_install_message = <<-MESSAGE
    Compass is charityware. If you love it, please donate on our behalf at http://umdf.org/compass Thanks!
  MESSAGE

  gemspec.files = %w(LICENSE.markdown VERSION Rakefile)
  gemspec.files += Dir.glob("bin/*")
  gemspec.files += Dir.glob("data/**/*")
  gemspec.files += Dir.glob("frameworks/**/*")
  gemspec.files += Dir.glob("lib/**/*")
  gemspec.files += Dir.glob("test/**/*.*")
  gemspec.files -= Dir.glob("test/fixtures/stylesheets/*/saved/**/*.*")
  gemspec.test_files = Dir.glob("test/**/*.*")
  gemspec.test_files -= Dir.glob("test/fixtures/stylesheets/*/saved/**/*.*")
  gemspec.test_files += Dir.glob("features/**/*.*")
end

