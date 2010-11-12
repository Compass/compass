FYI: I'm abandoning the even/odd release numbering scheme in favor of using preview releases. Going forward the master branch will use the following release numbering:

* 0.11.0.alpha.N.shortsha (Not tagged)
* 0.11.0.beta.N (tagged, new features expected)
* 0.11.0.rc.N (tagged, no new features expected)

MUST:
* A proper welcome page for blueprint projects (or delete it)
* Rails Integration

NICE:
* some extension commands
* Better help for commands and patterns
* Color Palette extraction and management commands

v0.11
=====
Planned Release Date: Aug 2, 2010
This is a quick iteration release. The focus on turning out
even better documentation and some stylesheet updates and
enhancements that take better advantage of the Sass 3 features.

### Docs (can be done on stable)

* Improve the design
* Better tutorials and getting started guides.
* Terminal for Designers
* Better examples & example navigation
* Contribution guide:
  * Compass stylesheets
  * Compass ruby code
  * Documentation patches
* SCSS Style Guide
* Bundler 1.0 support
* Upgrade nanoc
* Better search experience
* Search mixins and constants and code fragments that might use those.
* Awesome homepage that is better integrated with the docs.
* HTML5 the docs so they can run locally in offline mode.

### Compass Core

* Updates as necessary to the CSS3 module as the spec process develops.
* Typography module

### Blueprint

* Provide an option to use @extend in the blueprint grid

### Rails

* Fully integrated support of Rails 3

### Other

* Consider adding app integration with: Node.js, Django, Drupal, Wordpress
  (Wherever opinionated layouts exist). Also, try to make one of these a plugin
  to test out the concept.
* clean up all the argument names in preparation for keyword argument support from sass.

v0.12 
=====

This release depends on Sass 3.2 and is aimed at taking advantage of
the new sass 3.2 feature set as well as really making the extensions
system come alive. Since I don't foresee any deprecations in Sass 3.2,
this will not be a coordinated release. Instead, this release will
trail Sass 3.2 by a month or two.

### Compass Core

* Figure out what to do about multiple attribute properties like background.
  Might require list and function support from sass.

### Blueprint

* If sass 3.2 is out with @function support, use that for grid
  calculations, otherwise punt to 1.0.

### Extensions

* Extension registry on compass-style.org.
* One step publishing via github + webhooks
* Easy install via CLI
* Local (per-user) extension repo with auto-discovery.
* Video showing how easy it is to create, publish, and install an extension.


v1.0 - Polaris
==============

### Blueprint

* If the @extend version of the grid is full of win, make it the default.

### Sassdoc

Extract the compass documentation system into a stand-alone project.

### Extensions

* Build basic docs and host them for all extensions using sassdoc.
* Support for selling extensions and taking a cut for umdf.org?

### Project Tools

* enable building project docs using the sassdoc tool.

v2.0
====

Version 2 is all about making compass easier to use. Compass and Sass
will have a GUI that makes it simple to manage your projects.

### GUI Prerelease 1

* Concept brainstorming
* mockups
* How can compass gui and sass gui interoperate or plug in.

### GUI Prerelease 2

Beta release as a separate install.

### GUI Prerelease 3

* Iterate based on feedback.
* Integrate with a Sass GUI.
* Embed the docs

### One-click Installers

Install compass and sass with one click

* Windows (Only if someone else wants to build and maintain it.)
* Mac (.dmg + drag & drop app or installer)
* Linux (Get distro packages going and in place for the 1.0 release)
