COMPASS CHANGELOG
=================

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
