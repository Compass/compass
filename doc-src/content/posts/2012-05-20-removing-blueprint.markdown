---
title: "Removing Blueprint from Compass in 0.13"
description: "Blueprint will be extracted to a plugin"
author: chris
---

Five years ago, [Blueprint CSS](http://blueprintcss.org/) was an
innovative CSS Framework. It was a boilerplate before
[H5BP](http://html5boilerplate.com/) and it was the most popular CSS
Grid Framework when the concept was still young.

Blueprint's regular structure and common-sense approach, together with
its inherent weaknesses, was a major inspiration for the development of
Compass. In fact, Compass started solely as a rejected sass-based
toolchain for the blueprint project.

Sadly, the blueprint core team, while having never officially announced
that the project is over, has through negligence, caused the project to
fall behind. It has not kept up with layout and responsive approaches
that are essential to web design in 2012.

Furthermore, there are many new layout mechanisms coming in CSS: 
[columns][css-columns], [box-sizing][box-sizing], [regions][css-regions],
[grid layout][css-grid], and [flexbox][css-flexbox]. The future of
layout looks bright and we want Sass users to be at the forefront of
their adoption, establishing the best practices of 2015 instead using
the best practices from 2009.

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

If you are looking for a grid system for your next site, or to replace
blueprint with something more modern. We suggest you look into
[Susy](http://susy.oddbird.net/). It is written by Compass core team
member, [Eric Meyer](http://twitter.com/eriiicam). Susy 1.0 has been
completely overhauled to take advantage of modern browsers and the very
latest features in Sass 3.2 and Compass 0.13. If you have a favorite
grid framework, please feel free to mention it in the comments.

**TL;DR** Starting in Compass 0.13, blueprint will be extracted from compass
and available as a compass extension named `compass-blueprint`.


[css-columns]: http://www.w3.org/TR/css3-multicol/
[css-grid]: http://dev.w3.org/csswg/css3-grid-layout/
[css-regions]: http://dev.w3.org/csswg/css3-regions/
[css-flexbox]: http://www.w3.org/TR/css3-flexbox/
[box-sizing]: http://caniuse.com/css3-boxsizing
