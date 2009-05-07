unless defined?(Sass)
  require 'rubygems'
  begin
    gem 'haml-edge','>= 2.1'
  rescue Exception
    $stderr.puts "WARNING: haml-edge gem not found. Trying to find haml on the load path."
  end
  require 'sass'
end