# Compass documentation

* [About](#about)
* [Documentation setup](#documentation_setup)
* [Documentation project structure](#documentation_project_structure)
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

    $ gem -v

If that doesn't work, RubyGems is probably out of date, try:

    $ (sudo) gem update --system

You will need the [Bundler](http://gembundler.com/) gem, so if you don't have it:

    $ (sudo) gem install bundler

A list of the gems on your system can be accessed via `gem list`. Run `gem list bundler` to see if you have bundler installed.

### 1. Get your own copy of Compass (fork)

Make your own fork of Compass on Github by clicking the "Fork" button on [http://github.com/chriseppstein/compass](http://github.com/chriseppstein/compass), then go to your fork of Compass on GitHub. Your compass fork will be available at `http://github.com/<your-username>/compass` .

### 2. Directory setup

`git clone` your fork of the Compass repository:

    $ git clone git@github.com:<your-username>/compass.git

### 3. Bundler

If you haven't yet done so, install bundler:

    $ (sudo) gem install bundler

Bundle the gems for this application:

    $ cd doc-src
    $ bundle install

### 3/4. Binstubs

If your bundler is still stuck with generating binstubs (an approach we used before), check if there's a `.bundler` directory in `doc-src`. If there is, delete it and try again. If you don't know what we're talking about, then everything is fine, continue... :)

### 4. Compile the docs

First, make sure you're in the `doc-src` directory. To watch the folder for changes and to preview the site in your browser, run:

    $ foreman start

Then go to [http://localhost:3000](http://localhost:3000) to view the site.

We use [foreman](https://github.com/ddollar/foreman) to combine two nanoc commands using a `Procfile`, which you'll find in `doc-src`. If you take a look a it, you'll see two processes, `watch` and `view`:

    watch: nanoc watch
    view: nanoc view -H thin

`nanoc watch` watches for changes and `nanoc view -H thin` previews the site using thin (rather than WEBrick, which it would use by default). We suggest you install [Growl](http://growl.info/) or [rb-inotify](https://github.com/nex3/rb-inotify) so you can receive notifications when the site is done compiling.

Your basic workflow might look like this:

1. run `foreman start`
1. open [http://localhost:3000](http://localhost:3000)
1. make changes in the project files (and save them)
1. wait for the notification that the compilation is complete
1. refresh the browser to see the changes
1. go to 3.

If you refresh the browser before the compilation is complete, nothing bad will happen, you just won't see the change until the compilation finishes (and you refresh again).

If this doesn't work for you, you could try nanoc's `aco` (or `autocompile`) command:

    $ nanoc aco -H thin

It compiles and previews the site in the browser (also at [http://localhost:3000](http://localhost:3000)), then recompiles it on each request. The difference from the previous approach is that the site is recompiled each time a page is requested, not when a file is changed. This approach is usually more sluggish.

It is recommended that you read the 5 minute [tutorial](http://nanoc.stoneship.org/tutorial/) on nanoc.

### 5. Commit your changes to your fork

When you're happy with the changes you made and you're ready to submit them, use `git add` to stage the changes, then commit them with:

    $ git commit

When you're ready to push your changes to your Compass fork on GitHub, run:

    $ git push -u origin <branch>

depending on which branch you want to push. Your changes are now reflected on your github repo. Go to Github and click the "Pull Request" button on top of your repo to notify Chris of changes. He will verify them and merge them into the master.

#### How to pull in new changes

Add the original Compass repository to your Git remotes:

    $ git remote add chris git://github.com/chriseppstein/compass.git

Then get the new changes with fetch:

    $ git fetch chris

And merge them with your local docs branch:

    $ git merge chris

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
      <td><strong>content/tutorials/</strong></td>
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

(Again, make sure you're in the `doc-src` directory.)

Running the following command will generate a new example:

    $ bundle exec thor generate:example blueprint/grid/simple/

An example consists of three files:

1. The Example Container → The default generated container uses a shared partial for the container, but doesn't have to.
2. Some Markup → The `markup.haml` file is located within a directory of the same name as container. This Haml gets converted to HTML and then displayed to the user as well as included into the page for styling.
3. Some Sass → The `stylesheet.sass` file is located within a directory of the same name as container. This Sass gets displayed to the user. Also, the sass will be compiled and the CSS will be used to style the example as well as displayed to the user.

Example metadata (YAML front matter) is used to associate the example to a mixin in the reference documentation:

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

    $ bundle exec thor generate:reference ../frameworks/compass/stylesheets/_compass.sass

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
