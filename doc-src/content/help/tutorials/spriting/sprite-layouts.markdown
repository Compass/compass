---
title: Sprite layouts
layout: tutorial
crumb: Sprite layouts
classnames:
  - tutorial
---
# Sprite Tutorial
<%= sprite_tutorial_links %>
<a name='sorting'>
## Sorting

Default is `none` sprites will be orderd however they are recived from the file system

You can sort by:

* width
* height
* size
* name
* none

Example

    $my-sprite-sort-by : 'width';

Default search direction is acending if you wish to sort decending prepend a `!` 

    $my-sprite-sort-by : '!width';


## Sprite Layouts

Example:

    $icon-layout:horizontal;
    @import "icon/*.png";
    
    $dropcap-layout:diagonal
    @import "dropcap/*.png";

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