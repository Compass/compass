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

## Setup

For this tutorial, let's imagine that in your project's image folder there are four icons:

* `public/images/icon/new.png`
* `public/images/icon/edit.png`
* `public/images/icon/save.png`
* `public/images/icon/delete.png`

Each is an icon that is 32px square.

## Basic Usage
The simplest way to use these icon sprites is to let compass give you a class for each sprite:
    
    @import "icon/*.png";
    @include all-icon-sprites;

And you'll get the following CSS output:

    .icon-sprite,
    .icon-delete,
    .icon-edit,
    .icon-new,
    .icon-save   { background: url('/images/icon-34fe0604ab.png') no-repeat; }
    
    .icon-delete { background-position: 0 0; }
    .icon-edit   { background-position: 0 -32px; }
    .icon-new    { background-position: 0 -64px; }
    .icon-save   { background-position: 0 -96px; }

You can now apply the `icon-XXX` classes to your markup as needed.

Let's go over what happened there. The import statement told compass to [generate a
stylesheet that is customized for your sprites](https://gist.github.com/729507). This
stylesheet is [magic](#magic-imports), it is not written to disk, and it can be customized
by setting configuration variables before you import it. See the section below on
[Customization Options](#customization-options). The goal of this stylesheet is to provide a
simple naming convention for your sprites so that you they are easy to remember and use. You
should never have to care what the is name of the generated sprite map, nor where a sprite
is located within it.

<a name="selector-control"></a>
## Selector Control

If you want control over what selectors are generated, it is easy to do. In this example,
this is done by using the magic `icon-sprite` mixin. Note that the mixin's name is dependent
on the name of the folder in which you've placed your icons.

    @import "icon/*.png";
    
    .actions {
      .new    { @include icon-sprite(new);    }
      .edit   { @include icon-sprite(edit);   }
      .save   { @include icon-sprite(save);   }
      .delete { @include icon-sprite(delete); }
    }

And your stylesheet will compile to:

    .icon-sprite,
    .actions .new,
    .actions .edit,
    .actions .save,
    .actions .delete { background: url('/images/icon-34fe0604ab.png') no-repeat; }
    
    .actions .new    { background-position: 0 -64px; }
    .actions .edit   { background-position: 0 -32px; }
    .actions .save   { background-position: 0 -96px; }
    .actions .delete { background-position: 0 0;     }

<a name="magic-imports"></a>
## Magic Imports

As noted above, compass will magically create sprite stylesheets for you. Some people like
magic, some people are scared by it, and others are curious about how the magic works. If
you would like to avoid the magic, you can use compass to generate an import for you. On the
command line:

    compass sprite "public/images/icon/*.png"

This will create file using your project's preferred syntax, or you can specify the
output filename using the `-f` option and the syntax will be inferred from the extension.
If you do this, you'll need to remember to regenerate the import whenever you rename, add,
or remove sprites.

Using the magic imports is recommended for most situations. But there are times when you
might want to avoid it. For instance, if your sprite map has more than about 20 to 30
sprites, you may find that hand crafting the import will speed up compilation times. See
the section on [performance considerations](#performance) for more details.

<a name="magic-selectors"></a>
## Magic Selectors

If you want to add selectors for your sprites, it's easy todo by adding `_active` `_target` or `_hover` to the file name, In the example below we have a sprite directory that looks like:

* `selectors/ten-by-ten.png`
* `selectors/ten-by-ten_hover.png`
* `selectors/ten-by-ten_active.png`
* `selectors/ten-by-ten_target.png`
    
Now in our sass file we add:

    @import "selectors/*.png";
    
    a {
      @include selectors-sprite(ten-by-ten)
    }
    
And your stylesheet will compile to:

    .selectors-sprite, a {
      background: url('/selectors-edfef809e2.png') no-repeat;
    }

    a {
      background-position: 0 0;
    }
    a:hover, a.ten-by-ten_hover, a.ten-by-ten-hover {
      background-position: 0 -20px;
    }
    a:target, a.ten-by-ten_target, a.ten-by-ten-target {
      background-position: 0 -30px;
    }
    a:active, a.ten-by-ten_active, a.ten-by-ten-active {
      background-position: 0 -10px;
    }

Alternatively you can use the `@include all-selectors-sprites;` after the import and get the following output:

    .selectors-sprite, .selectors-ten-by-ten {
      background: url('/selectors-edfef809e2.png') no-repeat;
    }

    .selectors-ten-by-ten {
      background-position: 0 0;
    }
    .selectors-ten-by-ten:hover, .selectors-ten-by-ten.ten-by-ten_hover, .selectors-ten-by-ten.ten-by-ten-hover {
      background-position: 0 -20px;
    }
    .selectors-ten-by-ten:target, .selectors-ten-by-ten.ten-by-ten_target, .selectors-ten-by-ten.ten-by-ten-target {
      background-position: 0 -30px;
    }
    .selectors-ten-by-ten:active, .selectors-ten-by-ten.ten-by-ten_active, .selectors-ten-by-ten.ten-by-ten-active {
      background-position: 0 -10px;
    }



<a name="customization-options"></a>
## Customization Options

### Options per Sprite Map

When constructing the sprite map, the entire sprite map and it's associated stylesheet
can be configured in the following ways. Each option is specified by setting a [configuration
variable](/help/tutorials/configurable-variables/) before importing the sprite. The variables
are named according to the name of the folder containing the sprites. In the examples below
the sprites were contained within a folder called `icon`.

* `$<map>-spacing` -- The amount of transparent space, in pixels, around each sprite.
  Defaults to `0px`. E.g. `$icon-spacing: 20px`.
* `$<map>-repeat` -- Wether or not each sprite should repeat along the x axis. Defaults
  to `no-repeat`. E.g. `$icon-repeat: repeat-x`.
* `$<map>-position` -- The position of the sprite in the sprite map along the x-axis. Can
  be specified in pixels or percentage of the sprite map's width. `100%` would cause the
  sprite to be on the right-hand side of the sprite map. Defaults to `0px`.
  E.g. `$icon-position: 100%`.
* `$<map>-sprite-dimensions` -- Whether or not the dimensions of the sprite should be
  included in each sprite's CSS output. Can be `true` or `false`. Defaults to `false`.
* `$<map>-sprite-base-class` -- The base class for these sprites. Defaults to `.<map>-sprite`.
  E.g. `$icon-sprite-base-class: ".action-icon"`
* `$<map>-clean-up` -- Whether or not to removed the old sprite file when a new one is created. Defaults to true

### Options per Sprite

When constructing the sprite map, each sprite can be configured in the following ways:

* `$<map>-<sprite>-spacing` -- The amount of transparent space, in pixels, around the sprite. Defaults
  to the sprite map's spacing which defaults to `0px`. E.g. `$icon-new-spacing: 20px`.
* `$<map>-<sprite>-repeat` -- Wether or not the sprite should repeat along the x axis. Defaults
  to the sprite map's repeat which defaults to `no-repeat`. E.g. `$icon-new-repeat: repeat-x`.
* `$<map>-<sprite>-position` -- The position of the sprite in the sprite map along the x-axis. Can
  be specified in pixels or percentage of the sprite map's width. `100%` would cause the
  sprite to be on the right-hand side of the sprite map. Defaults to the sprite map's
  position value which defaults to `0px`. E.g. `$icon-new-position: 100%`.

<a name="performance"></a>
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