---
title: Sprite Magic Selectors
layout: tutorial
crumb: Magic Selectors
classnames:
  - tutorial
---
#Sprite Tutorial
<%= sprite_tutorial_links %>

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
      background: url('/selectors-sedfef809e2.png') no-repeat;
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
      background: url('/selectors-sedfef809e2.png') no-repeat;
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
    
## Disabling
  To disable this feature set `$disable-magic-sprite-selectors` to true before calling the sprite mixin
  
    a {
      $disable-magic-sprite-selectors:true;
      @include selectors-sprite(ten-by-ten)
    }
  

