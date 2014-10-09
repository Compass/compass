require 'compass/sprites/importer'
require 'compass/sprites/version'
stylesheet_dir = File.expand_path('../../../stylesheets', __FILE__)
config = Compass::Configuration::Data.new("compass-sprites")
config.add_import_path(Compass::Sprites::Importer.new)
config.add_import_path(stylesheet_dir)
Compass.add_configuration(config)


Compass::Frameworks.register('sprite-framework',
 :stylesheets_directory => stylesheet_dir
)
