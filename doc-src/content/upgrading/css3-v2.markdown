---
title: Upgrading to the Compass CSS3 API Version 2
crumb: CSS3 API Upgrade
classnames:
  - tutorial
layout: tutorial
---

The Compass CSS3 API is the easiest way to take advantage of the advanced CSS3 capabilities
offered by modern browsers. The initial version (v1) of the Compass CSS3 API is now more than
1 year old and the specification continues to evolve. The Compass team is dedicated to keeping
our library up-to-date so that you can continue to stay at the fore-front of modern web design.
To this end, a new version of the CSS3 API has been created for the compass v0.11 release. The
old version of the API still exists and works, but some aspects of the old API are now
deprecated and will be removed v0.12. This document will guide you through the steps that
are required to stay up to date.

<a name="box-shadow"></a>
## Box Shadow

The `box-shadow` mixin API has been changed. To upgrade to the new box shadow API, you should
`@import "compass/css3/box-shadow-v2"` or `@import "compass/css3/version-2"`. Once you have
changed your imports, it is expected that you have migrated your code to the new version,
until then, you will receive a deprecation warning from each place in your code where you use
deprecated mixins.
 
Two new mixins are now provided:

1. `single-box-shadow` - This is the old version of the box shadow mixin renamed.
   It is optimized for creating a single box shadow with nice defaults that result
   in approximately what you're expecting when you think of a box shadow and allow
   for simple overriding of defaults using keyword-style arguments.
2. `multiple-box-shadow` - This mixin allows you to specify up to 10 shadows to be
   applied. Each argument to this mixin is a space delimited list of values specifying
   a shadow.

Additionally, the `box-shadow` mixin is now a shortcut for the `multiple-box-shadow`
mixin because this most closely matches the CSS3 specification.
   
To upgrade, you have two choices:

1. Change the mixin from `box-shadow` to `single-box-shadow` and keep the arguments
   unchanged. For instance:
   
       @include box-shadow(darken($border_color, 40), 5px, 5px, 2px, 3px, inset)
   
   would now become:
   
       @include single-box-shadow(darken($border_color, 40), 5px, 5px, 2px, 3px, inset)
   
2. Keep including the `box-shadow` mixin but update the arguments to be a space delimited
   list. For instance:
   
       @include box-shadow(darken($border_color, 40), 5px, 5px, 2px, 3px, inset)
   
   would now become:
   
       @include box-shadow(inset 5px 5px 2px 3px darken($border_color, 40))

<a name="transform"></a>
## Transform

The `transform` mixin API has been changed. To upgrade to the new transform API, you should
`@import "compass/css3/transform-v2"` or `@import "compass/css3/version-2"`. Once you have
changed your imports, it is expected that you have migrated your code to the new version.
Until then, you will receive a deprecation warning from each place in your code where you are
using a deprecated mixin.

There are several major changes to _how_ the transform mixins are built, to help accomodate
3D transforms while managing the complexity of the options. The old API had few enough options
that the main `transform` mixin listed them all as arguments. The new API for the same mixin
expects a single string with all your transforms listed as they would be in CSS. There are also
two new mixins to handle backwards compatability, and people who preffer long lists of arguments:

1. `create-transform` - This is a full list of all the possible arguments that can be used in a
   2 or 3D transform, including origin coordinates and so on. It's a bit overwhelming in scope,
   and not the recommended technique.

2. `simple-transform` - This mixin is compatable with the old API, and is optimized for some basic
   2D transforms. To keep your old transforms in place, simply rename them from `transform` to 
   `simple-transform`.

For the sake of managing complexity and more closely mimicing css, origin settings have been removed 
from all the other transform mixins. Origins should be set directly with the `transform-origin` mixin.

Because we now support both 2D and 3D transforms, and these transforms overlapp while having different
browser support lists, it became important to let you select which browsers you are targeting with each
transform. With the 3D transforms it is clear, but the 2D transform mixins now all include a final argument
that toggles (true/false) between the full list of 2D-supporting browsers, and the shorter list of
3D-supporting browsers. The argument '3D-only' argument defaults to `false` (2D). You only need to worry 
about this if you have 2D transforms that you only want applied in a 3D context.

In a 3D context you have the additional issue of perspective. The `perspective` mixin can be set on a
parent element to define the 3D stage for all it's decendants, but perspective can also be set on an
element-by-element basis. Because the latter option happens within the transform property (and must be
the first value in the CSS), a `perspective` argument has also been added to all the relevant 
transform mixins.

To update your generic `transform` mixins, you have two opions:

1. Change the mixin name from `transform` to `simple-transform` and keep the arguments unchanged. For instance:

       @include transform(1.5, 45deg, 1em, 2em, 5deg, -5deg, 100%, 0%)
   
   would now become:
   
       @include simple-transform(1.5, 45deg, 1em, 2em, 5deg, -5deg, 100%, 0%)

2. Keep including the `transform` mixin, but update the arguments to be a space delimited list of transforms. 
   You may need to split out a distinct transform-origin mixin with this approach. For instance:

       @include transform(1.5, 45deg, 1em, 2em, 5deg, -5deg, 100%, 0%)

   would now become:

       @include transform(scale(1.5) rotate(45deg) translateX(1em) translateY(2em) skewX(5deg) skewY(-5deg))
       @include transform-origin(100%, 0%)

To upgrade your transform partials (`scale`, `rotate`, `translate`, `skew` and related mixins) you only have one option.
You need to strip any transform-origin arguments into their own mixin, as above.

The full set of mixins is now as follows:

* `transform-origin` - ( _[ origin-x, origin-y, origin-z, 3D-only ]_ )
  * `transform-origin2d` - a shortcut for 2D origins with only x and y arguments, automatically targets 2D browsers
  * `transform-origin3d` - a shortcut for 3D origins with x, y and z arguments, automatically targets 3D browsers
  * `apply-origin` - ( origin _[, 3D-only ]_ ) uses a single, space-delimited argument for the coordinates

* `transform` - ( transforms _[, 3D-only ]_ )
  * `transform2d`, `transform3d` - shortcuts that automatically target the 2D or 3D browser lists
  * `simple-transform`, `create-transform` - longform mixins that take 1 argument per transform option

* `perspective` - ( perspective )
  * `perspective-origin` - the 'viewer location' set as coordinates

* `transform-style` - ( style )
  - 'flat' or 'preserves-3d'

* `backface-visibility` - ( _[ visibility ]_ )
  - 'visible' or 'hidden'

* `scale` - ( _[ scale-x, scale-y, perspective, 3D-only ]_ )
  * `scaleX`, `scaleY` - shortcuts for the basic 2D scaling
  * `scaleZ`, `scale3d` - shortcuts for the 3D options

* `rotate` - ( _[ rotation, perspective, 3D-only ]_ )
  * `rotateX`, `rotateY` - shortcuts for 3D rotations on the x and y axis
  * `rotate3d` - takes three 'vector' arguments that create the axis, and a fourth argument for the angle of rotation

* `translate` - ( _[ translate-x, translate-y, perspective, 3D-only ]_ )
  * `translateX`, `translateY` - shortcuts for the basic 2D translations
  * `translateZ`, `translate3d` - shortcuts for the 3D options

* `skew` - ( _[ skew-x, skew-y, 3D-only ]_ )
  * `skewX`, `skewY` - shortcuts for skewing along a single axis

Many of the arguments are optional because of default settings that you can override in your code.
Here is a full list of the defaults:

    // Transform Origin
    $default-originx    : 50%               !default; 
    $default-originy    : 50%               !default;
    $default-originz    : 50%               !default;

    // Scale
    $default-scalex     : 1.25              !default;
    $default-scaley     : $default-scalex   !default;
    $default-scalez     : $default-scalex   !default;

    // Rotate
    $default-rotate     : 45deg             !default;

    // Rotate3d
    $default-vectorx    : 1                 !default;
    $default-vectory    : 1                 !default;
    $default-vectorz    : 1                 !default;

    // Translate
    $default-transx     : 1em               !default;
    $default-transy     : $default-transx   !default;
    $default-transz     : $default-transx   !default;

    // Skew
    $default-skewx      : 5deg              !default;
    $default-skewy      : 5deg              !default;

Transforms can be quite complex and difficult to understand properly, but there are many good blog
posts on the topic if you need help. Enjoy!

