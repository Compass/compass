$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'compass'
require 'spec'
require 'spec/autorun'

IMAGES_TMP_PATH = File.join(File.dirname(__FILE__), 'images-tmp')
Lemonade.images_path = IMAGES_TMP_PATH

Spec::Runner.configure do |config|
  
end
