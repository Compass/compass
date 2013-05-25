source 'https://rubygems.org'

gemspec unless defined?(CI)

unless ENV['PKG']

  gem "cucumber", "~> 1.2.1"
  gem "rspec", "~> 2.0.0"
  gem "compass-validator", "3.0.1"
  gem "css_parser", "~> 1.0.1"
  gem "rubyzip"
  gem 'mocha', '0.11.4'
  gem 'diff-lcs', '~> 1.1.2'
  gem 'rake', '~> 0.9.2'

  # Warning be carful adding OS dependant gems above this line it will break the CI server please
  # place them below so they are excluded

  unless ENV["CI"]
    gem 'rb-fsevent'
    gem 'ruby_gntp'
    gem "ruby-prof", :platform => :mri_18
    gem "rcov", :platform => :mri_18
    gem 'guard'
    gem 'guard-test'
    gem 'guard-cucumber'
    gem 'packager'
  end
end
