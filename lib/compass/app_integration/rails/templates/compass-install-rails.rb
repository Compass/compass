# =================================================================
# Compass Ruby on Rails Installer (template) v.1.0
# written by Derek Perez (derek@derekperez.com)
# -----------------------------------------------------------------
# NOTE: This installer is designed to work as a Rails template,
# and can only be used with Rails 2.3+.
# -----------------------------------------------------------------
# Copyright (c) 2009 Derek Perez
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# =================================================================

# Determine if we use sudo, defaults to true unless we are
# on win32, cygwin, or mingw32 or they ask us not to
def sudo_is_an_option?
  return false if RUBY_PLATFORM =~ /(win|w)32$/ # true if win32, cygwin or mingw32
  return false if ENV['NO_SUDO'] =~ /true/i
  return true
end

puts "==================================================="
puts "Welcome to the Compass Installer for Ruby on Rails!"
puts "==================================================="
puts

# css framework prompt
css_framework = ask("What CSS Framework install do you want to use with Compass?")

# sass storage prompt
sass_dir = ask("Where would you like to keep your sass files within your project? (default: 'app/stylesheets')")
sass_dir = "app/stylesheets" if sass_dir.blank?

# compiled css storage prompt
css_dir = ask("Where would you like Compass to store your compiled css files? (default: 'public/stylesheets/compiled')")
css_dir = "public/stylesheets/compiled" if css_dir.blank?

# use sudo for gem commands?
use_sudo = nil
if sudo_is_an_option? # dont give them the option if they are on a system that can't use sudo (aka windows)
  use_sudo = yes?("Use sudo for the gem commands? (the default for your system is #{sudo_is_an_option? ? 'yes' : 'no'})")
end
use_sudo = sudo_is_an_option? if use_sudo.blank?

# define dependencies
gem "haml", :version => ">=3.0.0"
gem "compass", :version => ">= 0.10.0"

# install and unpack
rake "gems:install GEM=haml --trace", :sudo => use_sudo
rake "gems:install GEM=compass --trace", :sudo => use_sudo
rake "gems:unpack GEM=compass --trace"

# build out compass command
compass_command = "compass init rails . --css-dir=#{css_dir} --sass-dir=#{sass_dir} "
compass_command << "--using #{css_framework} " unless css_framework.blank?

# integrate it!
run "haml --rails ."
run compass_command
