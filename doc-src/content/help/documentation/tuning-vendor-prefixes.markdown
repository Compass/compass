---
title: Tuning Vendor Prefix Support
layout: documentation
classnames:
  - documentation
---

# Tuning Vendor Prefixes from Compass Stylesheets

Underneath the covers of Compass's vendor prefixing and legacy
browser support is the very same data that drives the website
[caniuse.com](http://caniuse.com).

This data allows Compass to correlate browser support with browser usage
statistics and browser versions for you. By telling Compass the user
thresholds where you're comfortable letting a user's experience degrade
gracefully or break Compass will automatically add or remove vendor
prefixes for particular features according to the browser statistics
corresponding to them.

## Allowing Graceful Degradation in Legacy Browsers

CSS features that can degrade gracefully (E.g. `border-radius`) are set
by default to adhere to the `$graceful-usage-threshold` variable. This
variable defaults to `0.1` which means that when 0.1% of users (1 in
1,000) would be affected by removing the prefix for that feature, it
will be removed.

## Allowing Broken Design in Legacy Browsers

CSS features that do not degrade gracefully (E.g. `flexbox`) are set by
default to adhere to the `$critical-usage-threshold` variable. This
variable defaults to `0.01` which means that when 0.01% of users (1 in
10,000) would be affected by removing the prefix for that feature, it
will be removed.

## Ensuring a Browser Version Is Supported

Sometimes you may wish to fully support a browser version no matter how
few people are using it. Maybe the CEO uses it and it has to look
perfect. In this case you can set the minimum browser version for each
known browser with the `$browser-minimum-versions` map. For instance, if
you need to support IE 6, you would set `$browser-minimum-versions` to
`(ie: '6')`. Please note that since not all browser versions that
Compass tracks are numbers, every version specified must be a string.

## Excluding a Browser no Matter How Many Users it Has

The `$supported-browsers` variable defines which browsers your site
supports. By default, all browsers are supported. You can use this
setting to whitelist only certain browsers, or you can blacklist
specific browsers by rejecting them from the full list. Example:
`$supported-browsers: reject(browsers(), opera-mini, android)`

## Discovering Browsers and Versions

The list of browsers and versions that are known to compass is guided by
the underlying data. You can inspect these values in the console:

    $ compass interactive
    >> browsers()
    ("android", "android-chrome", "android-firefox", "blackberry", "chrome", "firefox", "ie", "ie-mobile", "ios-safari", "opera", "opera-mini", "opera-mobile", "safari")
    >> browser-versions(ie)
    ("5.5", "6", "7", "8", "9", "10", "11")

## Tweaking Support on a Per-Feature Basis

Each CSS3 module provides feature-specific threshold variables. These
default to either `$graceful-usage-threshold` or
`$critical-usage-threshold`, which should be good enough, but if it's
not, you can adjust the support for just the features that matter to
you. For example, the border radius module has a configuration variable
`$border-radius-threshold` which defaults to
`$graceful-usage-threshold`. But if rounded corners are essential to
your design, you may want to set it to something lower.

## Prefix Context

There are two variables relating to prefix context.

`$prefix-context` will be set to a prefix whenever a prefix is in scope.

`$current-prefix` is set the prefix that is currently being emitted. This
is different from `$prefix-context` in that sometimes it is null when
rendering official syntax within the scope of some other prefix.

All Compass mixins are aware of the prefix context and you can use them
freely and get the output you expect. You can also check the context
yourself if you feel it is necessary.  For example, the keyframes mixin
accepts a content block which is repeated several times:

    @import "compass/css3";
    @include keyframes(my-animation) {
      0% {
        @if $prefix-context == -moz {
          // Do something mozilla specific in your animation.
        }
        @include border-radius(5px); // only outputs the -moz prefix an
      }
    }

However, Compass comes with a handy mixin for targeting content to a
specific prefix context: `with-browser-prefix`. This mixin can be used
to establish a context or prevent content from being placed into a
context where it doesn't belong. For example, we could have written the
example above as:

    @import "compass/css3";
    @include keyframes(my-animation) {
      0% {
        @include with-prefix(-moz) {
          // Do something mozilla specific in your animation.
        }
        @include border-radius(5px); // only outputs the -moz prefix an
      }
    }

Similarly, you can constrain compass output to a particular prefix. The
example below would only generate the mozilla and official keyframes
directives and prefixed properties.

    @import "compass/css3";
    @include with-prefix(-moz) {
      @include keyframes(my-animation) {
        0% {
          @include border-radius(5px); // only outputs the -moz prefix an
        }
      }
    }

## Targeting Legacy Browsers

When a generic mixin has support for a legacy browser, the legacy
specific styles should be wrapped in a `for-legacy-browser` mixin.
In this way, the legacy content will only appear when not in an
incompatible context and will be automaticaly removed when the usage
of that browser range falls below acceptable thresholds.

## Browser Context

If you are in a selector or scope that you know is specific to a
particular browser version, you can let compass know this with the
`with-browser-ranges` mixins.

## Debugging Browser Support

If you find yourself in a situation where you see a browser prefix you
didn't expect or don't see one that you did, it may be helpful to turn
on browser support debugging by setting `$debug-browser-support` to `true`.

This will cause CSS comments to be generated into your output that explains
why support for certain browsers was included or excluded.

You can also use the `with-browser-support-debugging` mixin that will
enable browser support debugging for all compass mixins uses within its
content block.

The output will look like this:

    /* Capability css-animation is prefixed with -moz because 1.03559% of users need it which is more than the threshold of 0.1%. */
    /* Creating new -moz context. */
    @-moz-keyframes foo {
      0% {
        /* Content for ie 8 omitted.
           Not allowed in the current scope: ie 8 is incompatible with -moz. */
        opacity: 0; }
    
      100% {
        /* Content for ie 8 omitted.
           Not allowed in the current scope: ie 8 is incompatible with -moz. */
        opacity: 1; } }
    /* Capability css-animation is not prefixed with -ms because 0% of users are affected which is less than the threshold of 0.1. */
    /* Capability css-animation is not prefixed with -o because 0.04931% of users are affected which is less than the threshold of 0.1. */
    /* Capability css-animation is prefixed with -webkit because 51.42143% of users need it which is more than the threshold of 0.1%. */
    /* Creating new -webkit context. */
    @-webkit-keyframes foo {
      0% {
        /* Content for ie 8 omitted.
           Not allowed in the current scope: ie 8 is incompatible with -webkit. */
        opacity: 0; }
    
      100% {
        /* Content for ie 8 omitted.
           Not allowed in the current scope: ie 8 is incompatible with -webkit. */
        opacity: 1; } }
    @keyframes foo {
      0% {
        /* Content for ie 8 omitted.
           Not allowed in the current scope: The current scope only works with ie 10 - 11. */
        opacity: 0; }
    
      100% {
        /* Content for ie 8 omitted.
           Not allowed in the current scope: The current scope only works with ie 10 - 11. */
        opacity: 1; } }
    


## More Information

There are many useful mixins and functions in
[the code reference for browser support in compass](/reference/compass/support/).
