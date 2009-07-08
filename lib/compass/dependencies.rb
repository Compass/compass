unless defined?(Sass)
  require 'rubygems'
  begin
    gem 'haml','>= 2.2.0'
  rescue Exception
    $stderr.puts "WARNING: haml 2.2 gem not found. Trying to find haml on the load path."
  end
  require 'sass'
end