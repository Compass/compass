---
title: Removing Vendor Prefixes from Compass Stylesheets
layout: tutorial
crumb: Removing Vendor Prefixes from Compass
classnames:
  - tutorial
---
# Removing Vendor Prefixes from Compass Stylesheets

Compass makes it easy to code many of the CSS3 vendor prefixed properties, without having to type it all out by hand.

## Easy Vendor Prefixes

Let's say you wanted to add a border radius to an element like this:

    .round {
        -moz-border-radius: 4px;
        -webkit-border-radius: 4px;
        border-radius: 4px;
    }

With Compass it's easier to use the `border-radius` mixin:

    .round {
        @include border-radius(4px);
    }

That mixin will create all of the vendor prefixed CSS properties you need, with much less of a chance of a typo or inconsistent display. It will also take care of any browser specific implementations of the CSS property that don't match up to the W3C specification.
    
    .round {
        -moz-border-radius: 4px;
        -webkit-border-radius: 4px;
        -o-border-radius: 4px;
        -ms-border-radius: 4px;
        -khtml-border-radius: 4px;
        border-radius: 4px;
    }

## Problem

The problem with that solution, as good as it is, is that all of those browser prefixes will cruft up your stylesheet quickly if you use a lot of them, and/or aren't using `@extend` to keep them to a minimum. 

Of particular note are the generated Opera `(-o-border-radius)` and Konquerer `(-khtml-border-radius)` properties, which are added to create support for those browsers. As great as those browsers may be, they often account for a very small minority of a website's traffic, traffic that may not compensate for the full weight of their support when using experimental CSS3 properties.

## Solution

Thankfully, Compass includes a selection of default boolean variables that you can override, allowing you to globally turn off the support for the various vendor prefixes:

    $experimental-support-for-mozilla : true !default;
    $experimental-support-for-webkit : true !default;
    $support-for-original-webkit-gradients : true !default;
    $experimental-support-for-opera : true !default;
    $experimental-support-for-microsoft : true !default;
    $experimental-support-for-khtml : true !default;

If you set any of the above variables to `false`, Compass will skip those prefixes when it processes your stylesheet.

So to exclude Opera and Konquerer vendor prefixes from your CSS, add the following code just above your include of the CSS3 module in your base SCSS file:
    
    $experimental-support-for-opera:false;
    $experimental-support-for-khtml:false;
    @import "compass/css3";

The resultant output will be as follow:

    .round {
        -moz-border-radius: 4px;
        -webkit-border-radius: 4px;
        -ms-border-radius: 4px;
        border-radius: 4px;
    }
