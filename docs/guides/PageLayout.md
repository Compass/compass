
# Page Layout

<p class="h3">
  Creating page layouts in Basscss is incredibly fast and flexible.
  This guide will walk you through common layout patterns to create an entire page with a basic information hierarchy.
</p>

Note: this guide makes use of the optional <a href="https://www.npmjs.com/package/basscss-background-images" target="_blank">Background Images</a> and <a href="https://www.npmjs.com/package/basscss-utility-headings" target="_blank">Utility Heading</a> modules that are not included in the default Basscss package.

# Global Navigation

To start off, make a global navigation using the grid system and other utilities.

```html
<nav class="clearfix white bg-black">
  <div class="sm-col">
    <a href="/" class="btn py2">Home</a>
    <a href="/" class="btn py2">Burgers</a>
    <a href="/" class="btn py2">Fries</a>
  </div>
  <div class="sm-col-right">
    <a href="/" class="btn py2">About</a>
  </div>
</nav>
```

For the navigation links, use button styles to provide large hit targets
and a consistent visual spacing.
Use the margin and padding utilities to fine tune the spacing.
The left side uses the `.sm-col` class to float left above the small breakpoint.
The right side uses `.sm-col-right`.
By not defining a column width, each side will be as wide as its contents.


# Hero Banner

Next create a hero banner using utility styles.
Note: This example uses the optional `basscss-background-images` and `basscss-utility-headings` modules for the large heading.

```html
<header class="center px3 py4 white bg-gray bg-cover bg-center"
  style="background-image: url(https://d262ilb51hltx0.cloudfront.net/max/2000/1*DZwdGMaeu-rvTroJYui6Uw.jpeg)">
  <h1 class="h1 h0-responsive caps mt4 mb0 regular">Hamburgers</h1>
  <p class="h3">Artisinal ground chuck creations</p>
  <a href="#" class="h3 btn btn-primary mb4">Pancake</a>
</header>
```

A combination of utility styles is all that’s needed to create this banner.
To fine tune the placement of a background image in a banner,
consider adjusting the source image or placing page-specific styles directly in the head of the document.
Since this image will only be used on this one page and it’s fairly small,
an inline style has been used.
This is to help reduce the size of the stylesheet by not including one-off styles.

After seeing the global navigation above the hero,
try moving it into the banner and removing the background color for a different look.
Move the padding for the banner content into a nested div to adjust the layout.

```html
<header class="white bg-gray bg-cover bg-center"
  style="background-image: url(https://d262ilb51hltx0.cloudfront.net/max/2000/1*DZwdGMaeu-rvTroJYui6Uw.jpeg)">
  <nav class="clearfix white">
    <div class="sm-col">
      <a href="/" class="btn py2">Home</a>
      <a href="/" class="btn py2">Burgers</a>
      <a href="/" class="btn py2">Fries</a>
    </div>
    <div class="sm-col-right">
      <a href="/" class="btn py2">About</a>
    </div>
  </nav>
  <div class="center px2 py4">
    <h1 class="h1 h0-responsive caps mt4 mb0 regular">Hamburgers</h1>
    <p class="h3">Artisinal ground chuck creations</p>
    <a href="#" class="h3 btn btn-primary mb4">Pancake</a>
  </div>
</header>
```


# Three Up

Next, use the grid system to create a three-up row of features.
Note the use of `sm-` prefixed grid utility styles that only work from the small breakpoint up.
The row itself uses the `.mxn2` utility to compensate for each column’s `.px2` padding.
To control the spacing of typographic elements, each heading has its bottom margin removed.

```html
<section class="container px2 py3">
  <div class="clearfix mxn2">
    <div class="sm-col sm-col-4 px2">
      <h2 class="h1 mb0">Bacon</h2>
      <p>Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin.</p>
    </div>
    <div class="sm-col sm-col-4 px2">
      <h2 class="h1 mb0">Bratwurst</h2>
      <p>Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin.</p>
    </div>
    <div class="sm-col sm-col-4 px2">
      <h2 class="h1 mb0">Andouille</h2>
      <p>Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin.</p>
    </div>
  </div>
</section>
```


# Blog Teaser

To showcase the latest posts from the blog, create a new section.
Use the grid system to create a wide left column
and a narrow right column for direct links to blog post categories.
The columns have two different widths defined for the small and medium breakpoints.
This makes the right column relatively smaller for larger viewports.
Use the `.sm-show` responsive utility to hide the sidebar when the viewport is narrower
than the small breakpoint.

```html
<section class="container px2 py3">
  <h1 class="mt0">
    <a href="#" class="black">
      Blog
    </a>
  </h1>
  <div class="clearfix mxn2">
    <div class="sm-col sm-col-8 md-col-9 px2">
      <div>
        <h2 class="h3">
          <a href="#" class="black">
            Blog Post Title
          </a>
        </h2>
        <p>Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin.</p>
        <a href="#">Read more</a>
      </div>
      <div>
        <h2 class="h3">
          <a href="#" class="black">
            Blog Post Title
          </a>
        </h2>
        <p>Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin.</p>
        <a href="#">Read more</a>
      </div>
    </div>
    <div class="sm-col sm-col-4 md-col-3 px2 sm-show">
      <h3 class="h4">Categories</h3>
      <ul class="list-reset">
        <li><a href="#" class="">Bacon</a></li>
        <li><a href="#" class="">Bratwurst</a></li>
        <li><a href="#" class="">Andouille</a></li>
        <li><a href="#" class="">Pork Loin</a></li>
        <li><a href="#" class="">Corned Beef</a></li>
        <li><a href="#" class="">Pastrami</a></li>
      </ul>
    </div>
  </div>
</section>
```


# Gallery

Next, create a thumbnail gallery with 12 images.
Twelve is divisible by 6, 4, 3, and 2 so no widows will appear
when dividing up the thumbnails by those numbers in our grid.

```html
<section class="container px2 py3">
  <h1 class="mt0">
    <a href="#" class="black">
      Gallery
    </a>
  </h1>
  <div class="clearfix mxn2">
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="sm-show md-hide clearfix"></div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="md-show lg-hide clearfix"></div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="sm-show md-hide clearfix"></div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="md-show lg-hide clearfix"></div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="sm-show md-hide clearfix"></div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
    <div class="col col-6 sm-col-4 md-col-3 lg-col-2 px2 mb3">
      <a href="#" class="block">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" class="block" />
      </a>
    </div>
  </div>
</section>
```

The display block utility is used on the links and images to control spacing,
and each thumbnail uses `.mb3` to keep the vertical spacing equal to the gutters.
Although it’s unnecessary for images of the same dimension,
clearfix elements with responsive utilities are used to ensure each column wraps at the appropriate point.


# Footer

Finally, create a footer with a dark background that fills the width of the viewport.
Note the container is placed inside the footer element to control max-width.

```html
<footer class="white bg-black">
  <div class="px2 py3 container">
    <div class="clearfix mxn2">
      <div class="col col-6 md-col-3">
        <ul class="list-reset">
          <li>
            <h3 class="h4 m0">
              <a href="#" class="btn block">Home</a>
            </h3>
          </li>
          <li><a href="#" class="h5 btn block">Bacon</a></li>
          <li><a href="#" class="h5 btn block">Bratwurst</a></li>
          <li><a href="#" class="h5 btn block">Andouille</a></li>
          <li><a href="#" class="h5 btn block">Pork Loin</a></li>
        </ul>
      </div>
      <div class="col col-6 md-col-3">
        <ul class="list-reset">
          <li>
            <h3 class="h4 m0">
              <a href="#" class="btn block">Categories</a>
            </h3>
          </li>
          <li><a href="#" class="h5 btn block">Bacon</a></li>
          <li><a href="#" class="h5 btn block">Bratwurst</a></li>
          <li><a href="#" class="h5 btn block">Andouille</a></li>
          <li><a href="#" class="h5 btn block">Pork Loin</a></li>
        </ul>
      </div>
      <div class="col col-6 md-col-3">
        <ul class="list-reset">
          <li>
            <h3 class="h4 m0">
              <a href="#" class="btn block">Categories</a>
            </h3>
          </li>
          <li><a href="#" class="h5 btn block">Bacon</a></li>
          <li><a href="#" class="h5 btn block">Bratwurst</a></li>
          <li><a href="#" class="h5 btn block">Andouille</a></li>
          <li><a href="#" class="h5 btn block">Pork Loin</a></li>
        </ul>
      </div>
      <div class="col col-6 md-col-3">
        <ul class="list-reset">
          <li>
            <h3 class="h4 m0">
              <a href="#" class="btn block">About</a>
            </h3>
          </li>
          <li><a href="#" class="h5 btn block">Bacon</a></li>
          <li><a href="#" class="h5 btn block">Bratwurst</a></li>
          <li><a href="#" class="h5 btn block">Andouille</a></li>
          <li><a href="#" class="h5 btn block">Pork Loin</a></li>
        </ul>
      </div>
    </div>
    <p class="h6 mb0">&copy; 2014 Hamburgers, LLC</p>
  </div>
</footer>
```


