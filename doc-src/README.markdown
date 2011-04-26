# Compass documentation

This document consists of 2 parts:

* [Documentation README: general structure and how-to's](#documentation_readme)
* [How to get your documentation up and running](#documentation_setup) 

If you want to work on a specific part of the docs, please let everyone know via the [Compass-devs google group](http://groups.google.com/group/compass-devs/browse_thread/thread/41dc723721a194f8).

---

# Documentation README

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

---

# Documentation setup

So you want to help documenting Compass?

Setting up the documentation for Compass is not super-easy, but it's pretty doable.

The Compass docs live in the source code of Compass. Not directly in the Sass files though: the documentation is a combination of inline comments and source code read directly from the Sass files, and hand-maintained documentation and examples. We use [Nanoc](http://nanoc.stoneship.org/) to generate a static website, combined with some Ruby to read the Compass source.

The reasons for this setup are simple:

* To keep the documentation current, we need to read from the source code
* To read from the source code, we need to be in the source code

If you encounter any problems, there's usually some people around to help at #compass on freenode IRC.

### Prerequisites:

* A Github account, setup to be able to clone repos (see (GitHub Help)[http://help.github.com/])
* Git installed on your computer
  * The git installer for OSX can be found here: http://code.google.com/p/git-osx-installer/
* A basic knowledge of git

Make sure that you have RubyGems v1.3.6 or greater:

    $ gem -v

If that doesn't work, RubyGems is probably out of date, try:

    $ sudo gem update --system

You will need the bundler gem, so if you don't have it:

    $ gem install bundler

(A list of the gems on your system can be accessed via `gem list`)

### 1. Get your own copy of Compass (Fork)

Make your own Fork of Compass on Github: click the 'Fork' button on http://github.com/chriseppstein/compass

Go to your fork of Compass on github. Your compass fork will be available on http://github.com/**yourusername**/compass .

### 2. Directory setup

`git clone` your Fork of the Compass repository:

    $ git clone git@github.com:**yourusername**/compass.git

### 3. Don't forget: bundler!

If you haven't yet done so, install bundler:

    $ sudo gem install bundler

Bundle the gems for this application:

    $ cd doc-src
    $ bundle install --binstubs

### 4. Compile the docs

To compile (and auto recompile) and preview the site in your browser: (make sure you run nanoc3 aco from the doc-src directory)

    $ cd doc-src
    $ ./bin/nanoc3 aco

Then open `http://localhost:3000/index.html` in your web browser.

aco stands for autocompiler; the site will recompile every time you request a new page.

If you find `./bin/nanoc3 aco` to be sluggish, try this alternative workflow:

    $ cd doc-src
    $ ./bin/serve 3000 output &
    $ ./bin/rake watch

It is recommended that you read the 5 minute [tutorial](http://nanoc.stoneship.org/tutorial/) on Nanoc.

### 5. Commit your changes to your Fork

    git commit -a
    git push

Your changes are now reflected on your github repo. Go to Github and click the 'pull request' button on top of your repo to notify Chris of changes. He will verify them and merge them into the master.

#### How to pull in new changes

Add git://github.com/chriseppstein/compass.git to your git remotes:

    git remote add chris git://github.com/chriseppstein/compass.git

Then get the new changes with fetch:

    git fetch chris

And merge them with your local docs branch:

    git merge chris