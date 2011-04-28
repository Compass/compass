---
title: Application Integration
layout: tutorial
crumb: Appliction Integration
classnames:
  - tutorial
---
# Application Integration

## Ruby on Rails

### Rails 3
    compass init rails /path/to/myrailsproject
### Rails 2.3
    rake rails:template LOCATION=http://compass-style.org/rails/installer
    
## Sinatra

    require 'sinatra'
    require 'haml'
    require 'sass'
    require 'compass'

    configure do
      Compass.configuration do |config|
        config.project_path = File.dirname(__FILE__)
        config.sass_dir = 'views'
      end

      set :haml, { :format => :html5 }
      set :sass, Compass.sass_engine_options
    end

    get '/screen.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass :screen
    end

If you keep your stylesheets in “views/stylesheets/” directory instead of just “views/”, remember to update sass_dir configuration accordingly.
Check out this [sample compass-sinatra project](http://github.com/chriseppstein/compass-sinatra) to get up and running in no time!

[Sinatra Bootstrap](http://github.com/adamstac/sinatra-bootstrap) - a base Sinatra project with support for Haml, Sass, Compass, jQuery and more.

## Nanoc3

### Minimal integration: just drop it in

One simple route for lightweight integration is to simply install compass inside nanoc. Then edit config.rb to point to the stylesheets you want to use. This means you have to have the Compass watch command running in a separate window from the Nanoc compilation process. 

Example project that works this way: http://github.com/unthinkingly/unthinkingly-blog

### More formal integration

At the top of the Nanoc Rules file, load the Compass configuration, like this:

    require 'compass'

    Compass.add_project_configuration 'compass/config.rb' # when using Compass 0.10
    Compass.configuration.parse 'compass/config.rb'       # when using Compass < 0.10

Your Compass configuration file (in compass/config.rb) could look like this (you may need to change the path to some directories depending on your directory structure):

    http_path    = "/" 
    project_path = "." 
    css_dir      = "output/assets/style" 
    sass_dir     = "content/assets/style" 
    images_dir   = "output/assets/images"

    # when using SCSS:
    sass_options = {
      :syntax => :scss
    }


To filter the stylesheets using Sass and Compass, call the sass filter with Sass engine options taken from Compass, like this:

    filter :sass, Compass.sass_engine_options


### Nanoc Projects using the formal approach

* [nanoc Bootstrap](http://github.com/adamstac/nanoc-bootstrap) - a base nanoc project with support for Haml, Sass, Compass, jQuery and more.
* [nanoc & Compass Example Project](http://github.com/ddfreyne/nanoc-bootstrap-compass)