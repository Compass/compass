source 'https://rubygems.org'

gemspec unless defined?(CI)

unless ENV['PKG']

  gem "sass", :git => "https://github.com/nex3/sass.git", :branch => "stable"
  gem "compass-core", :path => "../core" unless defined?(CI)
  gem "compass-import-once", :path => "../import-once" unless defined?(CI)
  gem "cucumber", "~> 1.2.1"
  gem "rspec", "~> 2.0.0"
  gem "compass-validator", "3.0.1"
  gem "css_parser", "~> 1.0.1"
  gem "rubyzip", "0.9.9"
  gem 'mocha', '0.11.4'
  gem 'diff-lcs', '~> 1.1.2'
  gem 'rake'
  gem 'json', '~> 1.7.7', :platforms => :ruby_18
  gem 'true', ">= 0.2.0"

  # Warning be carful adding OS dependant gems above this line it will break the CI server please
  # place them below so they are excluded

  unless ENV["CI"]
    gem 'rb-fsevent'
    gem 'ruby_gntp'
    gem "ruby-prof", :platforms => :mri_18
    gem "rcov", :platforms => :mri_18
    gem 'guard'
    gem 'guard-test'
    gem 'guard-cucumber'
    gem 'packager'
    gem 'colorize'
  end
end
