---
title: "Removing Blueprint from Compass in 0.13"
description: "Blueprint will be extracted to a plugin"
author: chris
draft: true
---

Five years ago, [Blueprint CSS](http://blueprintcss.com/) was an
innovative CSS Framework. It was a boilerplate before H5BP and
it was the most popular CSS Grid Framework when the concept was
still young.

Blueprint's regular structure and common-sense approach, together with
its inherent weaknesses, was a major inspiration for the development of
Compass. In fact, Compass started solely as a rejected sass-based
toolchain for the blueprint project.

Sadly, the blueprint core team, while having never officially announced
that the project is over, has through negligence, caused the project to
fall behind. It has not kept up with layout and responsive approaches
that are essential to web design in 2012. Meanwhile, Sass and Compass
have ushered in a new era of grid systems. There are literally dozens of
sass-based grid frameworks to choose from.

Given these developments, we have decided that it is time for Compass to
get out of the "Grid Business". Starting in 0.13 (our next major
release) we will have removed Blueprint from Compass. The stylesheets
will be extracted as a plugin so that our users can continue to
use it, if they need to. At that time, you can install it with two
simple steps:

1. `gem install compass-blueprint`
2. Edit your compass configuration and add: `require 'compass-blueprint'`

We hope that this means that the Compass community will think more
carefully about the grids that they use and whether they meet their
project's specific needs.

If you are looking for a grid system for your next site, or to
replace blueprint with something more modern. We suggest you look into
the following:

* [Susy](http://susy) - By Compass core team member,
  [Eric Meyer](http://twitter.com/eriiicam), this framework has been
  completely overhauled to take advantage of modern browsers and the
  very latest features in Sass 3.2 and Compass 0.13.
* other
* other
* other
* This is not a comprehensive list, feel free to pitch yourfavorite
  in the comments.

**TL;DR** Starting in Compass 0.13, blueprint will be extracted from compass
and available as a compass extension named `compass-blueprint`.

