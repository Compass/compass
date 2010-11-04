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
`@import "compass/css3/box-shadow-v2"` or `@import "compass/css/version-2"`. Once you have
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
