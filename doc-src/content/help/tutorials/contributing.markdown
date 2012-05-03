---
title: Contributing Stylesheets
crumb: Contributing
layout: tutorial
classnames:
  - tutorial
---
Contributing Stylesheets to Compass
===================================

Thank you for your interest in contributing to Compass. Our goal is to make it as easy
as we can for you to contribute changes to compass -- So if there's something here that
seems harder than it ought to be, please let us know.

If you find a bug **in this document**, you are bound to contribute a fix. Stop reading now
if you do not wish to abide by this rule.

**Step 1**: If you do not have a github account, create one.

**Step 2**: Fork Compass to your account. Go to the [main repo](http://github.com/chriseppstein/compass)
and click the fork button.

![Fork Me](http://img.skitch.com/20101015-n4ssnfyj16e555cnn7wp2pg717.png)

Now we're at a decision point. What kind of change do you intend to make?

* [Fix a typo (or some other trivial change)](#trivial-changes)
* [Documentation Changes](#documentation-changes)
* [Fixing Stylesheet Bugs](#stylesheet-bugs)
* [New Stylesheet Features](#stylesheet-changes)
* [Ruby Changes](#ruby-changes)

Here's some general information about the project you might find useful along the way:

* [Submitting Patches](#patches)
* [Project Structure](#project-structure)
<!-- * Project Architecture
  * [Command Line](/help/tutorials/command-line)
  * [Extensions](/help/tutorials/extensions)
  * [Configuration](help/tutorials/configuration-reference) -->
* [General Philosophy](#project-philosophy)
* [Stylesheet Conventions](#stylesheet-conventions)
* [Miscellaneous Stuff](#faq)
  * [Setting up Git](#setting-up-git)
  * [Using Compass while Under Development](#running-local-code)
  * [Running Tests](#running-tests)
  * [Recovering from a cherry-pick or a rebase](#recovering-from-rebased-or-cherry-picked-changesets)

<h2 id="trivial-changes">Making Trivial Changes</h2>

Thanks to Github, making small changes is super easy. After forking the project navigate
to the file you want to change and click the edit link.

![Edit Me](http://img.skitch.com/20101015-n2x2iaric7wkey2x7u4fa2m1hj.png)

Change the file, write a commit message, and click the `Commit` button.

![Commit Me](http://img.skitch.com/20101015-br74tfwtd1ur428mq4ejt12kfc.png)
Now you need to get your change [accepted](#patches).


<h2 id="documentation-changes">Making Documentation Changes</h2>

The compass documentation is stored in two places. First, the `doc-src` directory is
where the documentation lives -- however much of the documentation is generated
from comments in the Sass files themselves. More information on [changing
documentation][documentation]. Once your changes are pushed, please
[submit them](#patches).

<h2 id="stylesheet-bugs">Fixing Stylesheet Bugs</h2>

**Step 3**: If this is a bug you discovered. Please [report it][issues] before working on a fix.
This helps us better understand the patch.

**Step 4**: Get [the code](#setting-up-git) if you haven't yet done so.

**Step 5**: Fix the bug and commit the changes. Please make sure to mention the bug
id in your commit message like so:

    Fixed the display of the fizzlebuzz in IE6.

    Closes GH-123.

**Step 6**: Verify the fix in as many browsers as you can as well as against your own
project. How to [use compass while changing it](#running-local-code).

**Step 7**: Make sure the tests pass. More info on [running tests](#running-tests)
If the tests fail, fix the tests or the stylesheets accordingly. If the tests, don't
fail, that means this aspect was not well enough tested. Please [add or augment
a test](#writing-tests).

You're done. Please [submit your changes](#patches).

<h2 id="stylesheet-changes">Making Stylesheet Changes</h2>

It is a good idea to discuss new features ideas with the compass users and developers
before building something. Please don't be shy; send an email to the [compass mailing
list](http://groups.google.com/group/compass-users).

Many feature ideas are good but not obviously a good fit for the compass core library.
In these cases, you can and should create a [compass extension][extensions]. Sometimes
this is because the concept does not align with the [compass philosophy](#project-philosophy).
But sometimes it's just because we think the idea needs time to bake. [Documentation on
making extensions.][extensions]

**Step 3**: Get [the code](#setting-up-git) if you haven't yet done so.

**Step 4**: Add the feature -- contact the mailing list if you have any questions.

**Step 5**: Add a test case. More info on [writing tests for compass](#writing-tests).

**Step 6**: Documentation - Add or update the reference documentation. Add
an example of using the feature. See the [doc readme for details][documentation].

You're done. Please [submit your changes](#patches).

<h2 id="ruby-changes">Making Ruby Changes</h2>

At this time, if you're a rubyist who's planning on working on the ruby-side of
things, it's assumed you know how to read code and use standard ruby tools like
rake, gem, bundler, test/unit, cucumber, rspec, etc. If you have any questions,
please ask. No changes will be accepted without accompanying tests.

<h2 id="patches">Submitting Patches</h2>

If you are submitting features that have more than one changeset, please create a
topic branch to hold the changes while they are pending merge and also to track
iterations to the original submission. To create a topic branch:

    $ git checkout -b new_branch_name
    ... make more commits if needed ...
    $ git push origin new_branch_name

You can now see these changes online at a url like:

    http://github.com/your_user_name/compass/commits/new_branch_name

If you have single-commit patches, it is fine to keep them on master. But do keep in
mind that these changesets might be
[cherry-picked](#recovering-from-rebased-or-cherry-picked-changesets).

Once your changeset(s) are on github, select the appropriate branch containing your
changes and send a pull request. Make sure to choose the same upstream branch that
you developed against (probably stable or master). Most of the description of your
changes should be in the commit messages -- so no need to write a whole lot in the
pull request message. However, the pull request message is a good place to provide a
rationale or use case for the change if you think one is needed. More info on [pull
requests][pulls].

![Pull Request Example](http://img.skitch.com/20101015-rgfh43yhk7e61fchj9wccne9cq.png)

Pull requests are then managed like an issue from the [compass issues page][issues].
A code review will be performed by a compass core team member, and one of three outcomes
will result:

1. The change is rejected -- Not all changes are right for [compass's
   philosophy](#project-philosophy). If your change is rejected it might be better
   suited for a plugin, at least until it matures and/or proves itself with the users.
2. The change is rejected, *unless* -- Sometimes, there are missing pieces, or
   other changes that need to be made before the change can be accepted. Comments
   will be left on the commits indicating what issues need to be addressed.
3. The change is accepted -- The change is merged into compass, sometimes minor
   changes are then applied by the committer after the merge.

<h2 id="project-structure">Project Structure</h2>

    compass/
      bin/
        compass             - CLI executable
      devbin/               - development scripts after installing the bundle
      doc-src/              - source for documentation
      docs/                 - generated documentation
      examples/             - fully working compass projects that you can explore
      features/             - tests for compass
      frameworks/           - All frameworks in this directory are loaded automatically
        compass/            - The compass framework
          stylesheets/      - The compass libraries
          templates/        - The compass project templates and patterns
        blueprint/
          stylesheets/      - The blueprint libraries
          templates/        - The blueprint project templates and patterns
      lib/
        compass.rb          - The main compass ruby library
        compass/
          app_integration/  - integration with app frameworks
          commands/         - UI agnostic support for the CLI
          configuration/    - support for project configuration
          exec/             - UI code for the CLI
          installers/       - support for installing templates
          sass_extensions/  - enhancements to Sass
            functions/      - Sass functions exposed by compass
            monkey_patches/ - Changes to sass itself
      test/                 - unit tests

<h2 id="project-philosophy">General Philosophy</h2>

1. Users specify their own selectors. Compass never forces a user
   to use a presentational class name.
2. Compass does not require javascript. It is a CSS framework.
3. Compass core is "design agnostic". This is why compass core has no
   grid framework -- grids are not design agnostic.
4. Compass frameworks are not special. If compass can do it, so should an extension
   be able.
5. Sass is awesome -- Compass should make sass more accessible and
   demonstrate how to use Sass to its fullest potential.
6. Developing across browsers is hard and will always be hard. It takes
   a community to get it right.
7. By default, Compass supports as many browsers as it can. Where it can't
   it progressively enhances. Where it degrades, the documentation should
   make a note. Deviation from this requires an excellent reason.
8. Compass is a proving ground for Sass features. The watcher and color
   functions are examples of features that started in Compass and got
   moved to Sass.

<h2 id="stylesheet-conventions">Stylesheet Conventions</h2>

1. All framework stylesheets are partials. Their filename begin with an underscore.
   Otherwise, Sass will create stylesheets directly into the user's CSS directory.
2. Compass imports do not emit styles. There are a few limited exceptions to this like
   the resets and base classes for inheritance.
3. Mixins with two-level defaults. Mixins often provide two levels of default
   values. The first is a global default that can be overridden once. The second
   is a default that can be overridden when the mixin is included.
4. Mixin argument names are part of the public API, make sure they are understandable and not
   needlessly truncated or terse.
5. If adding a new folder of stylesheets, add a single stylesheet with the same name that
   imports all of the stylesheets in the folder.
6. Try to avoid passing selectors as arguments. This is what mixins are for.


<h2 id="faq">Common Problems &amp; Miscellaneous Info</h2>

<h3 id="setting-up-git">Setting up Git</h3>

Please follow [these instructions](http://help.github.com/git-email-settings/)
to set up your email address and attribution information.

Download your git repo:

    git clone git@github.com:your_username/compass.git

Set up a remote to the main repo:

    cd compass
    git remote add chriseppstein git://github.com/chriseppstein/compass.git

Getting recent changes from the main repo:

    git fetch chriseppstein

<h3 id="running-local-code">Using Compass while Under Development</h3>

1. Use the bin script. `/path/to/compass/bin/compass` is a version of the compass
   command line that uses the local changes you have made. You can add `/path/to/compass/bin`
   to your `$PATH`, or refer to it directly.
2. Build and install a gem:
   1. Edit VERSION.yml and add a build indicator like so (**Do not commit this change**):

          ---
          :major: 0
          :minor: 10
          :patch: 6
          :build: something-uniq-to-me.1
   2. `gem build compass.gemspec`
   3. `gem install compass-0.10.6.something-uniq-to-me.1.gem` -- If installing to your
      system gems, you'll probably need to add `sudo` to the front. If you don't know
      what that means, you probably need to add `sudo` to the front.
3. In a [bundled][bundler] environment, you can configure your gem to use compass
   while you work on it like so:

       gem 'compass', :path => "/Users/myusername/some/path/to/compass"

   Bundler will perform some sort of charm on ruby to make it work.
4. Configuring ruby directly. If you're a ruby pro, you probably don't need to be
   told that you can set compass on the load path like so:

       export RUBYLIB=/Users/myusername/some/path/to/compass/lib

<h3 id="running-tests">Running Tests</h3>

1. You must have Ruby installed on your system. After [setting up git](#setting-up-git),
   change to the root directory of your git checkout of Compass.

       cd compass

2. Install the bundler Ruby gem.

       gem install bundler

   If installing to your system gems, you'll probably need to add `sudo` to the
   front of that command. If you don't know what that means, you probably need
   to add `sudo` to the front.

3. Install development dependencies:

       bundle install --binstubs devbin

4. Running core library and stylesheet tests:

       bundle exec rake test features

5. Running behavior tests

       ./devbin/cucumber

If stylesheet tests fail, the output of the test project is captured in
`test/fixtures/stylesheets/<project>/saved/` and the error message will report where
the error was. Here's an example:

![Stylesheet Test Failure](http://img.skitch.com/20101015-k4t11k8n7xs2r53ftjhrji629d.png)

<h3 id="writing-tests">Writing Stylesheet Tests</h3>

Compass has stylesheet tests to ensure that each stylesheet compiles, can be imported directly
without any other dependencies and that refactorings that should not affect the output, don't.

At some point, it would be great to have a test system that verifies that the stylesheets
*work correctly* in various browsers. If you have ideas for how to accomplish this in a sane
way, please let us know.

In the `test/fixtures/stylesheets` directory, there are a number of compass projects.
The tests work by adding or updating the sass files, running the tests to make sure they fail,
and then changing the expected css output to make the test pass. It is rudimentary, but as
a safety net, it has caught a number of problems that might have been missed otherwise.
If you add a new stylesheet to compass, please make sure to add a new test stylesheet
that only imports the newly added stylesheet and add rules that use the new features in that
stylesheet.

<h3 id="recovering-from-rebased-or-cherry-picked-changesets">You cherry-picked/rebased
my changes. What should I do?</h3>
Depending on any number of reasons, including but not limited to the alignment of the stars,
Your changes might not be merged into compass using a simple merge. For instance, we might
decide to place a change against master into stable instead, or we might squish all your
changes together into a single commit at the time of merge, or we might want a change you've
submitted but not a change that it was placed onto top of. In these cases, there are
a couple of ways you can react:

1. If you have some changes on a branch that were not yet accepted, but other changes on that
   branch were accepted then you should run the following command (make sure to fetch first):
   `git checkout branch_name; git rebase chriseppstein/master` (assuming the change was applied
   to the master branch)
2. If all your changes on the topic branch were accepted or you don't care to keep it around
   anymore: `git checkout master; git branch -D branch_name; git push origin :branch_name`

[pulls]: http://help.github.com/pull-requests/
[issues]: http://github.com/chriseppstein/compass/issues
[documentation]: http://github.com/chriseppstein/compass/blob/stable/doc-src/README.markdown
[bundler]: http://gembundler.com/
[extensions]: /help/tutorials/extensions/
