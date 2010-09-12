begin
  require 'sass'
rescue LoadError
  require 'rubygems'
  begin
    require 'sass'
  rescue LoadError
    puts "Unable to load Sass. Please install it with one of the following commands:"
    puts "  gem install sass --pre"
    raise
  end
end
