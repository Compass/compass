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
* `content/css` - Third-party, plain old CSS files.
* `content/images` - Images. Duh.
* `content/javascripts` - Javascripts. Double Duh.
* `content/stylesheets` - Sass stylesheets for the project.
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
    $ bin/nanoc3 aco

Then open `http://localhost:3000/` in your web browser.

## Documentation on Nanoc

* [Nanoc Homepage](http://nanoc.stoneship.org/)

## HOW-TOs

### How to Add an Asset

If you are adding an asset (E.g. image, css, javascript) place the file(s) in the appropriate directories under the `content` directory. Then run: `rake itemize` and a yaml file will be generated for each of the new files.

### How to Add New Reference Documentation

In the appropriate directory under content/reference add two files:

1. `some_module.haml`
2. `some_module.yaml`

You will find it convenient to copy the yaml file of another reference item and edit it.
Likewise, you'll find it convenient to copy the haml file of another reference item and edit it.

The item metadata must provide some details about what stylesheet is being documented. For instance, here is the metadata for the blueprint color module item:

    --- 
    title: Blueprint Color Module
    crumb: Colors
    framework: blueprint
    stylesheet: blueprint/_colors.sass
    classnames:
      - reference

The `title` and `crumb` attributes are the H1 and the Breadcrumb label respectively. The `framework` attributes specifies what framework is being documented and similarly, the `stylesheet` attribute specifies what stylesheet. The `classnames` array allows class names to be applied to the body. Be sure to apply the `reference` class at a minimum.

There are some shared partials that do most of the sass file inspection and formatting. Most of the docs are kept in the source code, but if there are times when you need more control, you can drop down to more powerful tools.

All source comments are formatted in Markdown.