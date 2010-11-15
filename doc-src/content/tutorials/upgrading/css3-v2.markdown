The `css3` import is deprecated as well as the following css3 modules:
`box-shadow`, `text-shadow`, and `transform`. Instead import `css3/version-2`,
`box-shadow-v2`, `text-shadow-v2`, and `transform-v2` respectively.
However, you will only get deprecation warnings if you actually use
one of the deprecated mixins. The imports will be restored by 1.0
with the new, betterer APIs.

You should read about what changed, update your stylesheets accordingly
and then update your imports to the new version.

