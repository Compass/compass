Documentation README
====================

This is the documentation for Compass. Much of the documentation is read from the
sass source files to keep the docs in-line with current state of the code as much as
possible.

If you're reading this, you might be thinking about helping to improve the compass documentation by editing existing documentation or by adding new documentation.

There are two main kinds of documentation:

* Tutorials: Describe HOW to use compass.
* Reference: Details about WHAT compass has.

It's possible and encouraged for related tutorials and reference documentation to
link to each other.

## Getting Around the Documentation Project

* `.compass/config.rb` - This is where the compass configuration is kept.
* `content/` - This directory is where content for the documentation project is kept.
* `content/reference` - This is where reference documentation is kept.
* `content/tutorials` - This is where tutorial documentation is kept.
* `content/stylesheets` - Sass stylesheets for the project.
* `assets/css` - Third-party, plain old CSS files.
* `assets/images` - Images.
* `assets/javascripts` - Javascripts.
* `layouts` - Layouts are kept here.
* `layouts/partials` - Partials are kept here.
* `lib` - Ruby code. Helper code and sass source inspection is done here.

## Installing Dependencies

If you haven't yet done so, install bundler:

    gem install bundler

Bundle the gems for this application:

    gem bundle

Your new app executables for this app are located in the bin/ directory.

## Compiling the Site

To compile (and auto recompile) and preview the site in your browser:

    $ cd doc-src
    $ export RUBYLIB="../lib:../../haml/lib"
    $ bin/nanoc3 aco

Then open `http://localhost:3000/` in your web browser.

If you find `bin/nanoc3 aco` to be sluggish, try this alternative workflow:

    $ cd doc-src
    $ export RUBYLIB="../lib:../../haml/lib"
    $ serve 3000 .. &
    $ rake watch

## Documentation on Nanoc

* [Nanoc Homepage](http://nanoc.stoneship.org/)

## HOW-TOs

### How to Add an Asset

If you are adding an asset (E.g. image, css, javascript) place the file(s) in the appropriate directories under the `assets` directory.

### How to Add a New Example

Running the following command will generate a new example:

    ./bin/thor generate:example blueprint/grid/simple/

An example consists of three files:

1. The Example Container - The default generated container uses a shared partial for the container, but doesn't have to.
2. Some Markup - The `markup.haml` file is located within a directory of the same name as container. This Haml gets converted to HTML and then displayed to the user as well as included into the page for styling.
3. Some Sass - The `stylesheet.sass` file is located within a directory of the same name as container. This Sass gets displayed to the user. Also, the sass will be compiled and the CSS will be used to style the example as well as displayed to the user.

Example Metadata is used to associate the example to a mixin in the reference documentation:

    --- 
    example: true
    title: My Example
    description: This is an example of some awesome mixin.
    framework: compass
    stylesheet: compass/_awesome.sass
    mixin: awesome
    ---

After adding the example and adjusting the metadata, go to the reference page and you can verify that a link to the example has appeared. If the mixin property is omitted, then the example will be a general example for the stylesheet.

### How to Add New Reference Documentation

Generate a reference file for a stylesheet:

    ./bin/thor generate:reference ../frameworks/compass/stylesheets/_compass.sass

The item metadata (at the top of the file) provides some details about what stylesheet is being documented. For instance, here is the metadata for the blueprint color module item:

    --- 
    title: Blueprint Color Module
    crumb: Colors
    framework: blueprint
    stylesheet: blueprint/_colors.sass
    classnames:
      - reference
    ---

The `title` and `crumb` attributes are the H1 and the Breadcrumb label respectively. The `framework` attributes specifies what framework is being documented and similarly, the `stylesheet` attribute specifies what stylesheet. The `classnames` array allows class names to be applied to the body. Be sure to apply the `reference` class at a minimum.

There are some shared partials that do most of the sass file inspection and formatting. __Most of the docs are kept in the source code__, but if there are times when you need more control, you can drop down to more powerful tools.

All source comments are formatted in Markdown.
