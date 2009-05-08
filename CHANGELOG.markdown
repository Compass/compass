COMPASS CHANGELOG
=================

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
