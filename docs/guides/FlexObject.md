
# Flex Object

<p class="h3">
  The flex object can help solve many page-level and micro layout problems and can be combined with other utilities for a wide range of applications.
  This guide demonstrates several solutions to common layout problems using the flex object and other Basscss utilities.
</p>

Many of the examples in this post are inspired by Philip Walton's excellent [Solved by Flexbox](http://philipwalton.github.io/solved-by-flexbox/) project.


## Vertical Alignment

One of the most obvious use-cases for flexbox, is vertical alignment. To vertically align elements with the Flex Object, add the `.flex` and `.flex-center` classes to the parent container and set a height. This demo uses min-height 100vh to fill the height of the viewport. To horizontally center the child element, use the `.mx-auto` class to set margin auto on the x-axis.

```html
<div class="flex flex-center p2" style="min-height:128px">
  <div class="bold p2 mx-auto border blue">
    Vertically Aligned Div
  </div>
</div>
```


## Sticky Footer

To ensure that a page's footer stays flush to the bottom when the content is shorter than the height of the viewport,
use a combination of `.flex` and `.flex-column` on the body element or other parent container and set its min-height to 100vh.
Add `.flex-auto` to the main content area to make it fill the available space.

```html
<!-- Note: min-height is set to 60vh for demonstration only. -->
<!-- Use 100vh to fill the viewport height. -->
<div class="flex flex-column" style="min-height:60vh">
  <header class="p2 border">
    <h1 class="h2 m0">Flex Object Sticky Footer</h1>
  </header>
  <main class="flex-auto p2">
    <h1>Main content area</h1>
  </main>
  <footer class="p2 border">
    <p class="m0">Footer</p>
  </footer>
</div>
```


## Holy Grail

The Holy Grail layout is a classic CSS layout problem with several different possible solutions.
The layout consists of a header, three columns, and a footer. The center column should be fluid, with fixed-width columns to the left and right, all columns should have equal height, the left column should be after the main content in HTML source order, and the footer should stick to the bottom of the viewport if there's not enough content to fill the space.
For more on this layout, see the [A List Apart article](http://alistapart.com/article/holygrail).

This demo uses the same technique as the sticky footer example, along with the `.flex-first` utility to visually change the order of the columns.
By default, the columns will all be equal height when using display flex on the parent.
Each fixed-width column uses inline-styles, but you may want to use a grid system or some custom CSS to better handle the layout at small viewport widths.

```html
<!-- Note: min-height is set to 60vh for demonstration only. -->
<!-- Use 100vh to fill the viewport height. -->
<div class="flex flex-column" style="min-height:60vh">
  <header class="p2 border">
    <h1 class="h2 m0">Flex Object Holy Grail</h1>
  </header>
  <div class="flex-auto sm-flex">
    <main class="flex-auto p2">
      <h1>Main content</h1>
      <p>Sorry it's not 100% responsive, but the sidebars have to be fixed width for this demo.</p>
    </main>
    <nav class="flex-first border" style="width:8rem">
      <ul class="list-reset mt2 mb2">
        <li><a href="#" class="btn block">Link</a>
        <li><a href="#" class="btn block">Link</a>
        <li><a href="#" class="btn block">Link</a>
      </ul>
    </nav>
    <aside class="p2 border" style="width:8rem">
      <p>Sidebar</p>
    </aside>
  </div>
  <footer class="p2 border">
    <p class="m0">Footer</p>
  </footer>
</div>
```


## Input Groups
To group buttons or other elements with inputs, add `.flex` to a container element and remove margins from the child elements.
Borders and border radii can be controlled using utility styles.

```html
<div class="p2">
  <div class="flex mb2">
    <label for="search-input" class="hide">Search</label>
    <input
      type="search"
      id="search-input"
      class="flex-auto m0 field rounded-left"
      placeholder="Search">
    <button class="btn rounded-right border black bg-silver">Go</button>
  </div>
  <div class="flex mb2">
    <label for="search-input" class="hide">Search</label>
    <input
      type="search"
      id="search-input"
      class="flex-auto m0 field rounded-left"
      placeholder="Search">
    <button class="btn not-rounded black bg-silver">Button</button>
    <button class="btn rounded-right border-left black bg-silver">Go</button>
  </div>
  <div class="flex mb2">
    <button class="btn rounded-left black bg-silver">Button</button>
    <label for="search-input" class="hide">Search</label>
    <input
      type="search"
      id="search-input"
      class="flex-auto m0 field not-rounded"
      placeholder="Search">
    <button class="btn rounded-right border-left black bg-silver">Go</button>
  </div>
</div>
```


## Media Object

The [Media Object](http://www.stubbornella.org/content/2010/06/25/the-media-object-saves-hundreds-of-lines-of-code/)
is a classic OOCSS solution for setting a fluid column next to an image. To acheive this with the Flex Object, add `.flex` to the container element and `.flex-auto` to the Media Object's body. To vertically center the body, add `.flex-center` to the container. This technique can also be used for multiple combinations of images and other content.

```html
<div class="p2">
  <h2>Media Object</h2>
  <div class="flex mb2">
    <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg"
      width="96" height="96"
      class="flex-none mr2" />
    <div class="flex-auto">
      <p class="m0">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Voluptatum, soluta, ut obcaecati, laudantium nobis.</p>
    </div>
  </div>
  <h2>Centered Media Object (aka Flag Object)</h2>
  <div class="flex flex-center mb2">
    <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg"
      width="96" height="96"
      class="flex-none mr2" />
    <div class="flex-auto">
      <p class="m0">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Voluptatum, soluta, ut obcaecati, laudantium nobis.</p>
    </div>
  </div>
  <h2>Double-Sided Media Object</h2>
  <div class="flex flex-center mb2">
    <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg"
      width="96" height="96"
      class="flex-none mr2" />
    <div class="flex-auto">
      <p class="m0">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Voluptatum, soluta, ut obcaecati, laudantium nobis.</p>
    </div>
    <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg"
      width="96" height="96"
      class="flex-none ml2" />
  </div>
</div>
```


## Automatic Grid

To create columns that automatically fill the amount of space available, add `.flex-auto` each column. This is handy when the number of items in a row dynamically changes.

```html
<div class="center p2">
  <div class="flex mxn2">
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
  </div>
  <div class="flex mxn2">
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
  </div>
  <div class="flex mxn2">
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
  </div>
  <div class="flex mxn2">
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
  </div>
  <div class="flex mxn2">
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">.flex-auto</div></div>
  </div>
</div>
```


## Grid with Individual Column Sizing

Setting a width on one or more columns can allow for more fine-grained control.

```html
<div class="center flex-auto p2">
  <div class="flex mxn2">
    <div class="flex-none col-6 border-box p2"><div class="p2 border">1/2</div></div>
    <div class="flex-auto p2"><div class="p2 border">auto</div></div>
    <div class="flex-auto p2"><div class="p2 border">auto</div></div>
  </div>
  <div class="flex mxn2">
    <div class="col-4 border-box p2"><div class="p2 border">1/3</div></div>
    <div class="flex-auto p2"><div class="p2 border">auto</div></div>
  </div>
  <div class="flex mxn2">
    <div class="col-3 border-box p2"><div class="p2 border">1/4</div></div>
    <div class="flex-auto p2"><div class="p2 border">auto</div></div>
    <div class="col-4 border-box p2"><div class="p2 border">1/3</div></div>
  </div>
</div>
```


## Responsive Grid

To only set display flex from a certain breakpoint and up, use `.sm-flex`, `.md-flex`, or `.lg-flex`.
The flex context for child elements will only be enabled from that breakpoint and up, so all other Flex Object utilities stay the same.
Add `.flex-wrap` to rows where columns should wrap, and use grid column width utilities to set different widths for different breakpoints.

```html
<div class="center p2">
  <div class="flex mxn2">
    <div class="col-6 border-box p2"><div class="p2 border">.col-6</div></div>
    <div class="col-6 border-box p2"><div class="p2 border">.col-6</div></div>
  </div>
  <hr>
  <div class="flex flex-wrap mxn2">
    <div class="col-6 md-col-3 border-box p2"><div class="p2 border">.col-6 .md-col-3</div></div>
    <div class="col-6 md-col-3 border-box p2"><div class="p2 border">.col-6 .md-col-3</div></div>
    <div class="col-6 md-col-3 border-box p2"><div class="p2 border">.col-6 .md-col-3</div></div>
    <div class="col-6 md-col-3 border-box p2"><div class="p2 border">.col-6 .md-col-3</div></div>
  </div>
  <hr>
  <div class="sm-flex flex-wrap mxn2">
    <div class="sm-col-6 lg-col-2 border-box p2"><div class="p2 border">.sm-col-6 .lg-col-2</div></div>
    <div class="sm-col-6 lg-col-2 border-box p2"><div class="p2 border">.sm-col-6 .lg-col-2</div></div>
    <div class="sm-col-6 lg-col-2 border-box p2"><div class="p2 border">.sm-col-6 .lg-col-2</div></div>
    <div class="sm-col-6 lg-col-2 border-box p2"><div class="p2 border">.sm-col-6 .lg-col-2</div></div>
    <div class="sm-col-6 lg-col-2 border-box p2"><div class="p2 border">.sm-col-6 .lg-col-2</div></div>
    <div class="sm-col-6 lg-col-2 border-box p2"><div class="p2 border">.sm-col-6 .lg-col-2</div></div>
  </div>
</div>
```


## Nested Grid

To nest elements, add `.flex` to the column that contains nested columns.

```html
<div class="center flex-auto p2">
  <div class="flex flex-center mxn2">
    <div class="flex-auto border-box p2"><div class="p2 border">.flex-auto</div></div>
    <div class="sm-flex col-6 border-box p2 border">
      <div class="flex-auto"><div class="p2 border">.flex-auto</div></div>
      <div class="flex-auto"><div class="p2 border">.flex-auto</div></div>
    </div>
  </div>
</div>
```



## Staggered Boxes

To stagger content differently than its source order in HTML, use the `.flex-first` or `.flex-last` utilities.

```html
<div class="center flex-auto p2">
  <p>Resize the viewport to see the effect.</p>
  <div class="sm-flex flex-center">
    <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="192" width="192" class="flex-last m2" />
    <div class="flex-auto p2 border">.flex-auto</div>
  </div>
  <div class="sm-flex flex-center">
    <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="192" width="192" class="m2" />
    <div class="flex-auto p2 border">.flex-auto</div>
  </div>
  <div class="sm-flex flex-center">
    <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="192" width="192" class="flex-last m2" />
    <div class="flex-auto p2 border">.flex-auto</div>
  </div>
  <div class="sm-flex flex-center">
    <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="192" width="192" class="m2" />
    <div class="flex-auto p2 border">.flex-auto</div>
  </div>
</div>
```


## Equal Height Columns

Columns with different amounts of content should be the same height by default. To ensure that nested elements also maintain equal height, add `.flex` to the parent column.

```html
<div class="px2">
  <div class="flex mxn2">
    <div class="col-6 border-box p2 border">
      <div>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quia qui tempore, odio sit ad magni eaque expedita fugit autem, error, facilis excepturi omnis. Pariatur iste possimus soluta quos, deserunt, laborum.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quia qui tempore, odio sit ad magni eaque expedita fugit autem, error, facilis excepturi omnis. Pariatur iste possimus soluta quos, deserunt, laborum.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quia qui tempore, odio sit ad magni eaque expedita fugit autem, error, facilis excepturi omnis. Pariatur iste possimus soluta quos, deserunt, laborum.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quia qui tempore, odio sit ad magni eaque expedita fugit autem, error, facilis excepturi omnis. Pariatur iste possimus soluta quos, deserunt, laborum.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quia qui tempore, odio sit ad magni eaque expedita fugit autem, error, facilis excepturi omnis. Pariatur iste possimus soluta quos, deserunt, laborum.</p>
      </div>
    </div>
    <div class="col-6 flex border-box p2 border">
      <div class="col-12 border">Equal height column</div>
    </div>
  </div>
</div>
```



## Cards

Taking this same approach, you can create a collection of cards, that maintain the same height per row.
Percentage based grid utilities are used to set different widths at different breakpoints.
This method also works well when the number of items changes dynamically.

```html
<div class="p2">
  <div class="flex flex-wrap mxn2">
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
        <p class="m0">Card that is taller than the others</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
    <div class="flex col-6 sm-col-4 md-col-3 lg-col-2 border-box p2">
      <div class="p1 border rounded">
        <img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" width="256" height="auto" />
        <p class="m0">Card</p>
      </div>
    </div>
  </div>
</div>
```


