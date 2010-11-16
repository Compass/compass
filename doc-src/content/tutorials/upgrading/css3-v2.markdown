---
title: CSS3 v2 Upgrade
layout: tutorial
crumb: CSS3 v2 Upgrade
classnames:
  - tutorial
---
# Upgrading to Compass CSS3 v2
The `css3` import is deprecated as well as the following css3 modules:
`box-shadow`, `text-shadow`, and `transform`. Instead import `css3/version-2`,
`box-shadow-v2`, `text-shadow-v2`, and `transform-v2` respectively.
However, you will only get deprecation warnings if you actually use
one of the deprecated mixins. The imports will be restored by 1.0
with the new, betterer APIs.

You should read about what changed, update your stylesheets accordingly
and then update your imports to the new version.

<a name="box-shadow"></a>
## Box Shadow
The arguments to the [`box-shadow`][new_box_shadow] mixin have changed.
As a result you should change your import of `compass/css3/box-shadow`
to `compass/css3/box-shadow-v2` once you do one of the following choices:

1. Change your use of the `box-shadow` and instead use `single-box-shadow`.
   This mixin has the same behavior and arguments as the old `box-shadow` mixin.
2. Keep using `box-shadow`, change how you pass the arguments. The new
   `box-shadow` takes up to 10 comma-delimited shadows. Each shadow is
   how the values should appear in the CSS (space separated).

## Text Shadow

Similarly to how the box shadow changed. The new [text-shadow][new_text_shadow]
mixin now accepts multiple shadows. As a result you should change your import of
`compass/css3/text-shadow` to `compass/css3/text-shadow-v2` once you do one of
the following choices:

1. Change your use of the `text-shadow` and instead use `single-text-shadow`.
   This mixin has the same behavior and arguments as the old `text-shadow` mixin.
2. Keep using `text-shadow`, change how you pass the arguments. The new
   `text-shadow` takes up to 10 comma-delimited shadows. Each shadow is
   how the values should appear in the CSS (space separated).

## CSS Transforms
The transform module was largely re-written to support 3D transforms. If you
are using it, it is suggested that you read the [new module's documentation][new_transform]
and adjust your code appropriately. Many mixin names and constants have changed.

[old_box_shadow]: /docs/reference/compass/css3/box_shadow/#mixin-box-shadow
[new_box_shadow]: /docs/reference/compass/css3/box_shadow_v2/#mixin-box-shadow
[old_text_shadow]: /docs/reference/compass/css3/text_shadow/#mixin-text-shadow
[new_text_shadow]: /docs/reference/compass/css3/text-shadow-v2/#mixin-text-shadow
[new_transform]: /docs/reference/compass/css3/transform-v2/