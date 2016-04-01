
# Basics

<p class="h3">
  Understanding the basics of designing for the web with CSS
  is essential to using Basscss effectively.
  This guide covers the fundamentals to help get you started.
</p>

# Document structure
HTML is a semantically structured markup language.
When building anything on the web, start with clean markup that accurately
reflects your information hierarchy.
When hierarchy changes, be sure to update the markup before making any stylistic changes.
The most important parts of web design involve no CSS at all.

# Multiclass CSS pattern
Basscss is based on Object Oriented CSS (OOCSS) principles.
OOCSS has many benefits, including code readability, reusable styles, smaller CSS files,
more performant selectors, more flexible markup structure, and code scalability.
Basscss is meant to be a very simple and intuitive take on this approach,
well suited to designing in the browser, rapid prototyping, or serving as the basis for a larger project.

One of the defining features of OOCSS is the multiclass pattern.
This is the practice of using multiple classes on a single HTML element.
This can seem strange at first, but once you get the hang of things,
it can make designing and building websites much faster and easier.
It also has some significant front-end performance benefits.

## Example

```html
<div class="h3 p1 mb2 bg-silver rounded">
  A box with font-size .h3, padding, margin-bottom, a light gray background and rounded corners
</div>
```

# Order
While the order of classes doesn’t matter to the browser, maintaining
a consistent order will drastically improve code readability.
I recommend the following order:

1. **Typography** &#x2013; sets the visual hierarchy and is one of the most important parts of web design</li>
2. **Positioning** &#x2013; can severely change document flow</li>
3. **Layout** &#x2013; can affect other elements and document flow</li>
4. **Color & Theme** &#x2013; has little or no effect on layout</li>
5. **State** &#x2013; is dynamic and often unnecessary</li>

# Writing and Typography

Good writing and typography are key to successful web design.
Typography should serve as the basis for gestalt, user flows, and information hierarchy.
Ensure that links, form labels, helper text, buttons, and other microcopy
receive as much attention as body copy, and remember the two serve very different purposes.

# Block-level and Inline Elements

There are two basic types of elements in HTML.
[Block-level elements](https://developer.mozilla.org/en-US/docs/HTML/Block-level_elements)
are larger container elements that begin on a new line and take up the entire width
of their parent container by default.
Block-level elements can also have set widths and heights.
They may contain other block-level elements and inline elements.

[Inline Elements](https://developer.mozilla.org/en-US/docs/HTML/Inline_elements)
do not begin a new line and contain content and other inline elements.
Inline elements are only as large as the content they contain.

In HTML5, things get a little more complicated, but the basics still apply.
Learn more:
[HTML5 Content Categories](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Content_categories).

# Display Property

Basscss’s display utilities override the default behaviors of block-level and inline elements.
To make a block-level element inline, use the `.inline` class.
To make inline elements block-level, use `.block`.

Inline-block is a mix of these two properties.
Inline-block elements have a block element box, with optional width and height,
but flow with surrounding content like an inline element.

# Box Model

The box-model is the basis of all HTML layout.
Understanding how it works is crucial to designing for the web.
Block-level elements naturally fill the width of their parents.
Margins add space around the element. Borders add space around the element, but within the margins.
Padding adds space within the element.
If an element has no set width, it will shrink to fit its container.

If an element has a declared width or height, padding and borders will be added to those values.
It’s often easier to add padding and borders to child elements rather than directly to elements with set widths.
For example, when using a grid system.

## Box Model Simulation

<div class="center p1 blue border">
  <p class="mb0">Margin</p>
  <div class="m1 py1 px2 border">
    <p>Padding</p>
    <div class="p2 border">Content</div>
  </div>
</div>

# Floats

Floats are for wrapping text around images, but are also used for breaking
elements out of the normal document flow.
When you float an element left or right, the content following the float will flow beside and around the element.

Do not set display properties on floated elements.
When elements are floated, they are set to display block.

```html
<div class="border">
  <div class="right p1 border">.right</div>
  <p>Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin. Bacon t-bone hamburger turkey capicola rump short loin. Drumstick pork fatback pork chop doner pork belly prosciutto pastrami sausage. Ground round prosciutto shank pastrami corned beef venison tail. Turkey short loin tenderloin jerky porchetta pork loin.</p>
</div>
```

If an element contains only floated children, such as in a grid system, its height will collapse.
Clearfixes are used to ensure the parent element maintains the height of its content.
This container element is using the `.clearfix` class.

```html
<div class="clearfix border">
  <div class="left p2 border">.left</div>
  <div class="left p2 border">.left</div>
  <div class="right p2 border">.right</div>
</div>
```

Overflow hidden crops overflowing content, but can also be used as a clearfix
because it creates what’s called a new _block formatting context_.

```html
<div class="border">
  <div class="overflow-hidden border">
    <div class="left p2 border">.left</div>
    <div class="left p2 border">
      .left
      <div class="p1 border" style="width:64rem">wider than parent element</div>
    </div>
  </div>
</div>
```

Using overflow hidden on an element placed after one or more floated elements will prevent that element from wrapping under the floated elements.
This is the basis of the
[Media Object](http://www.stubbornella.org/content/2010/06/25/the-media-object-saves-hundreds-of-lines-of-code/).

```html
<div class="clearfix border">
  <div class="left p1 border">.left</div>
  <p class="overflow-hidden p1 border">.overflow-hidden (overflow hidden) Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin. Bacon t-bone hamburger turkey capicola rump short loin. Drumstick pork fatback pork chop doner pork belly prosciutto pastrami sausage. Ground round prosciutto shank pastrami corned beef venison tail. Turkey short loin tenderloin jerky porchetta pork loin.</p>
</div>
```

```html
<div class="clearfix border">
  <div class="left p1 border">.left</div>
  <div class="right p1 border">.right</div>
  <p class="overflow-hidden p1 border">.overflow-hidden (overflow hidden) Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin. Bacon t-bone hamburger turkey capicola rump short loin. Drumstick pork fatback pork chop doner pork belly prosciutto pastrami sausage. Ground round prosciutto shank pastrami corned beef venison tail. Turkey short loin tenderloin jerky porchetta pork loin.</p>
</div>
```

# Widths

The default document flow in HTML is fluid.
This means that creating fluid and responsive layouts should be very easy to achieve.
Avoid using fixed widths at all in your layout.
Instead rely heavily on the normal document flow.

For elements with inherit widths, such as images, consider using a max-width of 100%
to ensure it never overflows its container.
Use the `.fit` class to do this.

```html
<img src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder-square.svg" alt="Basscss" class="fit"/>
```

If you do need to use widths, use percentages.
Most grid systems these days use this approach,
along with media queries to prevent broken layouts across devices.
When using percentage-based widths, remember that the percentage is based on width of the parent,
so nesting elements with percentage-based widths will get incrementally smaller as you nest.

```html
<div class="clearfix border">
  <div class="left col-6 py1"><div class="border">.left.col-6</div></div>
  <div class="left col-6">
    <div class="left col-6 py1"><div class="border">Nested .left.col-6</div></div>
    <div class="left col-6 py1"><div class="border">Nested .left.col-6</div></div>
  </div>
</div>
```

# Media Queries and Mobile-First Approach

When building responsive websites, best practices suggest using a mobile-first approach.
First consider content and user flows, then create layouts that work well
at small screen sizes and touch devices.
Once that’s in a good place use styling to enhance the experience on larger devices.
For interactive elements, design for touchscreen-sized tap targets first.
This usually translates well for use on desktop computers with pointing devices.

Basscss includes several state utilities for showing and hiding content on mobile devices.
Use these with care.
Mobile users still want the same content across devices and often switch devices mid-task.
Creating a cohesive experience is key to a good experience with your product.

# Positions

Positions allow you to move elements out of the default document flow.
They can be tricky to use, and I recommend using them as little as possible.

By default, elements have a `static` position.
Use the `.relative` class to keep elements in the default document flow
but create a new positioning context.
This is useful when anchoring to specific elements or dealing with `z-index`.

Use the `.absolute` class along with the `.top-0`, `.right-0`, `.bottom-0`, and
`.left-0` utilities to anchor elements to the top, right, bottom,
or left of their current positioning context.
Use the padding or margin utilities to add space around the element.
Using two opposing anchoring utilities, such as
`.left-0` and `.right-0` will make an element span the full width.

Use the `.fixed` class to give an element fixed positioning relative to the viewport.
Use this with caution. It can cause issues with mobile devices and is commonly abused in web design.

By default, positioned elements are stacked one on top of the other based on their position in the document.
Try reordering elements in the document before applying z-index properties.
If you do need to set z-index, start with the `.z1` class and work up from there.
And be sure you
[understand z-index](http://philipwalton.com/articles/what-no-one-told-you-about-z-index/)
before adding more than four levels.

```html
<div class="border">
  <div class="relative p4 border">
    .relative
    <div class="absolute top-0 right-0 p1 m1 border">.absolute .top-0 .right-0</div>
    <div class="absolute top-0 right-0 p1 m3 border">.absolute .top-0 .right-0</div>
  </div>
</div>
```

# Extending Basscss

You can do a lot with Basscss’s suite of styles, but if you decide to add new styles to your project,
here are some tips and recommendations to keep your code simple and maintainable:

- Keep styles as reusable as possible.
- Only apply styles to base elements once.
- Never use ids, attributes (e.g. `[type=text]`) or the universal selector (`*`) as selectors.
- Never use adjoining selectors.
- Avoid parent and sibling selectors.
- Prefer using class selectors directly on the elements they’re styling.
- Use clear, descriptive names for selectors.
- Keep structural styles and theme styles separate.
- Avoid using mixins and extends in sass &#x2013; it’s often easier and more readable (especially for others) to write styles out by hand.

To learn more about building on top of Basscss, I recommend reading the
[Design Principles](/docs/reference/principles).



