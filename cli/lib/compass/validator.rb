begin
  require 'rubygems'
  require 'compass-validator'
rescue LoadError => e
  if e.message =~ /core_ext/
    raise Compass::MissingDependency, <<-ERRORMSG
The Compass CSS Validator is out of date. Please upgrade it:
sudo gem install compass-validator --version ">= 3.0.1"
ERRORMSG
  else
    raise Compass::MissingDependency, <<-ERRORMSG
The Compass CSS Validator could not be loaded. Please install it:
sudo gem install compass-validator
ERRORMSG
  end
end
