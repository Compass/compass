---
title: Sprite Magic Selectors
layout: tutorial
crumb: Magic Selectors
classnames:
  - tutorial
---
# Sprite Tutorial
<%= sprite_tutorial_links %>

## Magic Selectors

If you want to add selectors for your sprites, it's easy todo by adding `_active` `_target` or `_hover` to the file name, In the example below we have a sprite directory that looks like:

* `my-buttons/glossy.png`
* `my-buttons/glossy_hover.png`
* `my-buttons/glossy_active.png`
* `my-buttons/glossy_target.png`

Now in our sass file we add:

    @import "my-buttons/*.png";
    
    a {
      @include my-buttons-sprite(glossy)
    }

And your stylesheet will compile to:

    .my-buttons-sprite, a {
      background: url('/my-buttons-sedfef809e2.png') no-repeat;
    }

    a {
      background-position: 0 0;
    }
    a:hover, a.glossy_hover, a.glossy-hover {
      background-position: 0 -40px;
    }
    a:target, a.glossy_target, a.glossy-target {
      background-position: 0 -60px;
    }
    a:active, a.glossy_active, a.glossy-active {
      background-position: 0 -20;
    }

Alternatively you can use the `@include all-my-buttons-sprites;` after the import and get the following output:

    .my-buttons-sprite, .my-buttons-glossy {
      background: url('/my-buttons-sedfef809e2.png') no-repeat;
    }

    .my-buttons-glossy {
      background-position: 0 0;
    }
    .my-buttons-glossy:hover, .my-buttons-glossy.glossy_hover, .my-buttons-glossy.glossy-hover {
      background-position: 0 -40px;
    }
    .my-buttons-glossy:target, .my-buttons-glossy.glossy_target, .my-buttons-glossy.glossy-target {
      background-position: 0 -60px;
    }
    .my-buttons-glossy:active, .my-buttons-glossy.glossy_active, .my-buttons-glossy.glossy-active {
      background-position: 0 -20px;
    }

## Disabling

To disable this feature set `$disable-magic-sprite-selectors` to true before calling the sprite mixin

    a {
      $disable-magic-sprite-selectors:true;
      @include my-buttons-sprite(glossy)
    }
