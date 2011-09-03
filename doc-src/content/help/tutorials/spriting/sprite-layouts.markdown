---
title: Sprite layouts
layout: tutorial
crumb: Sprite layouts
classnames:
  - tutorial
---
# Sprite layouts

## Vertical

    @import "mysprite/*.png";

Example Output:

![Vertical Example](/images/tutorials/sprites/layout/vert.png)
## Horizontal

    $mysprite-layout:horizontal;
    @import "mysprite/*.png";

Example Output:

![Horizontal Example](/images/tutorials/sprites/layout/horizontal.png)

Notes:

  * Responds to the same configuration options that vertical has.
  
## Diagonal

    $mysprite-layout:diagonal;
    @import "mysprite/*.png";

Example Output:

![Diagonal Example](/images/tutorials/sprites/layout/diagonal.png)

Notes:

  * Configuration options do not effect the layout
  * This is incredibly resource intensive on the browser

## Smart

    $mysprite-layout:smart;
    @import "mysprite/*.png";

Example Output:

![Smart Example](/images/tutorials/sprites/layout/smart.png)

Notes:

  * Configuration options do not effect the layout
  * Most efficient use of browser memory

Example icons from [Open Icon Library](http://openiconlibrary.sourceforge.net/) and are released under public domain