---
title: Extending Compass
layout: tutorial
crumb: Extending Compass
classnames:
  - tutorial
---

# Extending Compass

## Sprite engine

The sprite engine is the work horse of sprite generation it's the interface for assembling and writing the image file to disk.

## Requirments

A sprite engine requires only one method and that is `construct_sprite` which must return an object that responds to `save(filepath)`

Once inside this method you have access to `images` which is a collection of [Compass::SassExtensions::Sprites::Image](http://rdoc.info/github/chriseppstein/compass/dda7c9/Compass/SassExtensions/Sprites/Image)

Since the Engine module extends base you also have access to all methods in [Compass::SassExtensions::Sprites::Base](http://rdoc.info/github/chriseppstein/compass/dda7c9/Compass/SassExtensions/Sprites/Base)

### Configuration 

To enable your sprite engine from the config file set
    
    sprite_engine = :<engine name>
    
The example below will load `Compass::SassExtension::Sprites::ChunkyPngEngine`

    sprite_engine = :chunky_png
    

### Class Definition

    module Compass
      module SassExtensions
        module Sprites
          module <engine name>Engine

            # Returns an object
            def construct_sprite
              #must return a image object that responds to save(filename)
            end

          end
        end
      end
    end
