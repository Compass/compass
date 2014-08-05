---
title: "Compass Versioning Change"
description: "Compass follows semantic versioning now. Chris shakes off
his fear of releasing imperfect software."
author: chris
---

When I created compass I imagined a particular set of features Compass
would have when it was done with the initial build out. I assigned that
release a number of 1.0 and expected it would only take a few releases to
get there.

But then there was users and their needs and the features they wanted.
And so there have been 77 releases at the time that I'm writing this
post. And you know what? I don't know when, or if, compass will ever
achieve the mythical feature set I imagined.

Furthermore, it's been way too long since the last stable release.
There was a hiatus, and then there was a mountain of bugs and feature
requests that built up that I desperately wanted to get into the next
release. And instead of just releasing incrementally better software
every few weeks, I've been making a bigger and bigger release that is
harder and harder to release.

And so I've fallen into the trap that so many software developers fall
into. I'm working hard every day and I'm not shipping because it's not
done. But we all know, software is never done (unless you are Donald
Knuth).

And so I've decided to make a few changes. Sass 3.3 is ready for release
and I want to get it out. Compass has to be released with it and there's
no way I will get everything bug fix and new feature I need to get done.
But what Compass development has right right now, is really a huge
improvement. It's time to ship, even though it's not done and get this
train moving. So here's what I'm doing to address these issues:

### 1.0.0 is the next release

The next release will be version 1.0.0. This number doesn't mean
anything. It's just an acknowledgement that compass is a mature project
that has tens of thousands of users and that it is not in any way "not
done".

### Semantic Versioning

Semantic versioning is a [standard versioning scheme](http://semver.org/)
with standard expectations about what a change to a version means. From
the site:

> Given a version number MAJOR.MINOR.PATCH, increment the:
> 
> MAJOR version when you make incompatible API changes,<br>
> MINOR version when you add functionality in a backwards-compatible manner, and<br>
> PATCH version when you make backwards-compatible bug fixes.
>
> Additional labels for pre-release and build metadata are available as
> extensions to the MAJOR.MINOR.PATCH format.

<br>
<br>
Compass releases will follow semantic versioning going forward.

### Compass Core

The core stylesheets and configuration of Compass have been extracted to
their own gem named `compass-core`. This gem allows projects that don't
need Compass's command line tools, extension management, and compilation
services, to work very simply using pure sass for much of configurable
bits of compass. The compass core framework will have it's own version
and will be released on it's own release train. If you don't care about
this, don't worrry; `gem install compass` still works exactly like it
used to.

### Regular Releases

Once Compass 1.0.0 is released. There are a ton of bug fixes and new
features we'll be releasing. Instead of waiting until there's a critical
mass, we'll just release whenever new features land and ship
non-critical bug fixes every two weeks.

### Gem Version Dependencies

If you are the owner of a compass extension that declares a version
dependency on compass, you need to update your gemspec to allow compass
1.0.0. Hit me up on [twitter](http://twitter.com/chriseppstein) if
you're not sure how to do this.

### Install it now, help QA!

There's a 1.0.0 preview release available right now (1.0.0.alpha.13)

`gem install compass --pre` to get it.

If you find a bug, please make sure to mention 1.0 in the description.
