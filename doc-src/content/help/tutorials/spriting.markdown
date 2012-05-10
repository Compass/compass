---
title: Spriting with Compass
layout: tutorial
crumb: Spriting
classnames:
  - tutorial
---

# Spriting with Compass

Spriting has never been easier with Compass. You place the sprite images in a folder,
import them into your stylesheet, and then you can use the sprite in your selectors in one
of several convenient ways.

## Sprite Tutorial Contents
<%= sprite_tutorial_links(true) %>

## Setup

For this tutorial, let's imagine that in your project's image folder there are four icons:

* `images/my-icons/new.png`
* `images/my-icons/edit.png`
* `images/my-icons/save.png`
* `images/my-icons/delete.png`

Each is an icon that is 32px square.
<a name="basic-usage"></a>
## Basic Usage

****Note**: The use of `icon` is only for this example, "icon" represents the folder name that contains your sprites.

The simplest way to use these icon sprites is to let compass give you a class for each sprite:
    
    @import "my-icons/*.png";
    @include all-my-icons-sprites;

And you'll get the following CSS output:

    .my-icons-sprite,
    .my-icons-delete,
    .my-icons-edit,
    .my-icons-new,
    .my-icons-save   { background: url('/images/my-icons-s34fe0604ab.png') no-repeat; }
    
    .my-icons-delete { background-position: 0 0; }
    .my-icons-edit   { background-position: 0 -32px; }
    .my-icons-new    { background-position: 0 -64px; }
    .my-icons-save   { background-position: 0 -96px; }

You can now apply the `my-icons-XXX` classes to your markup as needed.

Let's go over what happened there. The import statement told compass to [generate a
stylesheet that is customized for your sprites](https://gist.github.com/729507). This
stylesheet is [magic](#magic-imports), it is not written to disk, and it can be customized
by setting configuration variables before you import it. See the section below on
[Customization Options](customization-options). The goal of this stylesheet is to provide a
simple naming convention for your sprites so that you they are easy to remember and use. You
should never have to care what the is name of the generated sprite map, nor where a sprite
is located within it.

<a name='nested-folders' id='nested-folders'></a>    
## Nested Folders    

****Note**: The use of `orange` is only for this example, "icon" represents the folder name that contains your sprites.

Sprites stored in a nested folder will use the last folder name in the path as the sprite name.

Example:

      @import "themes/orange/*.png";
      @include all-orange-sprites;
    
<a name="selector-control" id="selector-control"></a>
## Selector Control

****Note**: The use of `icon` is only for this example, "icon" represents the folder name that contains your sprites.

If you want control over what selectors are generated, it is easy to do. In this example,
this is done by using the magic `my-icons-sprite` mixin. Note that the mixin's name is dependent
on the name of the folder in which you've placed your icons.

    @import "my-icons/*.png";
    
    .actions {
      .new    { @include my-icons-sprite(new);    }
      .edit   { @include my-icons-sprite(edit);   }
      .save   { @include my-icons-sprite(save);   }
      .delete { @include my-icons-sprite(delete); }
    }

And your stylesheet will compile to:

    .my-icons-sprite,
    .actions .new,
    .actions .edit,
    .actions .save,
    .actions .delete { background: url('/images/my-icons-s34fe0604ab.png') no-repeat; }
    
    .actions .new    { background-position: 0 -64px; }
    .actions .edit   { background-position: 0 -32px; }
    .actions .save   { background-position: 0 -96px; }
    .actions .delete { background-position: 0 0;     }

<a name="sass_functions" id="sass_functions"></a>
## Sass Functions

****Note**: The use of `icon` is only for this example, "icon" represents the folder name that contains your sprites.

Getting the image dimensions of a sprite

You can get a unit value by using the magical dimension functions `<map>-sprite-height` and `<map>-sprite-width`
If you are looking to just return the dimensions see the [docs](/reference/compass/utilities/sprites/base/#mixin-sprite-dimensions)

Example:


    @import "icon/*.png";
    $box-padding: 5px;
    $height: icon-sprite-height(some_icon);
    $width: icon-sprite-width(some_icon);
    
    .somediv {
      height:$height + $box-padding;
      width:$width + $box-padding;
    }
  
  
<a name="magic-imports" id="magic-imports"></a>
## Magic Imports

****Note**: The use of `icon` is only for this example, "icon" represents the folder name that contains your sprites.

As noted above, compass will magically create sprite stylesheets for you. Some people like
magic, some people are scared by it, and others are curious about how the magic works. If
you would like to avoid the magic, you can use compass to generate an import for you. On the
command line:

    compass sprite "images/my-icons/*.png"

This will create file using your project's preferred syntax, or you can specify the
output filename using the `-f` option and the syntax will be inferred from the extension.
If you do this, you'll need to remember to regenerate the import whenever you rename, add,
or remove sprites.

Using the magic imports is recommended for most situations. But there are times when you
might want to avoid it. For instance, if your sprite map has more than about 20 to 30
sprites, you may find that hand crafting the import will speed up compilation times. See
the section on [performance considerations](#performance) for more details.

<a name="performance" id="performance"></a>
## Performance Considerations

Reading PNG files and assembling new images and saving them to disk might have a non-trivial
impact to your stylesheet compilation times. Especially for the first compile. Please keep
this in mind.

## Large numbers of sprites
The magic stylesheet can get very large when there are large numbers of sprites. 50 sprites
will cause there to be over 150 variables created and then passed into the
`sprite-map` [function](/reference/compass/helpers/sprites/#sprite-map).
You may find that customizing the sprite function call to only pass those values that you
are overriding will provide a small performance boost.
See a [concrete example](https://gist.github.com/747970).

## Oily PNG

Compass generates PNG files using a pure-ruby library called
[`chunky_png`](https://github.com/wvanbergen/chunky_png). This library can be made faster by
installing a simple C extension called [`oily_png`](https://github.com/wvanbergen/oily_png).
Add it to your `Gemfile` if you have one in your project:

    gem 'oily_png'

Or install the Rubygem:

    gem install oily_png

Compass will automatically detect its presence.
