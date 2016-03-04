# Compass documentation

* [About](#about)
* [Documentation setup](#documentation-setup)
* [Documentation project structure](#documentation-project-structure)
* [HOW-TOs](#how-tos)

If you want to work on a specific part of the docs, please let everyone know via the [Compass-devs google group](http://groups.google.com/group/compass-devs/browse_thread/thread/41dc723721a194f8).

---

## About

This is the documentation for Compass. Much of the documentation is read from the
Sass source files to keep the docs in-line with current state of the code as much as
possible.

If you're reading this, you might be thinking about helping to improve the Compass documentation by editing existing documentation or by adding new documentation.

There are two main kinds of documentation:

* Tutorials → Describe **how** to use Compass.
* Reference → Details about **what** Compass has.

It's possible and encouraged for related tutorials and reference documentation to
link to each other.

## Documentation setup

So you want to help documenting Compass?

Setting up the documentation for Compass is not super-easy, but it's pretty doable.

The Compass docs live in the source code of Compass. Not directly in the Sass files though: the documentation is a combination of inline comments and source code read directly from the Sass files, and hand-maintained documentation and examples. We use [nanoc](http://nanoc.stoneship.org/) to generate a static website, combined with some Ruby to read the Compass source.

The reasons for this setup are simple:

* to keep the documentation current, we need to read from the source code
* to read from the source code, we need to be in the source code

If you encounter any problems, there's usually some people around to help at #compass on freenode IRC.

### Prerequisites:

* a Github account, setup to be able to clone repos (see [GitHub Help](http://help.github.com/))
* [Git](http://git-scm.com/downloads) installed on your computer
* a basic knowledge of Git ([Pro Git](http://git-scm.com/book) is an excellent free guide)

Make sure that you have RubyGems v1.3.6 or greater:

```sh
$ gem -v
```

If that doesn't work, RubyGems is probably out of date, try:

```sh
$ (sudo) gem update --system
```

You will need the [Bundler](http://gembundler.com/) gem, so if you don't have it:

```sh
$ (sudo) gem install bundler
```

A list of the gems on your system can be accessed via `gem list`. Run `gem list bundler` to see if you have bundler installed.

### 1. Get your own copy of Compass (fork)

Make your own fork of Compass on Github by clicking the "Fork" button on [http://github.com/chriseppstein/compass](http://github.com/chriseppstein/compass), then go to your fork of Compass on GitHub. Your compass fork will be available at `http://github.com/<your-username>/compass` .

### 2. Directory setup

`git clone` your fork of the Compass repository:

```sh
$ git clone git@github.com:<your-username>/compass.git
```

### 3. Bundler

If you haven't yet done so, install bundler:

```sh
$ (sudo) gem install bundler
```

Bundle the gems for this application:

```sh
$ cd compass-style.org
$ bundle install
```

### 3/4. Binstubs

If your bundler is still stuck with generating binstubs (an approach we
used before), check if there's a `.bundler` directory in
`compass-style.org`. If there is, delete it and try again. If you don't
know what we're talking about, then everything is fine, continue... :)

### 4. Compile the docs

First, make sure you're in the `compass-style.org` directory. To watch the folder for changes and to preview the site in your browser, run:

```sh
$ foreman start
```

Then go to [http://localhost:3000](http://localhost:3000) to view the site.

We use [foreman](https://github.com/ddollar/foreman) to combine two nanoc commands using a `Procfile`, which you'll find in `compass-style.org`. If you take a look a it, you'll see two processes, `watch` and `view`:

```sh
watch: bundle exec nanoc watch
view: bundle exec nanoc view -H thin
```

`nanoc watch` watches for changes and `nanoc view -H thin` previews the site using thin (rather than WEBrick, which it would use by default). We suggest you install [Growl](http://growl.info/) or [rb-inotify](https://github.com/nex3/rb-inotify) so you can receive notifications when the site is done compiling.

Your basic workflow might look like this:

1. run `foreman start`
1. open [http://localhost:3000](http://localhost:3000)
1. make changes in the project files (and save them)
1. wait for the notification that the compilation is complete
1. refresh the browser to see the changes
1. go to 3.

If you refresh the browser before the compilation is complete, nothing bad will happen, you just won't see the change until the compilation finishes (and you refresh again). That's because the site is compiling asynchronously.

Auto-compiling on file change might not be your thing. In that case, keep this process running in a separate terminal window:

```sh
$ bundle exec nanoc view -H thin
```

and run:

```sh
$ bundle exec nanoc (compile)
```

every time you want to compile the site and see the changes.

If this doesn't work for you, you could try nanoc's `aco` (or `autocompile`) command:

```sh
$ bundle exec nanoc aco -H thin
```

It compiles and previews the site in the browser (also at [http://localhost:3000](http://localhost:3000)), then recompiles it on each request. The difference from the previous approach is that the site is recompiled each time a page is requested, not when a file is changed. This approach is usually more sluggish because it's synchronous.

For convenience, all these commands are written as rake tasks:

```sh
$ rake watch    # bundle execn nanoc watch
$ rake view     # bundle exec nanoc view -H thin
$ rake compile  # bundle exec nanoc (compile)
$ rake aco      # bundle exec nanoc aco -H thin
```

if you choose not to use the Procfile approach.

It is recommended that you read the 5 minute [tutorial](http://nanoc.stoneship.org/tutorial/) on nanoc.

### 5. Commit your changes to your fork

When you're happy with the changes you made and you're ready to submit them, use `git add` to stage the changes, then commit them with:

```sh
$ git commit
```

When you're ready to push your changes to your Compass fork on GitHub, run:

```sh
$ git push -u origin <branch>
```

depending on which branch you want to push. Your changes are now reflected on your github repo. Go to Github and click the "Pull Request" button on top of your repo to notify Chris of changes. He will verify them and merge them into the master.

#### How to pull in new changes

Add the original Compass repository to your Git remotes:

```sh
$ git remote add chris git://github.com/chriseppstein/compass.git
```

Then get the new changes with fetch:

```sh
$ git fetch chris
```

And merge them with your local docs branch:

```sh
$ git merge chris
```

## Documentation project structure

<table>
  <tbody>
    <tr>
      <td><strong>.compass/config.rb</strong></td>
      <td>Compass configuration of the project.</td>
    </tr>
    <tr>
      <td><strong>content/</strong></td>
      <td>Content of the project.</td>
    </tr>
    <tr>
      <td><strong>content/reference/</strong></td>
      <td>Reference documentation.</td>
    </tr>
    <tr>
      <td><strong>content/examples/</strong></td>
      <td>Examples.</td>
    </tr>
    <tr>
      <td><strong>content/help/tutorials/</strong></td>
      <td>Tutorial documentation.</td>
    </tr>
    <tr>
      <td><strong>content/stylesheets/</strong></td>
      <td>Sass stylesheets for the project.</td>
    </tr>
    <tr>
      <td><strong>assets/css/</strong></td>
      <td>Third-party, plain old CSS files.</td>
    </tr>
    <tr>
      <td><strong>assets/images/</strong></td>
      <td>Images.</td>
    </tr>
    <tr>
      <td><strong>assets/javascripts/</strong></td>
      <td>JavaScript files.</td>
    </tr>
    <tr>
      <td><strong>layouts/</strong></td>
      <td>Layouts for the project.</td>
    </tr>
    <tr>
      <td><strong>layouts/partials/</strong></td>
      <td>Partials for the project.</td>
    </tr>
    <tr>
      <td><strong>lib/</strong></td>
      <td>Ruby code – helper code and Sass source inspection is done here.</td>
    </tr>
  </tbody>
</table>

## HOW-TOs

### How to Add an Asset

If you are adding an asset (e.g. image, CSS, JavaScript) place the file(s) in the appropriate directories under the `assets` directory.

### How to Add a New Example

(Again, make sure you're in the `compass-style.org` directory.)

We're using [Thor](https://github.com/wycats/thor) to generate examples and references. The command for generating examples is `generate:example`, you can see command's description and available options by running:

```sh
$ thor help generate:example
```

which produces:

```sh
Usage:
  thor generate:example path/to/module

Options:
  -t, [--title=TITLE]              # Title of the example.
  -d, [--description=DESCRIPTION]  # Description of the example, which is shown below the link.
  -m, [--mixin=MIXIN]              # Name of the specific mixin in the module if the example isn't about the whole module.

Generates a new example.
```

All of these are optional and have reasonable defaults, you can use them when understand what exactly they are setting. They are all simple metadata values, so you can change them later on.

**Note**: When generating examples or references, Thor is searching for the appropriate
module stylesheet. If it doesn't find one, it raises an error and doesn't
generate anything. So before generating anything make sure the stylesheet exists and is
under `../core/stylesheets/compass/path/to/module` (relative to the `compass-style.org` directory). If the path confuses you, just take a few minutes to study how other modules are organized and you'll quickly get the hang of it.

Let's do an example:

```sh
$ thor generate:example typography/lists/inline-block-list
```

which produces the following output:

```
Generating /examples/compass/typography/lists/inline-block-list/
DIRECTORY content/examples/compass/typography/lists/inline-block-list/
   CREATE content/examples/compass/typography/lists/inline-block-list.haml
   CREATE content/examples/compass/typography/lists/inline-block-list/markup.haml
   CREATE content/examples/compass/typography/lists/inline-block-list/stylesheet.scss
```

The command generated three files:

1. `inline-block-list.haml` → The main container, it contains example metadata
   and description.
1. `markup.haml` → The markup for the example, it will be shown as HTML and as Haml and it's styled with `stylesheet.scss`.
1. `stylesheet.scss` → The style for the example, it will be shown as SCSS, Sass
   and as CSS. This is the main file as it is demonstrating the module.

`markup.haml` and `stylesheet.scss` are pretty self-explanatory, but we might want take a look at `inline-block-list.haml`.

```
---
title: Inline Block List
description: How to use Inline Block List
framework: compass
stylesheet: compass/typography/lists/_inline-block-list.scss
example: true
---
- render "partials/example" do
  %p Lorem ipsum dolor sit amet.
```

The stuff between `---` is called YAML front matter, it's describes example's metadata which is used to associate the example to the reference documentation.

If your example covers only a specific mixin, not the whole module, you can add
`mixin: <your-mixin>` to the metadata. This will display the example link right below
that mixin in the reference (otherwise, it will appear near the top, below the module
description).

After adding the example and adjusting the metadata, go to the reference page in your browser and you can verify that a link to the example has appeared.

### How to Add New Reference Documentation

Existing modules already have reference files, so you'll most likely be adding
reference files to new modules.

So we got a great idea for an awesome module, and after a lot of thinking we decided to name it `super-awesome-module`. The first step to adding a new module is creating the stylesheet. Let's say this will be a Compass CSS3 module, so we'll create a new file as `../core/stylesheets/compass/css3/_super-awesome-module.scss` (relative to the `compass-style.org` directory). Keep in mind that the comments inside those stylesheets are parsed with Markdown and output into the reference.

The easiest way to find out how you should write your stylesheet is to take a look at some existing modules. This module won't be very useful, but you'll get the point:

```scss
@import "shared";

// Super awesomeness variable.
$default-super-awesomeness : true !default;

// Super awesome mixin.
@mixin super-awesome {
  @if $default-super-awesomeness {
    $a: 5;
  }
}
```

Now that we have a stylesheet, we can generate the reference for it using the
`generate:reference` command. We can first see what it does by running:

```sh
$ thor help generate:reference
```

which produces:

```sh
Usage:
  thor generate:reference path/to/module

Options:
  -t, [--title=TITLE]          # Title of the reference.

Generate a reference page for the given module.
```

Now we can create a reference file for our new module:

```sh
$ thor generate:reference css3/super-awesome-module
```

Which produces the following output:

```
Generating /reference/compass/css3/super-awesome-module/
DIRECTORY content/reference/compass/css3/super-awesome-module/
   CREATE content/reference/compass/css3/super-awesome-module.haml
```

If we open `super-awesome-module.haml`, we can see our reference template:

```
---
title: Compass Super Awesome Module
crumb: Super Awesome Module
framework: compass
stylesheet: compass/css3/_super-awesome-module.scss
layout: core
classnames:
  - reference
  - core
---
- render "reference" do
  %p Lorem ipsum dolor sit amet.
```

If `title` and `crumb` are the way you want them to be, your metadata should be good to go. Check the reference in your browser (it should be listed as a module in CSS3), if the style appears broken, take a look at the metadata of sibling stylesheets and adjust yours accordingly. If everything looks fine you can start writing the module's description below.

Unlike what you might have guessed, the reference file only holds the main
description of the module. Descriptions of specific variables, functions and
mixins should be written as comments in the stylesheet file.

Happy documenting!
