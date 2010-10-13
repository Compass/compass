$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'compass'
require 'rspec'
require 'rspec/autorun'

IMAGES_TMP_PATH = File.join(File.dirname(__FILE__), 'images-tmp')
Compass::Sprites.images_path = IMAGES_TMP_PATH
