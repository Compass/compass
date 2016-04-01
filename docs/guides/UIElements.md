
# UI Elements

<p class="h3">
  Basscss can be used to create many different user interface elements out of the box.
  With utility styles and a thoughtfully-architected templating system,
  you can keep CSS bloat to a minimum, while making iterative design changes to partials and components.
  You don’t need to make CSS do your templating engine’s job.
</p>

Note: this guide makes use of the optional
<a href="//npmjs.com/package/basscss-ui-utility-groups" target="_blank">UI Utility Groups</a>
module that is not included in the default Basscss package.


# Button Sizes
Button font sizes can be adjusted with font size utilities.

```html
<button type="button" class="h3 btn btn-primary">Burgers</button>
<button type="button" class="h4 btn btn-primary">Fries</button>
<button type="button" class="h6 btn btn-primary">Shakes</button>
```

To change the line-height and padding but leave the font-size the same,
use button size extensions in the optional basscss-button-sizes module.
Font size utilities and button size extensions can be combined for more options.

```html
<button type="button" class="btn button-big">Burgers</button>
<button type="button" class="btn">Fries</button>
<div class="mb1 md-hide"></div>
<button type="button" class="btn button-narrow">Onion Rings</button>
<button type="button" class="btn button-small">Shakes</button>
```


# Navigation

In HTML, navigation is essentially just groups of links.
By using the same styles as buttons,
you can ensure that navigation links are evenly spaced and have large, easy-to-hit targets.
Negative margin utilities can help line up text elements with other elements on the page.
The `.btn` style can be used for navigation items.
This button style inherits color from its parent, or it can be set with color utilities.

```html
<div class="mxn1">
  <a href="#!" class="btn button-narrow">Burgers</a>
  <a href="#!" class="btn button-narrow">Fries</a>
  <a href="#!" class="btn button-narrow">Shakes</a>
  <a href="#!" class="btn button-narrow">Onion Rings</a>
</div>
```

The flex object can be used to create justified navigation.
Be sure to test your specific navigation across a range of devices to ensure that
labels fit within the viewport.

```html
<div class="sm-flex center nowrap">
  <div class="flex-auto">
    <a href="#!" class="btn block">Burgers</a>
  </div>
  <div class="flex-auto">
    <a href="#!" class="btn block">Fries</a>
  </div>
  <div class="flex-auto">
    <a href="#!" class="btn block">Shakes</a>
  </div>
  <div class="flex-auto">
    <a href="#!" class="btn block">Onion Rings</a>
  </div>
</div>
```
To stack navigation elements, use the `.block` utility.

```html
<div class="sm-col-6 mxn2">
  <a href="#!" class="btn block">Burgers</a>
  <a href="#!" class="btn block">Fries</a>
  <a href="#!" class="btn block">Shakes</a>
  <a href="#!" class="btn block">Onion Rings</a>
</div>
```

Standard color styles can be applied to create a variety of navigation styles.

```html
<div class="sm-col-6 bg-white border rounded">
  <a href="#!" class="btn block border-bottom">Burgers</a>
  <a href="#!" class="btn block border-bottom">Fries</a>
  <a href="#!" class="btn block border-bottom">Shakes</a>
  <a href="#!" class="btn block">Onion Rings</a>
</div>
```

The default `.btn-primary` style can be used to create a pill navigation.

```html
<div>
  <a href="#!" class="btn btn-primary">Burgers</a>
  <a href="#!" class="btn">Fries</a>
  <a href="#!" class="btn">Shakes</a>
  <a href="#!" class="btn">Onion Rings</a>
</div>
```

If you’d like to wrap your navigation in a `ul` use the `.list-reset`
style to remove bullets and padding.

```html
<ul class="list-reset mxn1 mb0">
  <li class="inline-block">
    <a href="#!" class="btn button-narrow">Burgers</a>
  </li>
  <li class="inline-block">
    <a href="#!" class="btn button-narrow">Fries</a>
  </li>
  <li class="inline-block">
    <a href="#!" class="btn button-narrow">Shakes</a>
  </li>
  <li class="inline-block">
    <a href="#!" class="btn button-narrow">Onion Rings</a>
  </li>
</ul>
```


# Breadcrumbs

Breadcrumbs are a common and well-understood wayfinding pattern used in multi-level hierarchies.
Stylistically, these are essentially the same as navigation, but with separators between items.


```html
<div class="mxn1">
  <a href="#!" class="btn button-narrow">Home</a> /
  <a href="#!" class="btn button-narrow">Hot Dogs</a> /
  <span class="btn button-narrow">Frank</span>
</div>
```

```html
<div class="mxn1">
  <a href="#!" class="btn button-narrow">Home</a>
  <svg class="icon gray" data-icon="chevron-right"></svg>
  <a href="#!" class="btn button-narrow">Hot Dogs</a>
  <svg class="icon gray" data-icon="chevron-right"></svg>
  <span class="btn button-narrow">Frank</span>
</div>
```

<p class="h5">
  Note: the icons used in this example are from
  <a href="http://geomicons.com">Geomicons Open</a>.
</p>


# Pagination

Pagination is used to split up large lists in a user-friendly way and allows for deep linking.
Use a combination of layout utilities and button styles to create navigation that suites your design.

```html
<div class="clearfix">
  <a href="#!" class="left btn">
    <svg class="icon" data-icon="chevron-left"></svg>
    Previous
  </a>
  <a href="#!" class="right btn">
    Next
    <svg class="icon" data-icon="chevron-right"></svg>
  </a>
</div>
```

Responsive state utilities can be used to progressively enhance pagination
with numbers on devices with wider viewports.

```html
<div class="clearfix">
  <a href="#!" class="left btn button-narrow">
    <svg class="icon" data-icon="chevron-left"></svg>
    Previous
  </a>
  <a href="#!" class="right btn button-narrow">
    Next
    <svg class="icon" data-icon="chevron-right"></svg>
  </a>
  <div class="overflow-hidden sm-show center">
    <a href="#!" class="btn btn-primary bg-gray">1</a>
    <a href="#!" class="btn">2</a>
    <a href="#!" class="btn">3</a>
    <a href="#!" class="btn">4</a>
    <a href="#!" class="btn">5</a>
  </div>
</div>
```

Standard color styles can be used to control the appearance.

```html
<div class="center">
  <div class="inline-block overflow-hidden border rounded">
    <a href="#!" class="left btn border-right">
      <svg class="icon" data-icon="chevron-left"></svg>
      Previous
    </a>
    <a href="#!" class="right btn">
      Next
      <svg class="icon" data-icon="chevron-right"></svg>
    </a>
    <div class="overflow-hidden sm-show">
      <a href="#!" class="left btn border-right">1</a>
      <a href="#!" class="left btn border-right">2</a>
      <a href="#!" class="left btn border-right">3</a>
    </div>
  </div>
</div>
```


# Button Groups

Button groups allow for more flexibility in establishing gestalt and controlling information density.
Use a combination of layout utilities and color extensions to create button groups.
The utilities `.rounded-left`, `.rounded-right`,
and `.not-rounded` can be used to override button and form field border radii.

```html
<div class="inline-block clearfix">
  <button type="button" class="left btn btn-primary rounded-left is-active">Burgers</button>
  <button type="button" class="left btn btn-primary border-left not-rounded">Fries</button>
  <button type="button" class="left btn btn-primary border-left rounded-right">Shakes</button>
</div>
```

## Justified Button Group
The flex object can be used to create justified button groups.

```html
<div class="flex center">
  <a href="#!" class="flex-auto btn btn-primary rounded-left is-active">Burgers</a>
  <a href="#!" class="flex-auto btn btn-primary border-left not-rounded">Fries</a>
  <a href="#!" class="flex-auto btn btn-primary border-left rounded-right">Shakes</a>
</div>
```

Normally, buttons with borders would double up when placed next to each other.
The optional `.x-group-item` utility adjusts negative margins and focus states to visually collapse borders.
Functionally, this is similar to how other frameworks handle button and form input groups,
but with more direct control over styling.

```html
<div class="inline-block clearfix blue">
  <button type="button" class="left btn btn-primary x-group-item rounded-left">Burgers</button>
  <button type="button" class="left btn btn-outline x-group-item not-rounded">Fries</button>
  <button type="button" class="left btn btn-outline x-group-item rounded-right">Shake</button>
</div>
```

Use `.y-group-item` to group elements vertically.

```html
<div class="inline-block blue">
  <button type="button" class="block col-12 btn btn-primary y-group-item rounded-top">Burgers</button>
  <button type="button" class="block col-12 btn btn-outline y-group-item not-rounded">Fries</button>
  <button type="button" class="block col-12 btn btn-outline y-group-item rounded-bottom">Shake</button>
</div>
```


# Input Groups

Input groups can be created by removing margins, adjusting border radii, and using the group utilities.
The `.hide` utility visually hides labels, while keeping them accessible to screen readers.

```html
<form class="sm-col-6">
  <label class="hide">Pancakes</label>
  <input type="text" class="block col-12 field rounded-top y-group-item" placeholder="Pancakes">
  <label class="hide">Making</label>
  <input type="password" class="block col-12 field not-rounded y-group-item" placeholder="Making">
  <label class="hide">Bacon</label>
  <input type="text" class="block col-12 mb2 field rounded-bottom y-group-item" placeholder="Bacon">
  <button type="submit" class="btn btn-primary">Pancake</button>
</form>
```

The grid system can be used to control button or input group widths.

```html
<form class="clearfix">
  <label class="hide">Bacon</label>
  <input type="text" class="col col-4 md-col-5 field rounded-left x-group-item" placeholder="Bacon">
  <label class="hide">Pancakes</label>
  <input type="password" class="col col-4 md-col-5 field not-rounded x-group-item" placeholder="Pancakes">
  <button type="submit" class="col col-4 md-col-2 btn btn-primary rounded-right">Pancake</button>
</form>
```


# Dropdowns

Dropdown menus are used to group secondary or sensitive actions
behind a two-step progressive disclosure,
while conserving screen real estate.
Dropdowns can be created with basic positioning utilities.

The wrapping elements uses relative positioning to anchor the dropdown body.
An invisible fixed position element is used as an overlay to dismiss the dropdown.
The dropdown body uses absolute positioning and margin top to align with the trigger element,
without affecting the document flow.
Be sure dropdowns don’t expand beyond the viewport when used near edges or at small screen sizes.

```html
<div class="relative inline-block" data-disclosure>
  <button type="button" class="btn btn-primary">
    Burger &#9662;
  </button>
  <div data-details class="fixed top-0 right-0 bottom-0 left-0"></div>
  <div data-details class="absolute left-0 mt1 nowrap white bg-blue rounded">
    <a href="#!" class="btn block">Rare</a>
    <a href="#!" class="btn block">Medium Rare</a>
    <a href="#!" class="btn block">Medium</a>
    <a href="#!" class="btn block">Well Done</a>
  </div>
</div>
```

<p class="h5">
  Note: this example uses a custom JavaScript function for the disclosure mechanism.
  Use a similar function, component, or directive in your own JavaScript to control behavior.
</p>


# Navbars

Navbars are used to visually group global or sub navigation
and to separate actions and navigation from content.
Using a combination of layout utilities and color styles,
you can create a wide range of navbars that are simple to customize and update.

This example uses a double sided media object to create a flexible center with a search input
that stacks at narrow viewport widths.
By applying the `.py2` utility to the link buttons,
they become the height of normal buttons and inputs plus `.py1`.

```html
<div class="clearfix mb2 white bg-black">
  <div class="left">
    <a href="#!" class="btn py2 m0">Burgers</a>
    <a href="#!" class="btn button-narrow py2 m0">Fries</a>
  </div>
  <div class="right">
    <a href="#!" class="btn py2 m0">My Account</a>
  </div>
  <div class="clearfix sm-hide"></div>
  <div class="overflow-hidden px2 py1">
    <input type="text" class="right fit field white bg-darken-1" placeholder="Search">
  </div>
</div>
```

By using rgba-based color utilities, the color can quickly be changed
using background color utilities.

```html
<div class="clearfix mb2 white bg-blue">
  <div class="left">
    <a href="#!" class="btn py2 m0">Burgers</a>
    <a href="#!" class="btn button-narrow py2 m0">Fries</a>
  </div>
  <div class="right">
    <a href="#!" class="btn py2 m0">My Account</a>
  </div>
  <div class="clearfix sm-hide"></div>
  <div class="overflow-hidden px2 py1">
    <input type="text" class="right fit field white bg-darken-1" placeholder="Search">
  </div>
</div>
<div class="clearfix mb2 white bg-gray">
  <div class="left">
    <a href="#!" class="btn py2 m0">Burgers</a>
    <a href="#!" class="btn button-narrow py2 m0">Fries</a>
  </div>
  <div class="right">
    <a href="#!" class="btn py2 m0">My Account</a>
  </div>
  <div class="clearfix sm-hide"></div>
  <div class="overflow-hidden px2 py1">
    <input type="text" class="right fit field white bg-darken-1" placeholder="Search">
  </div>
</div>
<div class="clearfix mb2 white bg-green">
  <div class="left">
    <a href="#!" class="btn py2 m0">Burgers</a>
    <a href="#!" class="btn button-narrow py2 m0">Fries</a>
  </div>
  <div class="right">
    <a href="#!" class="btn py2 m0">My Account</a>
  </div>
  <div class="clearfix sm-hide"></div>
  <div class="overflow-hidden px2 py1">
    <input type="text" class="right fit field white bg-darken-1" placeholder="Search">
  </div>
</div>
<div class="clearfix mb2 white bg-red">
  <div class="left">
    <a href="#!" class="btn py2 m0">Burgers</a>
    <a href="#!" class="btn button-narrow py2 m0">Fries</a>
  </div>
  <div class="right">
    <a href="#!" class="btn py2 m0">My Account</a>
  </div>
  <div class="clearfix sm-hide"></div>
  <div class="overflow-hidden px2 py1">
    <input type="text" class="right fit field white bg-darken-1" placeholder="Search">
  </div>
</div>
```

Because Basscss is built with inter-operable styles,
things like a user account dropdown can be added anywhere in the navbar.

```html
<div class="clearfix white bg-black">
  <div class="left">
    <a href="#!" class="btn py2 m0">Burgers</a>
    <a href="#!" class="btn button-narrow py2 m0">Fries</a>
  </div>
  <div class="right">
    <div id="account-menu" class="inline-block" data-disclosure>
      <div data-details class="fixed top-0 right-0 bottom-0 left-0"></div>
      <div class="relative">
        <a href="#!" class="btn py2 m0">My Account &#9662;</a>
        <div data-details class="absolute right-0 nowrap black bg-white rounded" style="min-width:128px">
          <ul class="h5 list-reset mb0">
            <li><a href="#!" class="btn block">Profile</a></li>
            <li><a href="#!" class="btn block">Settings</a></li>
            <li><a href="#!" class="btn block">Sign Out</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div class="clearfix sm-hide"></div>
  <div class="overflow-hidden px2">
  </div>
</div>
```

More complex
[Priority Plus](http://bradfrostweb.com/blog/web/complex-navigation-patterns-for-responsive-design/#priority-plus)
navigations can also be created using responsive utilities.

```html
<div class="relative clearfix white bg-black">
  <div class="left">
    <a href="#!" class="btn py2 m0">Burgers</a>
  </div>
  <div class="left md-show">
    <a href="#!" class="btn button-narrow py2 m0">Hot Dogs</a>
    <a href="#!" class="btn button-narrow py2 m0">Fries</a>
    <a href="#!" class="btn button-narrow py2 m0">Shakes</a>
    <a href="#!" class="btn button-narrow py2 m0">Onion Rings</a>
  </div>
  <div class="right">
    <div id="account-menu" class="inline-block" data-disclosure>
      <div data-details class="fixed top-0 right-0 bottom-0 left-0"></div>
      <a href="#!" class="btn py2 m0">
        <span class="md-hide">Menu &#9662;</span>
        <span class="md-show">More &#9662;</span>
      </a>
      <div data-details class="absolute right-0 xs-left-0 sm-col-6 md-col-4 lg-col-3 nowrap black bg-gray rounded-bottom">
        <ul class="h5 list-reset py1 mb0">
          <li class="md-hide"><a href="#!" class="btn block">Hot Dogs</a></li>
          <li class="md-hide"><a href="#!" class="btn block">Fries</a></li>
          <li class="md-hide"><a href="#!" class="btn block">Shakes</a></li>
          <li class="md-hide"><a href="#!" class="btn block">Onion Rings</a></li>
          <li><a href="#!" class="btn block">Bacon</a></li>
          <li><a href="#!" class="btn block">Pancakes</a></li>
          <li><a href="#!" class="btn block">Sausages</a></li>
          <li><a href="#!" class="btn block">Waffles</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>
<style>
/* Responsive positioning extension example */
@media (max-width:40em) {
  .xs-left-0 { left: 0 }
}
</style>
```


# Boxes

Boxes are used to group content and collections of application resources.
Use combinations of layout utilities and color styles to create boxes.

```html
<div class="md-col-6">
  <div class="p2 bg-white border rounded">
    <h1 class="h2 mt0">Bacon</h1>
    <p class="mb0">Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin.</p>
  </div>
</div>
```

To create headers and footers, set padding on nested divs then use color styles to control appearance.

```html
<div class="md-col-6">
  <div class="overflow-hidden bg-white border rounded">
    <div class="p2 bg-silver">
      <h1 class="h2 m0">Bacon with Header</h1>
    </div>
    <div class="p2">
      <p class="m0">Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin.</p>
    </div>
  </div>
</div>
```

```html
<div class="md-col-6">
  <div class="p2 bg-white border rounded">
    <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="mb2" />
    <h1 class="h2 mt0">Bacon with Image</h1>
    <p class="mb0">Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison.</p>
  </div>
</div>
```

```html
<div class="md-col-6">
  <div class="overflow-hidden bg-white border rounded">
    <div class="p2 white bg-blue">
      <h1 class="h2 m0">Bacon with Header and Footer</h1>
    </div>
    <div class="p2">
      <p class="m0">Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin. Bacon t-bone hamburger turkey capicola rump short loin.</p>
    </div>
    <div class="p2 bg-darken-1">
      <p class="m0 h5">Turkey short loin tenderloin jerky.</p>
    </div>
  </div>
</div>
```


# Flash Messages

Flash messages are used to provide feedback after the user has performed an action.
Create custom flash messages with utilities and color styles.

```html
<div class="bold center p2 mb2 white bg-red rounded">
  Warning! Half-pound burger will be deleted
</div>
<div class="bold center p2 mb2 bg-yellow rounded">
  Onion rings cannot connect to the network
</div>
<div class="bold center p2 white bg-green rounded">
  Fries added to order
</div>
```


# Badges

Badges are used to represent properties and states and
to tease quantities of resources behind navigation links.
Use basic utilities and color styles to create badges.

```html
<h1>Hamburger
  <span class="h2 inline-block px1 white bg-red rounded">Fries</span>
</h1>
<h2>Hamburger
  <span class="h3 inline-block px1 white bg-red rounded">Fries</span>
</h2>
<h3>Hamburger
  <span class="h4 inline-block px1 white bg-red rounded">Fries</span>
</h3>
<h4>Hamburger
  <span class="inline-block px1 white bg-red rounded">Fries</span>
</h4>
<h5>Hamburger
  <span class="inline-block px1 white bg-red rounded">Fries</span>
</h5>
<h6>Hamburger
  <span class="inline-block px1 white bg-red rounded">Fries</span>
</h6>
```

Color semantics can be controlled with color styles
to represent different qualities of states.

```html
<div>
  <span class="bold inline-block px1 white bg-blue rounded">Blue</span>
  <span class="bold inline-block px1 white bg-red rounded">Red</span>
  <span class="bold inline-block px1 bg-yellow rounded">Yellow</span>
  <span class="bold inline-block px1 white bg-green rounded">Green</span>
  <span class="bold inline-block px1 white bg-gray rounded">Gray</span>
  <span class="bold inline-block px1 border rounded">Bordered</span>
</div>
```


<script src="http://d2v52k3cl9vedd.cloudfront.net/geomicons/0.2.0/geomicons.min.js"></script>

<script>

  var icons = document.querySelectorAll('[data-icon]');
  Geomicons.inject(icons);

  var Disclosure = function(el, options) {
    el.isActive = false;
    el.details = el.querySelectorAll('[data-details]');
    el.hide = function() {
      for (var i = 0; i < el.details.length; i++) {
        el.details[i].style.display = 'none';
      }
    };
    el.show = function() {
      for (var i = 0; i < el.details.length; i++) {
        el.details[i].style.display = 'block';
      }
    };
    el.toggle = function(e) {
      e.stopPropagation();
      el.isActive = !el.isActive;
      if (el.isActive) {
        el.show();
      } else {
        el.hide();
      }
    }
    el.addEventListener('click', function(e) {
      el.toggle(e);
    });
    el.hide();
    return el;
  };

  var disclosures = document.querySelectorAll('[data-disclosure]');

  for (var i = 0; i < disclosures.length; i++) {
    disclosures[i] = new Disclosure(disclosures[i]);
  }

</script>

