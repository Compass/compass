---
title: "Compass v0.12 is Released"
description: "Compass 0.12: Flexible Sprites, Rails Integration"
author: chris
---

Compass 0.12 is out! Install it now:

    $ (sudo) gem install compass

This release is primarily to support the Rails Asset Pipeline which
required major changes to the Compass internals. If you use rails
with Compass please read the [blog post about the new compass-rails
gem][compass-rails].

In addition to the rails improvements this release contains many updates
to Compass Sprites:

* **Sprite Layouts**: `vertical` (default), `horizontal`, `diagonal`, and `smart`
  layouts are now available. Different layouts may allow you to use
  sprites more easily with differing design requirements. The `smart`
  layout will efficiently pack sprites of different sizes -- resulting
  in smaller file sizes. To select a layout set the
  `$<spritename>-layout` variable to your desired layout name.
* **Sprite Load Path**: Sprite source files can now be stored in more locations than
  just your images directory. To add sprite locations in your compass
  configuration: `sprite_load_path << 'my/sprite/folder'
* **Sprite output location**: If you need to output sprites to a
  location other than the images directory set `generated_images_dir`,
  `generated_images_path`, `http_generated_images_dir`, and
  `http_generated_images_path` in your compass configuration according
  to your needs. You can refer to images in your generated images
  directory using the `generated-image-url()` function.

Additionally there are many new CSS3 improvements, bug fixes, and other
small enhancements that you can read about in the
[CHANGELOG](/CHANGELOG/).

What's next for Compass? First, we've added [Anthony
Short](/blog/2012/03/11/anthony-short-joins-the-compass-core-team/) to
the team and we're really excited to see him come make our stylesheets
even more awesome. The Sass 3.2 release is coming soon and the 0.13
release of compass will take advantage of the great features that it
offers. Additionally, we're working on an extension registry where you
can post your compass extensions and discover new ones.  Lastly, we'll
be extracting blueprint to a compass extension as that project seems to
have stagnated. I'd say we're getting pretty close to a 1.0 release!

[compass-rails]: /blog/2012/01/29/compass-and-rails-integration/
