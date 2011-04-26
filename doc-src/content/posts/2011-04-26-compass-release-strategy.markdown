---
title: "Compass Release Strategy"
description: "An overview of how Compass will be managing ongoing releases."
author: chris
---

Most of this is probably obvious, but it doesn't hurt to be explicit about such things.

If you're interested in contributing to Compass, please read the
[Contribution Guide](http://compass-style.org/help/tutorials/contributing/).

Versioning
----------

Most stable releases will be released as release candidates first
(e.g `0.11.1.rc.0`) and then made into official releases after a day
or so if they don't cause any problems.

Sass Dependency
---------------

We will decouple major Compass releases from the Sass release schedule
going forward. When Sass releases happen, we will issue patches to both
stable and master branches to adjust to any deprecations and new
features after they are fully released (which means we might have the
changes waiting in a topic branch). Because Sass is very careful to not
break existing stylesheets without deprecating first, this shouldn't be
hard to pull off.

Stylesheet Progress
-------------------

I do not want to see the compass stylesheets get frozen again 
like they did in v0.10 while waiting for the next major release.
Compass users expect us to keep up with browser developments and we will.
If this means that we need to make v0.12 become v0.13 because
the stylesheets need to make some major change, then we will do that.

Communicating Change
--------------------

All new features should have tests, docs, and CHANGELOG entries
as appropriate as part of the commit.

Additionally, we now have a compass team blog that we can use to communicate
about new features, best practices, or other Compass related stuff.
It's easy to add a post, you just drop a markdown file into
[this directory](https://github.com/chriseppstein/compass/tree/stable/doc-src/content/posts).
Guest posts are totally welcome via pull requests.

Stable
------

The stable release is were code lives for the next v0.11 point release.
Commits should only go here if they are ready for release, until that
point the code should live in your compass fork or in a topic branch.

Core team members, please use pull requests to manage the code review
process for any change of significance and get sign-off from one other
team member before committing to stable.

Changes that can go on stable:

* Browser support updates
* Non-breaking stylesheet changes and minor features
  like new mixins or modules.
* Bug fixes

Changes that can't go on stable:

* New deprecations
* Major features
* Big refactors

If you're not sure where to put something, just ask.

Rails 3.1 support is the exception to this rule, given the timeline
assocated with that release, I will make a topic branch and we'll
merge that to stable when it's ready.

Core team members will, after committing/merging code to stable, then merge those changes to master so it is up to date.

Master
------

Master is where code goes to be ready for v0.12. This focus of this
next release is making extensions easy to make, share, discover, install,
remove, and use. Any and all ideas that you have related to this are
welcome. At a minimum, I would like to have an extension directory
app hosted on compass-style.org and make sure that compass knows about
it and can install extensions by name from there.


