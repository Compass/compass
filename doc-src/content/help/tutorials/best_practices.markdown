---
title: Best practices
crumb: Best practices
layout: tutorial
classnames:
  - tutorial
---

# Best Practices

Here are some best practices for making your projects easier to build and
simpler to maintain.

## Use a Base stylesheet file

Create a `_base.scss` [partial][1] to initialize your stylesheets with common
variables and ([often][2]) the framework utilities you plan to use:

### _base.scss

    $blueprint-grid-columns : 24;
    $blueprint-grid-width   : 30px;
    $blueprint-grid-margin  : 10px;
    $font-color             : #333;

    @import "compass/reset";
    @import "compass/utilities";
    @import "blueprint";

    // etc.

The `_base.scss` file is also a great place to keep your own custom mixins, so
they’re available to any stylesheet that includes it.

Then you can include this file in all other stylesheets:

### application.scss

    @import "base";

    #wrapper {
      @include container;
    }

    // etc.

It is important to define any compass/framework constants that you want to override
in base.scss first, before @import-ing the framework files. See [Working with 
Configurable Variables][3], for a specific example.  Note that you can refer to `_base.scss` without the
leading underscore and without the extension, since it is a [partial][1].

## Write your own Custom Mixins

Mixins let you insert any number of style rules into a selector (and its
descendants!) with a single line. This is a great way to [DRY][4] up your
stylesheet source code and make it much more maintainable. Using mixins will
also make your stylesheet look like self-documented source code -- It’s much
more obvious to read something like `@include round-corners(6px, #f00)` than the whole
list of rules which define that appearance.

## Presentation-free Markup

CSS was created to extract the presentational concerns of a website from the
webpage content. Following this best practice theoretically results in a website
that is easier to maintain. However, in reality, the functional limitations of
CSS force abstractions down into the markup to facilitate the [DRY][4] principle
of code maintainability. Sass allows us to move our presentation completely to
the stylesheets because it let's us create abstractions and reuse entirely in
that context. Read [this blog post][5] for more information on the subject.

Once you have clean markup, style it using Mixins and Inheritance. With clean
and clear abstractions you should be able to read stylesheets and imagine what
the webpage will look like without even loading the page in your web browser.

If you find your CSS is getting too bloated due to sharing styles between
semantic selectors, it may be time to refactor. For instance this stylesheet
will be unnecessarily bloated:

    @mixin three-column {
      .container { @include container;  }
      .header,
      .footer    { @include column(24); }
      .sidebar   { @include column(6);  }
      article    { @include column(10); }
      .rightbar  { @include column(8);  }
    }
    body#article,
    body#snippet,
    body#blog-post { @include three-column; }

Instead, ask yourself "what non-presentational quality do these pages share in
common?" In this case, they are all pages of content, so it's better to apply a
body class of "content" to these pages and then style against that class.

## Nest selectors, but not too much.

It's easier to style a webpage from scratch or starting from some common base
point for your application than it is to contend with unwanted styles bleeding
into your new design. In this way, it is better to use some basic nesting of
styles using some selector early in the markup tree. And then to refactor as patterns of use emerge to reduce bloat.

It's important to remember that long selectors incur a small rendering
performance penalty that in aggregate can slow down your web page. There is
no need to exactly mimic your document structure in your css. Instead nest
only deep enough that the selector is unique to that part of the document.
For instance, don't use `table thead tr th` when a simple `th` selector will
suffice. This might mean that you have to separate your styles into several
selectors and let the document cascade work to your advantage.

[1]: http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#partials
[2]: http://groups.google.com/group/compass-users/browse_frm/thread/0ed216d409476f88
[3]: http://compass-style.org/help/tutorials/configurable-variables/
[4]: http://c2.com/cgi/wiki?DontRepeatYourself
[5]: http://chriseppstein.github.com/blog/2009/09/20/why-stylesheet-abstraction-matters/
