---
title: Compass v0.11 Upgrade
layout: tutorial
crumb: Upgrading to v0.11
classnames:
  - tutorial
---
# Upgrading to the Compass Antares Release (v0.11)

Many mixins and certain uses of mixins have been deprecated, but your
existing stylesheets should still work out of the box with one exception:
users who are using the `css3/transform` module should update their imports
to import `css/transform-legacy` when they upgrade. They should then upgrade
to the new `css/transform` module at their convenience.

You should read about what changed, update your stylesheets accordingly
and then update your imports to the new version.

<a name="box-shadow"></a>
## Box Shadow
You may get a deprecation warning using the `box-shadow` mixin.
You can resolve this in one of the following ways:

1. Change your use of the `box-shadow` and instead use `single-box-shadow`.
   This mixin has the same behavior and arguments as the old `box-shadow` mixin.
2. Keep using `box-shadow`, change how you pass the arguments. The new
   `box-shadow` takes up to 10 comma-delimited shadows. Each shadow is
   how the values should appear in the CSS (space separated).

<a name="text-shadow"></a>
## Text Shadow

You may get a deprecation warning using the `text-shadow` mixin.
You can resolve this in one of the following ways:

1. Change your use of the `text-shadow` and instead use `single-text-shadow`.
   This mixin has the same behavior and arguments as the old `text-shadow` mixin.
2. Keep using `text-shadow`, change how you pass the arguments. The new
   `text-shadow` takes up to 10 comma-delimited shadows. Each shadow is
   how the values should appear in the CSS (space separated).

<a name="transform"></a>
## CSS Transforms
The transform module was largely re-written to support 3D transforms. If you
are using it, it is suggested that you read the [new module's documentation][new_transform]
and adjust your code appropriately. Many mixin names and constants have changed.
For your convenience, the [old CSS transform module][old_transform] can still be imported, but it
is deprecated and will be removed in the next release.

<a name="gradients"></a>
## Gradients

The Compass gradient support now more closely emulates the CSS3 specification of how gradients
are represented and passed around. The `linear-gradient` and `radial-gradient` mixins
have been deprecated and instead, you should use the `linear-gradient()` and `radial-gradient()`
functions in conjunction with mixins for the [properties that support gradients][image_stylesheet] like
`background` / `background-image`, `border-image`, `list-style` / `list-style-image`,
and `content`.

After upgrading, you'll receive deprecation warnings for your usage of the old gradient
mixins and a suggested replacement value for each. If you'd rather keep the old mixins in
your project for convenience, just copy the following to your project after changing your imports:

    @mixin radial-gradient($color-stops, $center-position: center center, $image: false) {
      @include background-image($image, radial-gradient($center-position, $color-stops));
    }
    @mixin linear-gradient($color-stops, $start: top, $image: false) {
      @include background-image($image, linear-gradient($start, $color-stops));
    }

Or for sass files:

    =radial-gradient($color-stops, $center-position: center center, $image: false)
      +background-image($image, radial-gradient($center-position, $color-stops))
    
    =linear-gradient($color-stops, $start: top, $image: false)
      +background-image($image, linear-gradient($start, $color-stops))

<a name="typography"></a>
## Typography Module

With the addition of vertical-rhythms to the compass core, we have created a new
[typography module][typography_module], and moved several items that were formerly
listed as "utilities" into it. The moved modules are "links", "lists" and "text".
These will all remain part of the basic compass include, but if you were including 
them individually in your stylesheets, you will need to adjust the include paths
as follows:

* "compass/utilities/links" becomes "compass/typography/links"
* "compass/utilities/lists" becomes "compass/typography/lists"
* "compass/utilities/text" becomes "compass/typography/text"


[new_transform]: /reference/compass/css3/transform/
[old_transform]: /reference/compass/css3/transform-legacy/
[image_stylesheet]: /reference/compass/css3/images/
[typography_module]: /reference/compass/typography/