require 'compass/sprites/importer'
require 'compass/sprites/version'
config = Compass::Configuration::Data.new("compass-sprites")
config.add_import_path(Compass::Sprites::Importer.new)
puts config.inspect
Compass.add_configuration(config)
