---
title: Compass History
crumb: CHANGELOG
body_id: changelog
layout: default
---
COMPASS CHANGELOG
=================

Upgrading compass is pretty easy.
Don't let all these details [scare you...](http://compass-style.org/help/tutorials/upgrading/im-scared/)

The Documentation for the [latest stable release](http://compass-style.org/docs/):

The Documentation for the [latest preview release](http://beta.compass-style.org/)

0.12.2 (06/24/2012)
-------------------

* [Vertical Rhythm Module] Removed the `$ie-font-ratio` constatnt in
  favor of a more clear `$browser-default-font-size` constant.
* [Vertical Rhythm Module] The `establish-baseline` mixin now styles the
  `<html>` element instead of the `<body>` element. This makes the
  vertical rhythm module work better with `rem` based measurements.
* [CSS3] Added 3D transform support for Mozillia, IE, and Opera.
* [CSS3] Added `-ms` support for css3 columns. Add support for the columns shorthand property.
* [CSS3] Added `-ms` and `-webkit` support for CSS Regions. [Docs](/reference/compass/css3/regions/)
* [CSS3] Added mixins for column-break properties to the columns module.
* [CSS3] Added a css3/hyphenation module for the `word-break` and `hyphens` properties.
* [CSS3] Made the API more consistent across the different mixins in the transitions module.
* [CSS3] The text-shadow mixin now supports the spread parameter and it is used to progressively enhance browsers that support it.
* [CSS3] Add a mixin for the unofficial `filter` property. [Docs](/reference/compass/css3/regions/)
* [CSS3] Removed the `-ms` prefix for gradients and transforms.
  Microsoft took so long to release them, that the spec was approved first.
* [CLI] Added a `-I` option for adding sass import paths via the CLI during compilation and project set up.
* [Configuration] For better ruby and rails integration, the `add_import_path` command now accepts
  [Sass::Importer](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#custom_importers) objects
  and [Ruby Pathname](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/pathname/rdoc/Pathname.html) objects.
* Reverted the [hide-text](/reference/compass/typography/text/replacement/#mixin-hide-text) mixin to the `-9999` method. If you prefer the [Kellum method](http://www.zeldman.com/2012/03/01/replacing-the-9999px-hack-new-image-replacement/) then you need to set `$hide-text-direction` to `right` in your stylesheets.
* `$legacy-support-for-mozilla` can be set to `false` to disable output
  for Firefox 3.6 or earlier.
* Cleaned up the inline-block mixin to have less output and make the vertical-alignment of that mixin configurable or even turned off. [Details](https://github.com/chriseppstein/compass/commit/84e9a684b9697d728a37abb14cb0aae2c4d2a790)
* Output of SVG and original webkit gradients is now omitted when using
  the degree-based linear gradient syntax.
* Added a `--fonts-dir` configuration flag for the compass command line.
* Added `tint()` and `shade()` color helper functions, for better ligthening/darkening of colors.

0.12.1 (03/14/2012)
-------------------

* Fixed a bug in font-files mime-type detection.
* Code cleanup and better documentation for the vertical-rhythm module.
* Add support for installing compass on Macs using a [one-click installer](https://github.com/chriseppstein/compass/downloads).

0.12.rc.2 (03/11/2012)
----------------------

### Stylesheet Changes

* Improved [hide-text mixin](/reference/compass/typography/text/replacement/#mixin-hide-text) for better performance and accessibility.
* Added [squish-text mixin](/reference/compass/typography/text/replacement/#mixin-squish-text) to hide text on inline elements.
* Compass css3 transitions module now correctly handled transitioning of
  prefixed properties.

### Misc Changes
* Fix the mime-type of embedded `woff` font files. Add support for Embedded OpenType fonts.
* New math functions are now available: `e()`, `logarithm($number[, $base = e()])`, `square-root($number)`
  and `pow($number, $exponent)`


0.12.rc.1 (02/02/2012)
----------------------

Give warnings for users who upgrade without knowing about the compass-rails gem.

0.12.rc.0 (01/31/2012)
----------------------

### Stylesheet Changes

* Removed -ms prefix from box-sizing
* Added sprite_names sass function
* Added -ms prefix to transitions

### Command Line

* Added support for `--debug-info` and `--no-debug-info` to the compass compile command

### Rails Integration

Rails projects must now use the [`compass-rails`](https://github.com/compass/compass-rails)
gem to integrate with compass. Please read the [README](https://github.com/Compass/compass-rails/blob/master/README.md) for upgrade instructions. More information in this [blog post](/blog/2012/01/29/compass-and-rails-integration/).

0.12.alpha.3 (12/23/2011)
-------------------------

* The `$round-to-nearest-half-line` config variable was added. When
  true, the vertical rhythm module will round line heights to the
  nearest half-line to avoid awkwardly large gaps between lines of text.
  Defaults to false.
* Added `reset-baseline` to the vertical rhythm module so you can force the baseline to reset.
* Merges in the stable changes between 0.11.5 and 0.11.6.

0.12.alpha.2 (11/28/2011)
-------------------------

* Bug fixes for Rails 2.x applications.

0.12.alpha.1 (11/14/2011)
-------------------------

* font-files helper: Stop requiring font type when the type can be guessed from URL
* inline-font-files: actually works now
* Upgrade CSS3 Pie to 1.0beta5
* log sprite generation and removal to the console
* Added a new helper function `compass-env()` that returns the current compass environment (development, production)
* Added the ability to inline a sprite image by setting `$<map>-inline:true` before you call `@import`
* Removed `-khtml` prefixes by default you can still enable them by setting `$experimental-support-for-khtml:true;`
* Improved rails 3.1 integration
* `true` and `false` are now valid sprite names
* Removed deprecated forms of the box-shadow, text-shadow, and transform
  mixins.

0.12.alpha.0 (8/30/2011)
------------------------
* Support for the rails 3.1 asset pipeline
* Added support for diagonal, horizontal, and smart sprite layout
* Fixed a bug with spacing in horizontal layout
* Changed the descriptions of the sin, cos, and tan to be more descriptive
* Fixed trig functions via issue #498 
* Fixed the default `http_path` in rails
* Sprites can now have a `sprite_load_path` that is an array of directories that
  contain source images for sprites handy for using sprites in extensions or gems
* Added a new set of configuration properties for generated images.
  `generated_images_dir`, `generated_images_path`, `http_generated_images_dir`,
  and `http_generated_images_path` can now be set to control where generated
  images are written and how they are served. Added a corresponding
  `generated-image-url()` helper function. These should rarely be needed and
  will default to your corresponding image directories and paths.

0.11.8 (02/26/2012)
-------------------

* Fix a bug in gradients that used the transparent keyword
* Add filesize to the `compass stats` output.

0.11.7 (01/05/2012)
-------------------

* Update to font-face mixin to make it work on IE8.

0.11.6 (12/23/2011)
-------------------

* Added `user-select` mixin to control the selection model and granularity of an element.
  It accepts one argument (`$select`) from the following options:
  `none` | `text` | `toggle` | `element` | `elements` | `all` | `inherit`.
* The border-image property now takes a keyword called `fill` to
  indicate that the image should also fill the element. If you pass the
  `fill` keyword to the `border-image` mixin it will only be output in the
  standard (non-prefixed) versions of the property.
* Don't use the deprecated callback method `on_updating_stylesheet` in Sass if
  the new version is available.

0.11.5 (07/10/2011)
-------------------

* Updated the list of elements returned by the `elements-of-type()` helper.
  It now understands `html5-block` and `html5-inline` and other types now
  return html5 elements in them by default.
* Fix warning logic in vertical-rhythms module.
* Fix typo in the css3/transition module.

0.11.4 (07/03/2011)
-------------------

* Vertical rhythm now supports absolute units like pixels.
  Set `$relative-font-sizing` to `false` to enable.
* Vertical rhythm now has a minimum padding that defaults to 2px.
  This makes some edge cases look better.
* New mixin `force-wrap` prevents URLs and long lines of text from breaking layouts.
* Fix absolute path detection on windows.
* Fix the mime type returned for inline svg images.
* Allow multiple transitions in the CSS3 `transition` mixin.
* The Blueprint `:focus` styles no longer clobbers cascade-based overrides unnecessarily.
* The Blueprint grid-background vertical rhythm is now based off of $blueprint-font-size,
  rather than a static value of 20px

0.11.3 (06/11/2011)
-------------------

**Note:** Due to some internal changes to compass you may have issue with your sass cache. Run `compass clean` to clear your cache.

* The `pie-clearfix` mixin has been updated. If you have to
  support Firefox < 3.5, please update your stylesheets
  to use `legacy-pie-clearfix` instead.
* Added a new command: `compass clean` which removes any generated
  css files and clears the sass cache.
* Enable IE 10 support for flexible box with the -ms prefix.
* A small change to how generated sprites are named for better
  rails 3.1 compatibility.
* Fixes for the compass --quiet mode.
* It is now possible to generate cache buster urls that manipulate
  the path of the image instead of the query string. This makes
  images work better with proxies, but will require some web server
  configuration. [Docs](/help/tutorials/configuration-reference/#asset-cache-buster)
* Numerous small bug fixes to sprites.
* Sprite Engines are now classes see [Docs](/help/tutorials/extending) for more information
* Sprite classes have bee re-factored into modules for readability
* Sprites will no longer cause `undefined method 'find' for #<Compass::SpriteMap>` when adding or removing sprite files

0.11.2 (06/10/2011)
-------------------
* Sprites will now by default remove any old versions of the sprite. A new configuration
  variable has been created to override this.
* Nested sprites are now supported using globs `@import 'nested/**/*.png';`.
* Fixed a bug that was causing sprite variable options to not get passed to the image classes.
* Sass Colors will no longer cause an error if you use them as sprite names.
* Added support for -ms gradients in background-image and background properties
* Give a better error if Sass::Script::Functions.declare does not exist.

0.11.1 (04/25/2011)
-------------------

* This release fixed some Gem dependency issues with Sass.

0.11.0 (04/24/2011)
-------------------

This changelog entry is aggregated across all the v0.11 beta releases.
If you're upgrading from a previous beta v0.11 beta release, you can read
[the 0.11 beta release notes here](/CHANGELOG-v0-11-beta/).

### !important

#### Breaking Changes & Deprecations:

* Deprecated imports and APIs from v0.10 have been removed. If you are upgrading
  from v0.8, please upgrade to v0.10 before installing v0.11.
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
* The deprecated & unused arguments to the `font-face` mixin have been removed.
* Lemonade has been merged into compass. If you've been using Lemonade, you need to
  upgrade your sprites to use the new [Compass Sprites](/help/tutorials/spriting/).

#### Dependencies

* Compass now depends on Sass 3.1 which is a new stand-alone gem that has been separated
  from Haml. **If you have Haml installed, you must upgrade it to 3.1 as well.**
* Compass now depends on ChunkyPNG, a pure-ruby library for generating PNG files.
* The FSSM library that used to be vendored is now upgraded and a normal gem dependency.
  If you don't know what this means, then you don't need to care :)

### New Sass Features

Sass 3.1 brings a ton of great new features that Compass now uses and you can too!

* Proper List Support. Space and Comma separated lists used to cause values to become strings when passing them to mixins. Now the values in lists are preserved as their original types.
* Sass-based Functions. Define your own value functions and use them anywhere.
* Keyword Style Argument passing to Functions and Mixins. It can be hard to understand what
  the values being passed to a mixin or function are for, use keyword style arguments to
  make it easier to understand what's going on.
* `@media` bubbling. Use a media declaration anywhere and it will be bubbled to the top level
  for you.

For more information about the new Sass features, see the [Sass CHANGELOG](http://sass-lang.com/docs/yardoc/file.SASS_CHANGELOG.html).

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
* [Blueprint] Blueprint no longer adds `!important` to the widths of `input`, `textarea`,
  and `select` form fields, so compass no longer defaults to using `!important` in those cases.
  If you were relying on this behavior, you may need to adjust your stylesheets accordingly.
* [Blueprint] Added a new sass function called span($n) to the grid module which replaces
  the now **deprecated span mixin**. If you are using this mixin, please replace it with:
  `width: span($n)`.

### Spriting Support

* Compass now has a world-class spriting system after merging with [Lemonade][lemonade].
  See the [spriting tutorial](/help/tutorials/spriting/) for more information.
* The [old sprite module](/reference/compass/utilities/sprites/sprite_img/) is still available
  for working with hand-generated sprite maps.
* The Sprite internals are abstracted allowing for different engines. By default
  compass uses ChunkyPNG which only supports PNG files, so some users might prefer
  ImageMagic which is available via a [plugin](#XXXLINKME).
* [Magic Selectors](/help/tutorials/spriting/#magic-selectors) make it simple to define
  sprites that work with user interaction pseudo classes like `:hover`, `:active`, etc.

### CSS3 Module v2.0

Our CSS3 module makes writing CSS3 today almost as easy as it will be when all
the browsers officially support the new features. The second version of the
compass CSS module brings the API up to date with developments over the past
6 to 9 months of browser changes and more closely matching the most recent CSS
specifications. [Upgrade guide](/help/tutorials/upgrading/antares/). Summary of changes.

* Support for multiple [box shadows](/reference/compass/css3/box_shadow/)
  and multiple [text shadows](/reference/compass/css3/text-shadow/)
* Support for [2d and 3d transforms](/reference/compass/css3/transform/)
* Opt-in [SVG support](/reference/compass/support/#const-experimental-support-for-svg)
  for gradients in opera and IE9. Set `$experimental-support-for-svg : true` in your
  stylesheet to enable it.
* To generate a simple linear gradient in IE6 & 7, you can now use
  the [filter-gradient mixin](/reference/compass/css3/images/#mixin-filter-gradient).
* New [images module](/reference/compass/css3/images/) makes gradients simple for
  all properties that support them using the CSS3 standard syntax.
* Compass now has opt-in support for the CSS3 PIE library. [Docs](/reference/compass/css3/pie/).
* Added optional support for IE8 with `$legacy-support-for-ie8` which defaults to true.
* Updated the `opacity` and `filter-gradient` mixins to make IE's hacky DirectX filters
  optional based on Compass's legacy support settings.
* A new CSS3 mixin for [appearance](/reference/compass/css3/appearance/) was added.
* The font-face mixin has been updated again with the [syntax recommendations
  from font-spring](http://www.fontspring.com/blog/the-new-bulletproof-font-face-syntax).
  The API has not changed.
* Added support for the new webkit gradient syntax that matches the css3 specification.
  Support for older webkit browsers remains enabled at this time.
  To disable it, set `$support-for-original-webkit-gradients` to false.

### Helper Functions

* `linear-gradient()` & `radial-gradient()` helpers now intercept standard css
  functions and parse them into Sass Literals. These work with new vendor helpers
  (`-moz()`, `-webkit`, `-o`, `-ie`, and `-svg` (yes, we know svg is not a vendor))
  to return specific representations of the linear & radial gradients. The
  `prefixed()` function will check a value to see if it has a certain
  vendor-specific representation.
* New color helpers: `adjust-lightness`, `adjust-saturation`, `scale-lightness`,
  and `scale-saturation` make it easier to construct apis that manipulate these
  color attributes.
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
  after converting to radians. Otherwise, it assumes the number is a radian length
  measure and passes the units along to the result.
* `ie-hex-str($color)` returns a #AARRGGBB formatted color suitable for
  passing to IE filters.
* Compass has added a number of new helper functions that begin with
  `-compass`, helpers that begin with `-compass` should be considered "private"
  and are not to be used.
* A third argument is now available on the `image-url()` helper. When `true` or
  `false`, it will enable/disable the cache buster for a single image url. Or when
  a string, will be the cache buster value that is used.

### Configuration Files

* Added a new configuration property to disable sass warnings: `disable_warnings`
* New infrastructure for supporting experimental css3 functions that are prefixed but have
  the same syntax across all browsers. It is now possible to configure which browsers
  support which experimental functions outside of the compass release cycle.
  For details, see the [cross browser helpers](/reference/compass/helpers/cross-browser/).
* The options passed to the CLI can now be inspected within the compass configuration file.
  The CLI options will still override the values set within the config file, but they might
  inform other values. For instance `compass compile -e production` will have the environment
  parameter preset to `:production` so that you can set other values in the project accordingly.
* Added the ability to piggy back on compass's watcher within your configuration file.
  See the [configuration reference](/help/tutorials/configuration-reference/) for details.
* You can now register callbacks for compilation events so that you can take
  custom actions when they occur. For instance, you might want to notify
  Growl when a stylesheet compilation error occurs.

### New Compass Typography Module

* Some text-based mixins have been moved from utilities to the new
  typography module. The old imports are deprecated now.
  Affected modules: `utilities/links`, `utilities/lists`, and `utilities/text` and
  their sub-modules.
* There is a new typography module:
  [Vertical Rhythm](/reference/compass/typography/vertical_rhythm/).
  This makes it easier to align the typography of your page to a common rhythm.

### Compass Layout Module

* New layout mixins for absolute positioning: stretch, stretch-x, stretch-y
* There is a new mixin for creating
  [pure-css grid backgrounds](/reference/compass/layout/grid_background/)
  for verifying grid alignment for both fixed and fluid grids.

### Compass Utilities

* A new mixin `reset-float` is available in the [float module](/reference/compass/utilities/general/float/#mixin-reset-float) that makes it easier to reset the floats introduced from that module.
* A new module has been added to create readable text against an arbitrary background color based on the lightness of the background: [compass/utilities/color/contrast](/reference/compass/utilities/color/contrast/).
* The comma-delimited-list has been renamed to delimited-list and
  generalized to accept a delimiter which defaults to a comma.
  The old function continues to exist, but is deprecated.

### Command Line

* Add a `--time` option to the compile and watch commands. This will print out
  the time spent compiling each sass file and a total at the end.

### Rails

* In rails 3, there's no need for an initializer. Instead we use a
  Railtie. If you have one, please remove it.
* We now default to app/stylesheets for sass files and public/stylesheets for
  css files -- though they can still be changed after installation or on the
  command line during project initialization.
* Compass is now a gem plugin in a rails environment.
* In a rails3 environment the compass configuration can now be
  changed without restarting the rails server process.

### Extensions

* Compass now allows ERB processing of non all non-binary filetypes during
  extension installs.
* Extensions that are installed into `~/.compass/extensions` will be automatically
  available to all your compass projects.
* Created an official API to add configuration options to compass.
  [More information](/help/tutorials/extending/).

### Miscellaneous

* We have a new website design from [Brandon Mathis][brandon]
* Compass now officially supports the following ruby interpreters:
  jruby, ruby 1.8.7, ruby 1.9.2, ree, and rubinius.

0.10.7 (UNRELEASED)
-------------------
* [Command Line] compass config -p <property> -- will now print out the configuration value
  for that property for the current project
* [CSS3] Bug fix: In webkit, when the last gradient color stop was a percent less than 100%,
  the intermediate values were being scaled to that value.
* [Command Line] You can now pass --no-line-comments to the Compass command line to disable
  line comments.
* [Configuration] Make the compass configuration file more self documenting by adding comments
  for `preferred_syntax`, `output_style`, and `line_comments`.
* Work around IE compatibility issues with the :last-child selector.
  [Commit](http://github.com/jdsiegel/compass/commit/c1fb764dba9c54cc5d02f2f7de213fb21ac6ca09).
* [Command Line] Only the action is colorized in command line output now.
* [Command Line] Compass Validator has been upgraded and fine-tuned. It is now using the
  "css3" profile to validate and provides a more consistent UI with other compass commands.
  To upgrade: `gem install compass-validator`
* [CSS3] The box-shadow `$spread` value now defaults to using the browser default instead of 0.
  Set $default-box-shadow-spread to 0 if you prefer the older behavior. Since the browser is supposed
  to default to 0, you should see no change except less CSS output.
* [CSS3] The output order of the `box-shadow` mixin now matches the W3C specification.
  The color and inset values used to be swapped.

0.10.6 (10/11/2010)
-------------------

* HTML5 reset includes box-model reset for newer browsers.
* Fix encoding issue for ruby 1.9 users of the font-face mixin.
* Make it easier to disable the asset cache buster: `asset_cache_buster :none`
* Can now set `$padding` to `false` to make the `horizontal-list` mixin skip the
  padding properties.
* It is now possible to disable support for legacy IE browsers.
  See [the docs](/reference/compass/support/) for more information.

0.10.5 (08/29/2010)
-------------------

* The [HTML5 Reset mixin][html5-reset] now resets the following new elements:
  `canvas`, `details`, `figcaption`, `hgroup`, `menu`, `summary`
* A new Utility mixin has been added: [inline-block-list][inline-block-list].
* Compass projects can now (as was always intended) use paths outside of the project directory
  for css, images, fonts, etc by configuring those locations using `xxx_path` instead of
  `xxx_dir`. For instance: `css_path = "/var/www/docroot/css"`. It is recommended
  to set the corresponding `http_xxx_path` when you do this, for instance:
  `http_stylesheets_path = "/css"`. On the command line, all absolute urls are
  treated as paths instead of relative directories so
  `--css-dir /var/www/docroot/css` will set `css_path`. Should both a directory
  and a path be specified, the path will override the corresponding directory.
* A new command is available that will unpack an extension from the system location into
  your extensions folder. Run `compass help unpack` for more information.

0.10.4 (8/08/2010)
------------------

* [Rails] Fixed a bug introduced in 0.10.3 that caused rails applications using the old configuration file (config/compass.config) to break.
* [Extensions] Make it easier to create manifest files by allowing template files to be discovered. See the Manifest Declarations section of [extensions tutorial](http://compass-style.org/help/tutorials/extensions/) for details.
* [Rails] Don't install configuration files when installing extensions.
* [Compass Core] All url helpers now accept a second argument that when true will cause only the path to be emitted. This allows the url helpers to be used with IE filters.

0.10.3 (8/1/2010)
-----------------

### !important

All rails users should run the following command:

    compass init rails --prepare

This will update your compass initializer file.

### Compass Core

* Add missing clearfix import to horizontal-list.
* Emit less css for inline lists with the same result.
* New helper `opposite-position($position)` returns the opposite value of a position. [Documentation](http://compass-style.org/reference/compass/helpers/constants/)
* Allow horizontal lists to be floated to the right.
* Bugfix for inline-font-files helper.
* `+font-face` mixin no longer uses `$postscript` name or `$style` type variables, in favor of the Paul Irish [smiley bulletproof technique](http://paulirish.com/2009/bulletproof-font-face-implementation-syntax/). Older declarations will still work, but will not apply the variables and will display a deprecation warning.
* `+box-shadow` now supports `$spread` length and `$inset` declarations.
* The gradient mixins output official w3c declarations along with the `-webkit` and `-moz` prefixed versions. The official code is based on the w3c spec and is nearly ideantical to the mozilla version, although it is currently not supported by any browser.
* `+opacity` no longer uses any prefixed variations, as IE uses `filter` and
  all other modern browsers support the official spec or nothing at all.
* Support for specifying horizontal and vertical radii for the shorthand border-radius property.
* The `has-layout` mixin now uses pixels instead of ems to work around an opera bug.

### Blueprint
* Two colors used in typography can now be customized.
* Support for inputs of type email.

### Extensions
* Extensions can now create empty directories with the `directory` directive. [Docs](http://compass-style.org/help/tutorials/extensions/).
* It's now easier to load extensions from a configuration file using the `load` and `discover` directives.

### Rails

As stated above, all rails users should run the following command:

    compass init rails . --prepare

This will fix a bug in the rails initializer that caused compass extensions to not be recognized when placed into the `vendor/plugins/compass_extensions` directory. It will also make sure that future bugs in the boot process won't require an end-user action to fix.


### Contributors:

* [Milo Winningham](http://github.com/quadule)
* [jonathanpberger](http://github.com/jonathanpberger)
* [Stephan Kaag](http://github.com/stephankaag)

0.10.2 (May 31, 2010)
---------------------

This is a bug fix release. [Details on Github.](http://github.com/chriseppstein/compass/compare/v0.10.1...v0.10.2)

0.10.1 (May 15, 2010)
---------------------

* Fixed a regression in the Blueprint module, the blueprint reset
  was no longer automatically applying the reset styles. This behavior
  is restored in this release. If you `@import blueprint/reset` and
  then apply the reset mixin yourself, you should remove the mixin
  call or change your import to `blueprint/reset/utilities`.
* Added a subcommand for emitting sass imports for the sass CLI.
* Added a subcommand for listing the available frameworks.
* Fixed a number of bugs related to Sass & Rails integration
* Fixed some documentation issues in the command line and on the website.

0.10.0 (May 10, 2010)
---------------------

This changelog entry is condensed from a very long beta release. You can read [the 0.10.0 beta release notes here](/CHANGELOG-v0-10-0-beta/).

### Gem Location

The compass gem is now (and has been for some time) hosted on [rubygems.org](http://rubygems.org). If you have an old version
installed from github, please remove it:

    sudo gem uninstall chriseppstein-compass

### Sass 3:

* Compass now depends on Sass 3 -- Please be prepared to upgrade.
  Things won't break but you'll have a lot of deprecation warnings.
  Upgrading is pretty easy thanks to the `sass-convert` tool. See the
  [Sass Changelog](http://sass-lang.com/yardoc/file.SASS_CHANGELOG.html)
  for more information.
* All compass stylesheets are now written in the SCSS syntax,
  if you import compass framework stylesheets with an explicit
  `.sass` extension, then you'll receive deprecation warnings
  directing you to update your stylesheets.
* A new command line switch `--syntax` (or `-x`) has been added
  to commands that install stylesheets into your project that
  allows you to select the syntax to use (scss or sass)
* A new configuration option `preferred_syntax` now exists
  and defaults to `:scss`. Please update your project's configuration
  file with `preferred_syntax = :sass` if you prefer to use the
  indentation-based syntax.
* You may silence deprecation warnings by adding
  `sass_options = {:quiet => true}` to your configuration.

### Command-Line:

* The compass command-line tool has been re-written to allow be easier to
  use and be more flexible. The old command line is still supported at
  this time. "compass help" will get you started on using the new
  command line syntax.
* Allow specification of a height for the grid image
* For the truly hardcore compass users, you may now create a
  compass project using "compass create my_project --bare"
  and you'll have a completely bare project created for you with no
  sass files provided for you.
* Get stats on your compass project with "compass stats". You'll
  need to install the "css_parser" ruby gem to get stats on your
  css files.
* Command line switch (--boring) to turn off colorized output.
* Color any output from the `Sass::Engine` red during compilation.
* If you only want to compile certain files, you can now
  specify them when invoking compass compile. E.g. `compass compile src/foo.sass`

### Configuration:

* The entire configuration infrastructure has been re-written to make it
  easier to support the various sources of configuration data (project type,
  config file, command line, and hard coded defaults)
* Whether to generate relative links to assets is now controlled by a
  separate boolean configuration flag called `relative_assets` in the
  configuration file and `--relative-assets` on the command line.
  Setting `http_images_path` to `:relative` is deprecated.
* You may now configure the http locations for your project by simply setting
  `http_path` for the top level path of the project. You
  may also set `http_images_dir`, `http_stylesheets_dir`, and
  `http_javascripts_dir` relative to the `http_path` instead of
  setting the absolute `http_XXX_path` counterparts.
* You may now configure the fonts directory for your project (fonts_dir).
  By default, for standalone projects, it is the "fonts" subdirectory of
	your css directory. Rails projects will default to "public/fonts".
* The sass cache location can now be set in the compass config
  file using the `cache_dir` property and the cache can be disabled by setting
  `cache = false`.
* In your configuration file, setting `http_images_path` to `:relative` is
  deprecated in favor of setting `relative_assets` to `true`

### Rails:

**IMPORTANT:** Existing rails projects _must_ change their compass initializer file to:

    require 'compass'
    rails_root = (defined?(Rails) ? Rails.root : RAILS_ROOT).to_s
    Compass.add_project_configuration(File.join(rails_root, "config", "compass.rb"))
    Compass.configure_sass_plugin!
    Compass.handle_configuration_change!

* The rails template has been updated to use the latest haml and compass versions.
* Compass now supports Rails 3, but asset_host and cache_buster integration is disabled.
* When configuring Sass during initialization,
  Compass now passes the template locations as an array of tuples
  instead of as a hash. This preserves ordering in all versions
  of ruby and ensures that the deprecated imports do not take precedence.

### Compass Core:

* A new helper function `stylesheet-url(path)` can now be used to refer
  to assets that are relative to the css directory.
* Compass sprite mixins are now more flexible and feature rich.
* Fixed the `append-selector` function to allow comma-delimited selectors
  for both arguments instead of just the first
* There is no longer any outline on unstyled links in the :active and :focused states.
* New CSS3 Compatibility Mixins. You can import them all with `@import compass/css3.sass`
  Read the [documentation][http://compass-style.org/reference/compass/css3/].
* The import for `+inline-block` has moved from "compass/utilities/general/inline_block"
  to "compass/css3/inline-block".
* The import for `+opacity` has moved from "compass/utilities/general/opacity"
  to "compass/css3/opacity"
* Note: If you are using the `+opacity` or `+inline-block` mixins,
  you may need to update your imports.
* `+min-height`, `+min-width`, and `+bang-hack` mixins in the
  compass/utilities/general/min.sass module. (Credit: [Adam Stacoviak][adamstac])
* Split out `+hide-text` as its own mixin. (Credit: [Andrew Vit][avit])
* Support :first-child and :last-child pseudo selectors for +horizontal-list. (Credit: Cody Robbins)
* Added new helper functions: `image_width("path/to/image.png")` & `image_height("path/to/image.png")` that return the size in pixels. (Credit: Deepak Jois & Richard Aday)
* The `pretty-bullets` mixin will now infer the image dimensions by
  reading the image file if the image dimensions are not provided.
* In addition to installing the `binding.xml`, the configuration constant
  `$use-mozilla-ellipsis-binding` must now be set to `true`
  to support any version of mozilla less than 3.6 in the `+ellipsis` mixin.

### Blueprint:

* The useless blueprint "modules" folder will be removed. Please update your
  blueprint imports by removing the modules folder. Deprecation warnings will be
  emitted if you use the old imports.
* Blueprint mixins that used to accept a "body selector" argument, are now
  deprecated, instead you should pass `true` to them and mix them into
  the selector of your choice.
* Make the primary blueprint mixins easier to use by allowing them to be
  nested when passing true as the first argument.
  The old approach of passing a selector as the first argument is now deprecated
  in favor of a simple flag to indicate nesting or not.
* Take margins into account in liquid grid. (Credit: Christoffer Eliesen)

### YUI:

* YUI was upgraded to 2.7.0
* Yahoo has deprecated the YUI CSS framework, as such YUI has been extracted to a plugin.
  If you use it, please [install it](http://github.com/chriseppstein/yui-compass-plugin).

### Extensions:

* Extensions can now be installed locally by unpacking them into a project's
  "extensions" directory. Rails projects use "vendor/plugins/compass/extenstions".
* Extensions can deliver html to projects if they like. The html can be in
  haml and will be transformed to html and can contain inline, compass-enabled
	sass.
* All files can be processed using ERB before being copied into the user's
  project.
* Compass extensions can now add support for other application frameworks.
  These extensions can help compass understand the project structure of that
  framework as well as provide runtime integration for ruby-based apps.
  Contact me if you plan to do this -- the first couple times may be a little
  rough.
* Compass extensions can now add new command line commands. Contact me if you
  plan to do this -- the first couple times may be a little rough.
* Extensions can now provide help documentation just after a project is
  created and on demand when the user uses the command line help system.
  This can be done via the manifest file or by adding a USAGE.markdown file
  at the top level of the framework template.

### Miscellaneous:

* Lot of new docs can be found at: [http://compass-style.org/](http://compass-style.org/).
* The compass configuration object is no longer a singleton, this makes it
  possible for other ruby software to manage multiple compass projects at a
  time.
* Compass no longer requires rubygems in order to work, this is a ruby
  best-practice.
* The command line tool is now tested using the cucumber testing framework.
* Removed support for the rip package manager.
* Removed the dependency on RMagic for grid image generation.
  (Credit: [Richard Wöber][der-rich])
* The `unobtrusive-logo` mixin is deprecated and will be removed.
  If you use this, please move the source to your project.

0.8.17 (September 24, 2009)
---------------------------

* The enumerate function now accepts an optional fourth parameter that specifies the separator to be used.
  Enables fixing a bug in the Compass 960 Plugin.

0.8.16 (September 12, 2009)
---------------------------

* Fixed a bug in compass that assumed compass extensions would provide stylesheets.

0.8.15 (September 5, 2009)
--------------------------

* Upgrade the FSSM library to 0.0.6 to fix bugs on windows.


0.8.14 (September 2, 2009)
--------------------------

* Upgrade the FSSM library to 0.0.4 to fix bugs and enable FS Events on Mac OS.

0.8.13 (August 30, 2009)
------------------------

* [Blueprint] Mixins have been added for these as +prepend-top and +append-bottom and grid classes will be generated by +blueprint-grid.
* [Command Line] The watch mode has been re-implemented to use the FSSM library by Travis Tilley. OSX users will
  now have support for filesystem monitoring. Fixes an infinite looping bug that occured with syntax users.

0.8.12 (August 22, 2009)
------------------------

Bug Fix Release:

* [Compass Core] Bug fix to sprites: fixed width and height assignments for x and y position variables
* Ruby 1.9.1 fix: binding for parse_string
* [Rails] Don't suggest creating a stylesheet link to partials.


0.8.10 (August 16, 2009)
------------------------
Bug Fix Release:

* Write files in binary mode to avoid data corruption when installing images on windows.
  Fixes [Issue #39](http://github.com/chriseppstein/compass/issues/#issue/39)

0.8.9 (August 9, 2009)
----------------------
Bug Fix Release:

* [Blueprint] The default screen.sass generated invalid selectors due to improper nesting. A better fix is coming in the next release.

0.8.8 (July 21, 2009)
---------------------

Bug Fix Release:

* [Compass Core] Fixed a bug in alternating_rows_and_columns. Improper nesting caused some styles to be improperly rendered.
  [Commit](http://github.com/chriseppstein/compass/commit/e277ed2cd3fded0b98ddaa87fc4d3b9d37cb7354)
* [YUI] Fixed a bug in yui grids where the .first div wouldn't get the right styles in some rare cases due to incorrect nesting.
  [Commit](http://github.com/chriseppstein/compass/commit/4bfcef4f376ee6e5d5a2b47419d2f21ef4c6eff8)


0.8.7 (July 09, 2009)
---------------------

Bug Fix Release:

* Load haml-edge only if it's all new and shiny. Closes GH-26.
  [Commit](http://github.com/chriseppstein/compass/commit/59a6067b3a67a79bfd9a5ce325fc1be4bb6c9e78)
* [Blueprint] Added more descriptive comments to the Blueprint IE template.
  [Commit](http://github.com/chriseppstein/compass/commit/8684966be1e8166a986ae81abd3daf6c44ed4f94)
* [Rails] Fixed a bug in rails integration if the request is not set on the controller.
  [Commit](http://github.com/chriseppstein/compass/commit/7fba6028d8073a9124a6505aab9246b5b459db34)
* [Blueprint] Fixed a bug in the calculations for the +colborder mixin. Closes GH-25.
  [Commit](http://github.com/chriseppstein/compass/commit/d2b1370c80a32f70ae6ec94126b737f4f0fc0851)

0.8.6 (July 08, 2009)
---------------------

### Rails

* The rails installer now correctly references the haml 2.2 dependency.
  [Commit](http://github.com/chriseppstein/compass/commit/85bb337f50a3a3dfaafa2820d5463f7296140c9e)
  by [Filip Tepper][filiptepper].
* When installing into a new rails project, set the http paths correctly for stylesheets and javascripts
  in the configuration file.
  [Commit](http://github.com/chriseppstein/compass/commit/94e9696b30a9a9fd750c45e6fe3c2bc93eba506a)
* Fixed a bug in asset hosts support when compiling outside the context of a controller.
  [Commit](http://github.com/chriseppstein/compass/commit/6b8bbd22b13ef4c329777913a633948e66e3da99)

### Command Line

* Fixed a bug that caused the output after installing to not display the conditional comments.
  [Commit](http://github.com/chriseppstein/compass/commit/48a0356ad8bc7b965e64f82498a9adcc1872abad)

### Compass Core

* Fixed a copy & paste error in image_url() that caused the http_images_path to not get picked up unless the
  http_stylesheets_path was also set.
  [Commit](http://github.com/chriseppstein/compass/commit/b7a9772efb89b2b882d3fafe02813c0fc650719a)

0.8.5 (July 06, 2009)
---------------------

The Compass::TestCase class now inherits from ActiveSupport::TestCase if it exists.
[Commit](http://github.com/chriseppstein/compass/commit/71d5ae8544d1c5ae49e28dcd6b3768fc39d7f01c)

0.8.4 (July 06, 2009)
---------------------

Fixed a bug in rails integration introduced in 0.8.3.

0.8.3 (July 06, 2009)
---------------------

Note: Compass now depends on the stable release of haml with version 2.2.0 or greater.

### Compass Core

* A new helper function `stylesheet_url(path)` can now be used to refer to assets that are relative to the css directory.
  [Commit](http://github.com/chriseppstein/compass/commit/ff5c8500144272ee2b94271b06cce1690cbbc000).
* Cross browser ellipsis mixin is now available. Use `compass -p ellipsis` to install it into your project since it
  requires some additional assets.
  [Commit](http://github.com/chriseppstein/compass/commit/3d909ceda997bdcde2aec09bd72e646098389e7d).

### Blueprint

* The +colruler mixin now accepts an argument for the color.
  [Commit](http://github.com/chriseppstein/compass/commit/a5393bbb7cd0941ab8add5be188aea1d6f9d4b00)
  by [Thomas Reynolds][tdreyno].

### Extensions

* A bug was fixed related to how javascript installation as part of an extension manifest.
  [Commit](http://github.com/chriseppstein/compass/commit/a5393bbb7cd0941ab8add5be188aea1d6f9d4b00)
  by [dturnbull][dturnbull].
* When installing a file, the :like option can now be set to have it installed into the
  same location as what it is like. E.g. `file 'foo.xml', :like => :css` will install
  the foo.xml file into the top level of the project's css directory.
  [Commit](http://github.com/chriseppstein/compass/commit/21cfce33db81e185ce5517818844a9849b5a836e).

### Configuration
* Setting `http_images_path` to `:relative` is now **deprecated**. Instead, please set `relative_assets` to
  `true`.
  [Commit](http://github.com/chriseppstein/compass/commit/956c437fe9ffaad08b6b34d91b6cfb80d6121a2f).
* New configuration option `http_path` can be used to set the project's path relative to the server's root.
  Defaults to "/". The http paths to images, stylesheets, and javascripts are now assumed to be relative to that
  path but can be overridden using the `http_images_path`, `http_css_path`, `http_javascripts_path`.
  [Commit](http://github.com/chriseppstein/compass/commit/6555ab3952ae37d736d54f43ee7053c2a88f4a69).

### Command Line

* A new command line option `--relative-assets` can be used to cause links to assets generated
  via compass helper functions to be relative to the target css file.
  [Commit](http://github.com/chriseppstein/compass/commit/956c437fe9ffaad08b6b34d91b6cfb80d6121a2f).

0.8.2 (July 04, 2009)
---------------------

Fixed a bug that caused touch to fail on windows due to open files. (Contributor: Joe Wasson)

0.8.1
-----

Fixed some build issues and a bug in the rewritten --watch mode that caused changes to partials to go unnoticed.

0.8.0
-----

### Rails

* image_url() now integrates with the rails asset handling code when
  stylesheets are generated within the rails container.
  **This causes your rails configuration for cache busting and asset hosts
  to be used when generating your stylesheets**. Unfortunately, all
  that code runs within the context of a controller, so the stylesheets
  have to be generated during first request to use this functionality. If you
  need to compile stylesheets offline, use the compass configuration file to set
  the <code>asset_host</code> and <code>asset_cache_buster</code>.
  [Commit](http://github.com/chriseppstein/compass/commit/998168160b11c8702ded0a32820ea15b70d51e83).

* An official Rails template for Compass is now [provided][rails_template].
  [Commit](http://github.com/chriseppstein/compass/commit/f6948d1d58818ef8babce8f8f9d775562d7cd7ef)
  by [Derek Perez][perezd].

### Blueprint

* The Blueprint port has been upgraded to match Blueprint 0.9. The following changes were made as part
  of that project:
  * Removed body margins from blueprint scaffolding by default.
    The old body styles can be reinstated by mixing +blueprint-scaffolding-body into your body selector(s).
    [Commit](http://github.com/chriseppstein/compass/commit/45af89d4c7a396fae5d14fab4ef3bab23bcdfb6a)
    by [Enrico Bianco][enricob].
  * A bug in the calculations affecting the +colborder mixin has been fixed.
    [Commit](http://github.com/chriseppstein/compass/commit/4b33fae5e5c5421580ba536116cb10194f1318d1)
    by [Enrico Bianco][enricob].
    Related [commit](http://github.com/chriseppstein/compass/commit/0a0a14aab597d2ec31ff9d267f6ee8cfad878e10).
  * Blueprint now has inline form support. Mix +blueprint-inline-form into a form selector to make it inline.
    [Commit](http://github.com/chriseppstein/compass/commit/56c745b939c763cfcc5549b54979d48ab1309087)
    by [Enrico Bianco][enricob].
  * Please update the conditional comment that surrounds your IE stylesheet to use "lt IE 8" as the condition
    as these styles are not needed in IE8. New blueprint projects will now use this conditional as their default.
    [Commit](http://github.com/chriseppstein/compass/commit/77f6e02c0ec80d2b6fd19e611ced02be003c98ae)
    by [Enrico Bianco][enricob].
  * Explicitly define image interpolation mode for IE so that images aren't jagged when resizing.
    [Commit](http://github.com/chriseppstein/compass/commit/63075f82db367913efcce5e1d0f5489888e86ca4)
    by [Enrico Bianco][enricob].

* When starting a new project based on Blueprint, a more complete screen.sass file will be
  provided that follows compass best practices instead of matching blueprint css exactly. A
  partials/_base.sass file is provided and already set up for blueprint customization.
  [Commit](http://github.com/chriseppstein/compass/commit/11b6ea14c3ee919711fa4bdce349f88b64b68d51)

* The sizes and borders for form styling can now be altered via mixin arguments.
  [Commit](http://github.com/chriseppstein/compass/commit/b84dd3031b82547cff8e1ef1f85de66d98cd162b)
  by [Thomas Reynolds][tdreyno].

* Grid borders can now be altered via mixin arguments.
  [Commit](http://github.com/chriseppstein/compass/commit/0a0a14aab597d2ec31ff9d267f6ee8cfad878e10)
  by [Thomas Reynolds][tdreyno].

* The reset file for blueprint has moved from compass/reset.sass to blueprint/reset.sass. Please
  update your imports accordingly. Also note that some of the reset mixin names have changed
  (now prefixed with blueprint-*).
  [Commit](http://github.com/chriseppstein/compass/commit/2126240a1a16edacb0a758d782334a9ced5d9116)
  by [Noel Gomez][noel].

### Compass Core

* **Sprites**. A basic sprite mixin is now available. Import compass/utilities/sprites.sass and use the +sprite-img
  mixin to set the background image from a sprite image file. Assumes every sprite in the sprite image
  file has the same dimensions.
  [Commit](http://github.com/chriseppstein/compass/commit/1f21d6309140c009188d350ed911eed5d34bf02e)
  by [Thomas Reynolds][tdreyno].

* **Reset**. The compass reset is now based on [Eric Meyer's reset](http://meyerweb.com/eric/thoughts/2007/05/01/reset-reloaded/).
  which makes no attempt to apply base styles like the blueprint reset does. **Existing compass projects
  will want to change their reset import to point to blueprint/reset.sass** -- which is where the old
  default reset for compass projects now lives -- see the blueprint notes above for more information.
  [Commit](http://github.com/chriseppstein/compass/commit/2126240a1a16edacb0a758d782334a9ced5d9116)
  by [Noel Gomez][noel].

* A bug was fixed in the tag_cloud mixin so that it actually works.
  [Commit](http://github.com/chriseppstein/compass/commit/be5c0ff6731ec5e0cdac73bc47f5603c3db899b5)
  by [Bjørn Arild Mæland][Chrononaut].

### Sass Extensions

* The <code>inline_image(image_path)</code> function can now be used to generate a data url that embeds the image data in
  the generated css file -- avoiding the need for another request.
  This function works like <code>image_url()</code> in that it expects the image to be a path
  relative to the images directory. There are clear advantages and disadvantages to this approach.
  See [Wikipedia](http://en.wikipedia.org/wiki/Data_URI_scheme) for more details.
  NOTE: Neither IE6 nor IE7 support this feature.
  [Commit](http://github.com/chriseppstein/compass/commit/5a015b3824f280af56f1265bf8c3a7c64a252621).

### Configuration

* **Asset Hosts**. You can now configure the asset host(s) used for images via the image_url() function.
  Asset hosts are off unless configured and also off when relative urls are enabled.
  [Commit](http://github.com/chriseppstein/compass/commit/ef47f3dd9dbfc087de8b12a90f9a82993bbb592e).
  In your compass configuration file, you must define an asset_host algorithm to be used like so:
      # Return the same host for all images:
      asset_host {|path| "http://assets.example.com" }
      # Return a different host based on the image path.
      asset_host do |path|
        "http://assets%d.example.com" % (path.hash % 4)
      end


* **Configurable Cache Buster**. You can now configure the cache buster that gets placed at the end of
  images via the image_url function. This might be useful if you need to coordinate the query string
  or use something other than a timestamp.
  [Commit](http://github.com/chriseppstein/compass/commit/ef47f3dd9dbfc087de8b12a90f9a82993bbb592e)
  Example:
      asset_cache_buster do |path, file|
        "busted=true"
      end

* You can now set/override arbitrary sass options by setting the <code>sass_options</code> configuration property
  to a hash. [Commit](http://github.com/chriseppstein/compass/commit/802bca61741db31da7131c82d31fff45f9323696).

* You can now specify additional import paths to look for sass code outside the project.
  [Commit](http://github.com/chriseppstein/compass/commit/047be06a0a63923846f53849fc220fb4be69513b).
  This can be done in two ways:
    1. By setting <code>additional_import_paths</code> to an array of paths.
    2. By (repeatedly) calling <code>add_import_path(path)</code>

* The compass configuration can now be placed in PROJECT_DIR/.compass/config.rb if you so choose.
  [Commit](http://github.com/chriseppstein/compass/commit/69cf32f70ac79c155198d2dbf96f50856bee9504).


### Command Line

* **Watch Improvements** The watch command was rewritten for robustness and reliability. The most
  important change is that generated css files will be deleted if the originating sass file is removed while
  watching the project. [Commit](http://github.com/chriseppstein/compass/commit/0a232bd922695f6f659fac9f90466745d4425839).

* The images and javascripts directories may now be set via the command line.
  [Commit](http://github.com/chriseppstein/compass/84aec053d0109923ea0208ac0847684cf09cefc1).

* The usage output (-h) of the command-line has been reformatted to make it more readable and understandable.
  [Commit](http://github.com/chriseppstein/compass/f742f26208f4c5c783ba63aa0cc509bb19e06ab9).

* The configuration file being read can now be specified explicitly using the -c option.
  This also affects the output location of the --write-configuration command.
  NOTE: The -c option used to be for writing the configuration file, an infrequently used option.
  [Commit](http://github.com/chriseppstein/compass/d2acd343b899db960c1d3a377e2ee6f58595c6b1).

* You can now install into the current working directory by explicitly setting the command line mode to -i
  and providing no project name.
  [Commit](http://github.com/chriseppstein/compass/f742f26208f4c5c783ba63aa0cc509bb19e06ab9).

### Compass Internals

* Some internal code was reorganized to make managing sass extensions and functions more manageable.

* Some internal code was reorganized to make managing ruby application integration more manageable.

* The compass unit tests were reorganized to separate rails testing from other tests.

* The [Rip Packaging System](http://hellorip.com) is now supported.
  [Commit](http://github.com/chriseppstein/compass/commit/56f36577c7654b93a349f74abf274327df23402b)
  by [Will Farrington](http://github.com/wfarr).

* A [licence is now available](http://github.com/chriseppstein/compass/blob/master/LICENSE.markdown)
  making the copyrights and terms of use clear for people who care about such things.


0.6.14
------

Extracted the css validator to an external gem that is only required if you try to use the validation feature.
This makes the compass gem a lot smaller (0.37MB instead of 4MB). To install the validator:

    sudo gem install chriseppstein-compass-validator --source http://gems.github.com/

0.6.8 thru 0.6.13
-----------------

The compass gem is now built with Jeweler instead of Echoe. No changes to speak of. These versions were bug
fixes and working out the new release process.

0.6.7
-----

Bug fix release.

### Rails

The output_style will no longer be set in the compass.config file. Instead compass will use the runtime rails environment to set a sensible default.

### Command Line

The Sass cache directory will be placed into the sass directory of the project instead of the directory from where the compass command was ran.

### Compass Core

Extracted two new mixins from +horizontal-list.  The new +horizontal-list-container and +horizontal-list-item mixins can be used to build your
horizontal list when you need more control over the selectors (E.g. when working with nested lists).

0.6.6
-----

The Haml project now releases a gem called haml-edge that is built from the haml master branch instead of stable. Compass now depends on this gem and will continue to do so until haml 2.2 is released. This should reduce the number of installation problems that have been encountered by new users.

### Command Line

* Fixed a bug that had broken the --write-configuration (-c) option.
* The --force option will now force recompilation. Useful when the stylesheets don't appear to need a recompile according to the file timestamps.

### Unit tests

* Some unit tests were cleaned up for clarity and to better take advantage of the compass project management facilities.

0.6.5
-----

### Compass Core

Converted all mixins definitions referencing images to use the new sass function <code>image\_url()</code>. The following mixins were affected:

* <code>+pretty-bullets</code>
* <code>+replace-text</code>

The calls to these mixins should now pass a path to the image that is relative to the images directory of the project.

### Command Line

* Required frameworks specified from the command line will now be added into the initial project configuration file.

0.6.4
-----

### Command Line

Added a command line option --install-dir that will emit the directory where compass is installed. Useful for debugging and drilling into the compass examples and libraries.

0.6.3
-----

### Rails

Bug fix: The http_images_path configuration default should be "/images" instead of "/public/images".

### Command Line

These changes, coupled with upcoming changes to Sass result in significantly reduced time spent on compilation for large projects.

* The compass command line will no longer recompile sass files that haven't changed (taking import dependencies into account).
* The compass command line will now respect the -q (quiet) option during compilation. Additionally, the quiet option will be set by default when watching a project for changes.

0.6.2
-----

### Blueprint

Split the push and pull mixins into sub-mixins that separate the common styles from the ones that vary. The generated css when using presentational class names will be smaller as a result. The existing <code>+push</code> and <code>+pull</code> mixins continue to work as expected. The following mixins were added:

    +push-base
    +push-margins
    +pull-base
    +pull-margins

Additonally, the liquid plugin was updated to have a span mixin that matches elsewhere.

### YUI

Added Yahoo's version of the css reset. To use it, mix into the top level of your project:

    @import yui/modules/reset.sass
    +reset

### Rails

* Conditionally defining #blank? on String/NilClass (Erik Bryn <erik.bryn@gmail.com>)
* Set compass environment in plugin based on RAILS_ENV (Lee Nussbaum <wln@scrunch.org>)

0.6.1
-----

Maintenance release that fixes several bugs in the handling of configuration files.

0.6.0
-----

### New Core Functionality: **Patterns**

Patterns give a framework or plugin access to the compass installer framework
to install customizable sass, html as well as image and javascript assets.

A pattern is a folder in the plugin's templates directory. It must
have a manifest file that tells compass what to install and where.
Unlike the project template, a pattern can be stamped out any number of
times.

It is best for pattern stylesheets to only provide example usage to get
the user started. All the core styles for the pattern should be
distributed as part of the framework's stylesheets as mixins to
facilitate easy upgrades and bug fixing on the part of the pattern's
maintainer.

Example Usage:
compass --framework blueprint --pattern buttons

Please read the
[Wiki Page](http://wiki.github.com/chriseppstein/compass/patterns) for more information.

### New Command-line options:

1. <code>--validate</code><br/>
   Validate your project's compiled css. Requires java and probably only works on Mac and Unix.
2. <code>--grid-img [DIMENSIONS]</code><br/>
   Generate a background image to test grid alignment. Dimension is given as
   <column_width>+<gutter_width>. Defaults to 30+10.
3. <code>-p, --pattern PATTERN</code><br/>
   When combined with with the --framework option, will stamp a plugin's pattern named PATTERN.
4. <code>-n, --pattern-name NAME</code><br/>
   When combined with the --pattern option, the pattern that gets stamped out will
   be isolated in subdirectories named NAME.
5. <code>-c, --write-configuration</code><br/>
   Emit a compass configuration file into the current directory, taking any existing configuration
   file and any command line options provided into account. (command line options override
   configuration file options).

### New Sass Functions:

Compass projects can call these sass functions within their sass files, if you find them useful.

1. <code>enumerate(prefix, start, end)</code><br/>
   Generates selectors with a prefix and a numerical ending
   counting from start to end. E.g. enumerate("foo", 1, 3) returns "foo-1, foo-2, foo-3"
2. <code>image_url(path)</code><br/>
   Uses the compass configuration to convert a path relative to the compass
   project directory to a path that is either absolute for serving in an HTTP
   context or that is relative to whatever css file the function was being
   compiled into. In the future, this function may also tap into the rails
   asset host configuration.

### New Compass Core Mixins

1. <code>+float-left</code> & <code>+float-right</code><br/>
   In order to include fixes for IE's double-margin bug universally,
   floats were implemented as a utility mixins. These are available by importing
   compass/utilities/general/float.sass which also imports the clearfix module.
2. <code>+pie-clearfix</code><br/>
   Implementation of the
   [position-is-everything clearfix](http://www.positioniseverything.net/easyclearing.html)
   that uses content :after.

### Blueprint 0.8

The Compass port of Blueprint has been upgraded from 0.7.1 to 0.8.0. The 0.8.0 release
brings many bug fixes and a few backward incompatible changes if you use it's presentational
classnames (you don't do that, do you?). Upgrading to 0.8 is automatic when you upgrade to
compass 0.6.0. The Blueprint team didn't release a detailed changelog for me to point at here.
One of the key features of the release was the inclusion of three new core blueprint plugins
(a.k.a. folders you can copy). These are what prompted the development of the compass patterns
feature and two of them are packaged as patterns:

1. Buttons<br/>
   To install: <code>compass --framework blueprint --pattern buttons</code><br/>
   Then follow your nose.
2. Link Icons<br/>
   To install: <code>compass --framework blueprint --pattern link\_icons</code><br/>
   Then follow your nose.

The third plugin is the RTL (right-to-left) plugin. To use this one, simply import it after the import
of the blueprint grid and your mixins will be redefined to work in a left to right manner. Additionally,
it provides +rtl-typography mixin that works in conjunction with +blueprint-typography and should be mixed
in with it.

Lastly, I've rewrote some of the presentational class name generation code so that it very nearly
matches the blueprint CSS. Please note that they are not 100% the same because we fix some bugs
that are not yet fixed in blueprint-css and we use a different clearfix implementation.

### Bug Fixes

1. A Safari bug related to the +clearfix mixin was resolved.
2. Running the compass command line installer a second time.

### Bugs Introduced

Almost definitely. Please let me know if you encounter any problems and I'll get a patch out

[tdreyno]: http://github.com/tdreyno
[noel]: http://github.com/noel
[enricob]: http://github.com/enricob
[perezd]: http://github.com/perezd
[Chrononaut]: http://github.com/Chrononaut
[rails_template]: http://github.com/chriseppstein/compass/raw/4e7e51e2c5491851f66c77abf3f15194f2f8fb8d/lib/compass/app_integration/rails/templates/compass-install-rails.rb
[dturnbull]: http://github.com/dturnbull
[filiptepper]: http://github.com/filiptepper
[pixelmatrix]: http://github.com/pixelmatrix
[jsilver]: http://github.com/jsilver
[avit]: http://github.com/avit
[der-rich]: http://github.com/der-rich
[adamstac]: http://github.com/adamstac
[ttilley]: http://github.com/ttilley
[inline-block-list]: http://compass-style.org/reference/compass/typography/lists/inline-block-list/
[html5-reset]: http://compass-style.org/reference/compass/reset/utilities/#mixin-reset-html5
[blueprint_10_change]: https://github.com/chriseppstein/compass/compare/a05e1ee7c0a1e4c0f0595a8bb812daa47872e476...864780969d872a93b1fd3b4f39f29dd9f0c3fe75
[brandon]: http://brandonmathis.com/
[lemonade]: http://www.hagenburger.net/BLOG/Lemonade-CSS-Sprites-for-Sass-Compass.html
