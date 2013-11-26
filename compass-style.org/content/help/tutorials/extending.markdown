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

### Requirements

A sprite engine requires two methods `construct_sprite`, and `save(filename)`

Once inside the class you have access to `images` which is a collection of [Compass::SassExtensions::Sprites::Image](http://rdoc.info/github/chriseppstein/compass/dda7c9/Compass/SassExtensions/Sprites/Image)

### Configuration 

To enable your sprite engine from the config file set
    
    sprite_engine = :<engine name>

The example below will load `Compass::SassExtension::Sprites::ChunkyPngEngine.new(width, height, images)`

    sprite_engine = :chunky_png

### Class Definition

    module Compass
      module SassExtensions
        module Sprites
          class ChunkyPngEngine < Compass::SassExtensions::Sprites::Engine

            def construct_sprite
              #do something
            end    
        
            def save(filename)
              #save file
            end
        
          end
        end
      end
    end

<a name="adding-configuration-properties"></a>
## Adding Configuration Properties to Compass

To add a new configuration property to Compass:

    Compass::Configuration.add_configuration_property(:foobar, "this is a foobar") do
      if environment == :production
        "foo"
      else
        "bar"
      end
    end

This will do several things:

1. make it possible for users to set the `foobar` configuration property in their
   configuration file.
2. Ruby code can read and write the `foobar` attribute from any configuration object.
3. It will add the comment `# this is a foobar` above the property in the configuration file.
   A comment is not required, you can simply omit this argument if you like.
4. The block of code provided allows you to assign a sensible default value according to other
   settings in the configuration or by using arbitrary code to determine what the value should
   be. For instance it could read from another configuration file or it could change based on
   the user's operating system.