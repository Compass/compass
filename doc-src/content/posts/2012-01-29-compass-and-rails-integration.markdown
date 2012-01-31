---
title: "Compass/Rails Integration in v0.12"
description: "Starting in Compass v0.12 compass's rails integration is
done via a new project called compass-rails."
author: chris
---

The Compass v0.12 release is way behind schedule but it's finally getting
very close to release. The main goal of the v0.12 release has been to add
support for the rails asset pipeline and we hope that you'll agree that this
release achieves the very best integration with rails that compass has
ever provided.

In v0.12, we've create a new gem called `compass-rails` to provide full
support for rails 2.3 and greater. Let me tell you, this was no small
feat. 2.3 lacks Railtie support and 3.1 introduced the asset pipeline.
Backflips were performed; blood, sweat, and tears were shed; Monkeys
were patched and Ducks were punched.

The compass command line tool will now be aware of and compass
configuration settings you've made in your rails configuration files
and/or in the compass configuration file.  You can use the approach that
best suites your workflow.

While the asset pipeline is convenient, large applications with lots of
stylesheets and many imports can become sluggish in development mode. To
make things snappier, you can now run the compass watcher in a separate
terminal to begin compilation as soon as you save. In combination with
tools like [live-reload](https://github.com/mockko/livereload), you may
not even need to reload your webpage to see the result in your browser.

Compass extensions and their starter files can be added to your rails
project following the extensions' existing installation instructions.
No special consideration is needed to support rails except to note
that the extension gem should be listed in the `:assets` group of your
Gemfile and you might need to use `bundle exec` to launch the compass
command line tool.

Having a dedicated gem for integration provides a number of benefits.
First, it means that we can release rails integration fixes on a
separate release schedule from the main compass library. Second, it
solves a chicken & egg problem we had where the command-line tools
didn't know whether they were dealing with a rails project until it was
too late. Finally, it allowed us to clean up some of the Compass
internals. To be clear, this gem doesn't mean that Rails support is
deprecated or a second class citizen in any way.

Huge thanks go to [Scott Davis](https://github.com/scottdavis) for his
hard work on the compass-rails gem.
