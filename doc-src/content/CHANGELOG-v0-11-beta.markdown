---
title: Compass v0.11.0 Beta History
crumb: CHANGELOG
body_id: changelog
layout: article
---

0.11.beta.8 (UNRELEASED)
------------------------

* Created an official API to add configuration options to compass.
  [More information](/help/tutorials/extending/).

0.11.beta.7 (04/16/2011)
------------------------
* Added support for the new webkit gradient syntax that matches the css3 specification.
  Support for older webkit browsers remains enabled at this time.
  To disable it, set `$support-for-original-webkit-gradients` to false.
* There is a new mixin for creating
  [pure-css grid backgrounds](/reference/compass/layout/grid_background/)
  for verifying grid alignment for both fixed and fluid grids.
* Add support for pixel-based gradients in the original webkit gradient syntax.
* Added a vertical rhythm function for calculating rhythms without returning a property.

0.11.beta.6 (04/10/2011)
------------------------
* Added support for degree-based linear and radial gradients (not yet supported for SVG gradients)
* Added opera prefix support for linear and radial gradients.
* The CSS3 `background` mixin's "simple" background that came
  before the prefixed versions has been removed. If you
  need to target css2 background it is recommended that you set a
  the background property before calling the `background` mixin
  or you can call the `background-with-css2-fallback` if you want
  keep using compass's automatic simplification of the arguments.
* Bug fixes
* Fixed and issue with the compass gemspec in rubygems 1.7
* Fixed a bug with sprite imports

0.11.beta.5 (03/27/2011)
------------------------

### Compass Sprites

[Magic Selectors](/help/tutorials/spriting/#magic-selectors) have been added

Fixed a bug causing a stack level too deep in ruby 1.8.7

0.11.beta.4 (03/25/2011)
------------------------

* Extensions that are installed into ~/.compass/extensions will be automatically available to all your compass projects.

### Compass Internals

* Fixed a small bug in callbacks that was causing them to register twice
* The Sprite classes have been abstracted allowing for different engines
* Bumped chunky_png version to 1.1.0
* Total rewrite of the sprite generation classes - thanks to [@johnbintz](https://github.com/johnbintz) for the help
* More Rspec tests

0.11.beta.3 (03/15/2011)
------------------------

### Compass CSS3

* A new CSS3 mixin for [appearance](/reference/compass/css3/appearance/) was added.
* The font-face mixin has been updated again with the [syntax recommendations
  from font-spring](http://www.fontspring.com/blog/the-new-bulletproof-font-face-syntax).
  The API has not changed.

### Compass Typography

* Some text-based mixins have been moved from utilities to the new
  typography module. The old imports are deprecated now.
  Affected modules: utilities/links, utilities/lists, and utilities/text and
  their sub-modules.
* There is a new typography module: [Vertical Rhythm](/reference/compass/typography/vertical_rhythm/).
  This makes it easier to align the typography of your page to a common rhythm.

### Compass Utilities

* A new mixin `reset-float` is available in the [float module](/reference/compass/utilities/general/float/#mixin-reset-float) that makes it easier to reset the floats introduced from that module.
* A new mixin `reset-float` is available in the [float module](/reference/compass/utilities/general/float/#mixin-reset-float) that makes it easier to reset the floats introduced from that module.
* A new module has been added to create readable text against an arbitrary background color based on the lightness of the background: [compass/utilities/color/contrast](/reference/compass/utilities/color/contrast/).
* The comma-delimited-list has been renamed to delimited-list and
  generalized to accept a delimiter which defaults to a comma.
  The old function continues to exist, but is deprecated.

### Compass Internals

* You can now register callbacks for compilation events so that you can take
  custom actions when they occur. For instance, you might want to notify
  Growl when a stylesheet compilation error occurs.
* Bug fixes & performance improvements.

0.11.beta.2 (02/01/2011)
------------------------
* Updated the font-face mixin so it works in Android 2.2.
  Credit: [Paul Irish](http://paulirish.com/).
* The deprecated & unused arguments to the font-face mixin have been removed.

0.11.beta.1 (01/17/2011)
------------------------
* Add an option `--skip-overrides` to the sprite
  subcommand. When provided, the default variables for overriding the sprite
  behavior are not created. Instead, you would change the call to
  `sprite-map()` to customize your sprite map.
* Rename the `sprite-position` mixin in the new `sprite/base` module to
  `sprite-background-position` in order avoid a naming conflict with the old
  sprite module.

0.11.beta.0 (01/09/2011)
------------------------

Compass v0.11 is now feature complete. Future changes to this release will be doc improvements, bug fixes, performance tuning, and addressing user feedback.

* Added optional support for IE8 with $legacy-support-for-ie8 which defaults to true.
* Updated the opacity and filter-gradient mixins to make IE's hacky DirectX filters
  optional based on Compass's legacy support settings.
* Added the ability to piggy back on compass's watcher within your configuration file.
  See the [configuration reference](/help/tutorials/configuration-reference/) for details.
* The options passed to the CLI can now be inspected within the compass configuration file.
  The CLI options will still override the values set within the config file, but they might
  inform other values. For instance `compass compile -e production` will have the environment
  parameter preset to `:production` so that you can set other values in the project accordingly.
* New infrastructure for supporting experimental css3 functions that are prefixed but have the same
  syntax across all browsers. It is now possible to configure which browsers support which
  experimental functions outside of the compass release cycle. For details, see the
  [cross browser helpers](/reference/compass/helpers/cross-browser/).
* [Blueprint] Added a new sass function called span($n) to the grid module which replaces
  the now **deprecated span mixin**. If you are using this mixin, please replace it with:
  `width: span($n)`.
* [Blueprint] Blueprint no longer adds `!important` to the widths of `input`, `textarea`,
  and `select` form fields, so compass no longer defaults to using `!important` in those cases.
  If you were relying on this behavior, you may need to adjust your stylesheets accordingly.

0.11.alpha.4 (12/08/2010)
-------------------------

* Add a `--time` option to the compile and watch commands. This will print out
  the time spent compiling each sass file and a total at the end.
* Upgrade FSSM, the internal library that monitors the filesystem events for compass.
* Removed the command line options that were deprecated in v0.10.

0.11.alpha.3 (12/05/2010)
-------------------------

* Fix a bug in compass running under ruby 1.9.2 that was introduced in v0.11.alpha.2.

0.11.alpha.2 (12/05/2010)
-------------------------

* Merge with Lemonade. Compass now provides a full featured spriting solution.
  See the [spriting tutorial](/help/tutorials/spriting/) for more information.
* Compass now depends on Sass 3.1. You can install the preview release:
  `gem install sass --pre`. Note: you must also upgrade your haml gem if you
  use both in the same application.
* A third argument is now available on the `image-url()` helper. When `true` or
  `false`, it will enable/disable the cache buster for a single image url. Or when
  a string, it will be the cache buster used.
* Upgrade CSS3 PIE to 1.0-beta3.
* Bug fixes.

0.11.alpha.1 (11/22/2010)
-------------------------

* Support for Sass 3.1 alpha version
* CSS3 PIE module. [Docs](/reference/compass/css3/pie/).
* The versioned modules in the last release have been removed. There is now
  just a single module for each and the overloaded mixins will discern
  deprecated usage and warn accordingly.
* Allow erb processing of non all non-binary filetypes during extension installs.
* Added a `background` mixin for css3 gradient support in the shorthand style.
* Fix for gradients in opera with bordered elements.
* The `multiple-text-shadows` and `multiple-box-shadows` mixins that were present in
  v0.11.alpha.0 were removed because they were unnecessary. Just use the `text-shadow`
  and `box-shadow` mixins.
* The docs are [getting a make-over](http://beta.compass-style.org/) by Brandon :)

0.11.alpha.0 (11/15/2010)
-------------------------

Note: Compass does not currently support Sass 3.1 alphas.

### Deprecations

* Deprecated imports and APIs from v0.10 have been removed.
* Changed defaults for the box-shadow and text-shadow mixins.
  Previously the horizontal and vertical offset were both 1, which
  expected a top left light source. They are now set to 0 which assumes
  a direct light source, a more generic default.
* The linear-gradient and radial-gradient mixins have been deprecated.
  Instead use the background-image mixin and pass it a gradient function.
  The deprecation warning will print out the correct call for you to use.
* Passing an argument to the `blueprint-scaffolding` mixin is not necessary
  and has been deprecated.
* Some blueprint color defaults now use color functions instead of color arithmetic.
  This may result in different output for those who have color customizations.

### Blueprint

* Updated from blueprint 0.9 to blueprint 1.0
  * Added .info and .alert classes to forms.css [CMM]
  * Fixed numerous bugs in forms, including the fieldset padding bug in IE6-8 [CMM]
  * Fixed specificity problems in typography.css and grid.css [CMM]
  * See Lighthouse for more bug fixes
  * Full [blueprint changelog][blueprint_10_change]
  * If for some reason you'd like to stay on the older version of blueprint you can run
    the following command in your project before you upgrade (or after temporarily downgrading):
    `compass unpack blueprint`

### CSS3 v2.0

Our CSS3 module makes writing CSS3 today almost as easy as it will be when all
the browsers officially support the new features. The second version of the
compass CSS module brings the API up to date with developments over the past
6 to 9 months of browser changes and more closely matching the most recent CSS
specifications. [Upgrade guide](/help/tutorials/upgrading/antares/). Summary of changes.

* Support for multiple box shadows and text shadows
* Support for 2d and 3d transforms
* Opt-in SVG support for gradients in opera and IE9.
  Set `$experimental-support-for-svg : true` in your
  stylesheet to enable it.
* Fixed a radial gradient position bug.
* To generate a simple linear gradient in IE6 & 7, you can now use
  the `filter-gradient` mixin.
* New `background-image` mixin with gradient support and allowing
  up to 10 images.
* Gradient support for the border-image property.
* Gradient support for list-style-image property.
* Gradient support for the content property.

### Helpers

* `linear-gradient()` & `radial-gradient()` helpers now intercept standard css
  functions and parse them into Sass Literals. These work with new vendor helpers
  (`-moz()`, `-webkit`, `-o`, `-ie`, and `-svg` (yes I know svg is not a vendor))
  to return specific representations of the linear & radial gradients. The
  `prefixed()` function will check a value to see if it has a certain
  vendor-specific representation.
* New color helpers: `adjust-lightness`, `adjust-saturation`, `scale-lightness`, and `scale-saturation`
  make it easier to construct apis that manipulate these color attributes.
* The `elements-of-type()` helper now returns html5 elements when the display is `block`
  and also will return only html5 elements for `elements-of-type(html5)`
* Compass now provides several helper functions related to trigonometry.
  There's no practical use, but it's hoped that users will find fun things to
  do with these for technology demonstrations:
  * `sin($number)` - Takes the sine of the number.
  * `cos($number)` - Takes the cosine of the number.
  * `tan($number)` - Takes the tangent of the number.
  * `pi()` - Returns the value of π.
  If you provide a number with units of `deg` then it will return a unitless number
  after converting to radians. Otherwise, it assumes the number is a radian length measure
  and passes the units along to the result.
* `ie-hex-str($color)` returns a #AARRGGBB formatted color suitable for
  passing to IE filters.
* A new function `if()` that allows you to switch on a value without using `@if`.
  Usage: `if($truth-value, $value-if-true, $value-if-false)`.
* Compass has added a number of new helper functions for lists that begin with
  `-compass`, helpers that begin with `-compass` should be considered "private" and
  are not to be used by compass users. Sass 3.1 will have proper list support,
  these are a work around until that time.

### Configuration

* Added a new configuration property to disable sass warnings: `disable_warnings`

### Core Framework

* New layout mixins for absolute positioning: stretch, stretch-x, stretch-y

### Rails

* In rails 3, there's no need for an initializer. Instead we use a
  Railstie.
* We now default to app/stylesheets for sass files and public/stylesheets for
  css files -- though they can still be changed after installation or on the
  command line during project initialization.
* Compass is now a gem plugin in a rails environment.
* In a rails3 environment the compass configuration can now be
  changed without restarting the rails server process.