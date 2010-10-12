Contributing to Compass
=======================

Thank you for your interest in contributing to Compass. Our goal is to make it as easy
as we can for you to contribute changes to compass -- So if there's something here that
seems harder than it aught to be, please let us know.

Step 1: If you do not have a github account, create one.
Step 2: Fork Compass to your account.

Now we're at a decision point. What kind of change do you intend to make?

* [Fix a typo (or some other trivial change)](#trivial-changes)
* [Documentation Changes](#documentation-changes)
* [Stylesheet Changes](#stylesheet-changes)
* [Ruby Changes](#ruby-changes)

Here's some general information about the project you might find useful along the way:

* [Submitting Patches](#patches)
* [Project Structure](#project-structure)
* [Project Architecture](#project-architecture)
  * [Command Line](#cli-architecture)
  * [Extensions](#extensions-architecture)
  * [Configuration](#configuration-architecture)
* [General Philosophy](#project-philosophy)
* [Stylesheet Conventions](#api-conventions)
* [In Case of Emergency](#faq)

<h2 id="trivial-changes">Making Trivial Changes</h2>

Thanks to Github, making small changes is super easy. After forking the project navigate
to the file you want to change and click the edit link. Change the file, write a commit
message, and click the `Commit` button. Now you need to get your change [accepted](#patches).

<h2 id="documentation-changes">Making Documentation Changes</h2>

The compass documentation is stored in two places. First, the doc-src directory is
where the documentation lives -- however much of the documentation is generated
from comments in the Sass files themselves. More information on [changing
documentation][documentation]. Once your changes are pushed, you can
[submit them](#patches).

<h2 id="stylesheet-changes">Making Stylesheet Changes</h2>

TODO

<h2 id="ruby-changes">Making Ruby Changes</h2>

TODO

<h2 id="patches">Submitting Patches</h2>

It is a good idea to discuss new features ideas with the compass users and developers
before building something. Please don't by shy; send an email to the [compass mailing
list](http://groups.google.com/group/compass-users).

If you are submitting features that have more than one changeset, please create a topic
branch to hold the changes while they are pending merge and also to track iterations to
the original submission. To create a topic branch:

    $ git checkout -b new_branch_name
    ... make more commits if needed ...
    $ git push origin new_branch_name

You can now see these changes online at a url like:

    http://github.com/your_user_name/compass/commits/new_branch_name

If you have single-commit patches, it is fine to keep them on master. But do keep in
mind that these changesets might be
[cherry-picked](#recovering-from-rebased-or-cherry-picked-changesets).

Once your changeset(s) are on github, select the appropriate branch containing your
changes and send a pull request. Most of the description of your changes should be
in the commit messages -- so no need to write a whole lot in the pull request message.
However, the pull request message is a good place to provide a rationale or use case
for the change if you think one is needed. More info on [pull requests][pulls].

Pull requests are then managed like an issue from the [compass issues page][issues].
A code review will be performed by a compass core team member, and one of three outcomes
will result:

1. The change is rejected -- Not all changes are right for [compass's
   philosophy](#project-philosophy). If your change is rejected it might be better
   suited for a plugin, at least until it matures and/or proves itself with the users.
2. The change is rejected, unless -- Sometimes, there are missing pieces, or
   other changes that need to be made before the change can be accepted. Comments
   will be left on the commits indicating what issues need to be addressed.
3. The change is accepted -- The change is merged into compass, sometimes minor
   changes are then applied by the committer after the merge.

<h2 id="project-structure">Project Structure</h2>

TODO

<h2 id="project-architecture">Project Architecture</h2>

TODO

<h3 id="cli-architecture">Command Line</h3>

TODO

<h3 id="extensions-architecture">Extensions</h3>

TODO

<h3 id="configuration-architecture">Configuration</h3>

TODO

<h2 id="project-philosophy">General Philosophy</h2>

TODO

<h2 id="api-conventions">Stylesheet Conventions</h2>

TODO

<h2 id="faq">Common Problems/Misc</h2>

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