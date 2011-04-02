---
title: Lemonade Upgrade Guide
layout: tutorial
crumb: Lemonade Upgrade
classnames:
  - tutorial
---
# Lemonade Upgrade Guide
## Example 1

### Lemonade

    .logo {
      background: sprite-image("lemonade/lemonade-logo.png");
    }
    .lime {
      background: sprite-image("lemonade/lime.png");
    }
    .coffee {
      background: sprite-image("other-drinks/coffee.png") no-repeat;
    }
    
### Compass


    @import "lemonade/*.png";
    @import "other-drinks/*.png"
    @include all-lemonade-sprites;
    @include all-other-drinks-sprites;

Compass will return class names `.lemonade-logo`, `.lemonade-lime`, `.other-drinks-coffee`
    
    
# Example 2

### Lemonade

    .lemonade-example-1 {
      background: sprite-image("lemonade/example-1/blue-10x10.png", 10px, 2px);
    }

### Compass
  With compass you need to flatten the image directory to be `images/lemonade` instead of `images/lemonade/example-1`
  
    @import "lemonade/*.png"
  
    .lemonade-example-1 {
      @include lemonade-sprite(blue-10x10, true, 10px, 2px);
      background-color: yellow;
    }