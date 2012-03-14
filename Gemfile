source :rubygems

gemspec

unless ENV['PKG']
gem "cucumber", "~> 1.1.4"
gem "rspec", "~>2.0.0"
gem "rails", "~> 3.1"
gem "compass-validator", "3.0.1"
gem "css_parser", "~> 1.0.1"
gem "sass", "~> 3.1"
gem "haml", "~> 3.1"
gem "rubyzip"
gem 'mocha'
gem 'diff-lcs', '~> 1.1.2'
gem 'rake', '~> 0.9.2'

# Warning becarful adding OS dependant gems above this line it will break the CI server please 
# place them below so they are excluded

unless ENV["CI"]
  gem 'rb-fsevent'
  gem 'growl_notify'
  gem "ruby-prof", :platform => :mri_18
  gem "rcov", :platform => :mri_18
  gem 'guard'
  gem 'guard-test'
  gem 'guard-cucumber'
  gem 'packager'
end
end
