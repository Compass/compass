---
title: Sprite Customization
layout: tutorial
crumb: Customization
classnames:
  - tutorial
---
#Sprite Tutorial
<%= sprite_tutorial_links %>
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
