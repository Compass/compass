
Change the default document flow with these display, float, and other utilities.

## Display

To adjust the display of an element, use the `.block`, `.inline`, `.inline-block`, `.table`, and `.table-cell` utilities.

```html
<div class="inline">inline</div>
<div class="inline-block">inline-block</div>
<a href="#" class="block">block</a>
<div class="table">
  <div class="table-cell">table-cell</div>
  <div class="table-cell">table-cell</div>
</div>
```

## Overflow

To adjust element overflow, use `.overflow-hidden`, `.overflow-scroll`, and `.overflow-auto`.
`.overflow-hidden` can also be used to create a new block formatting context or clear floats.

## Floats

Use `.clearfix`, `.left`, and `.right` to clear and set floats.

```html
<div class="clearfix border">
  <div class="left border">.left</div>
  <div class="right border">.right</div>
</div>
```

## Max Width

Use `.fit` to set max-width 100%.

```html
<div class="col-3">
  <img class="fit" src="http://d2v52k3cl9vedd.cloudfront.net/assets/images/placeholder.svg" />
</div>
```

Use max-width utilities to control the width of containers.

```html
<p class="max-width-1">Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison.</p>
<p class="max-width-2">Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison.</p>
<p class="max-width-3">Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison.</p>
<p class="max-width-4">Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison.</p>
```

## Box-Sizing Border-Box

Use `.border-box` to set box-sizing border-box per element.

```html
<div class="col-6 p2 border-box border">.border-box</div>
```

## Media Object
Create a media object using basic utilities.

```html
<div class="clearfix mb2 border">
  <div class="left p2 mr1 border">Image</div>
  <div class="overflow-hidden">
    <p><b>Body</b> Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison.</p>
  </div>
</div>
```

## Double-Sided Media Object
For a container with a flexible center, use a double-sided media object.

```html
<div class="clearfix mb2 border">
  <div class="left p2 mr1 border">Image</div>
  <div class="right p2 ml1 border">Image</div>
  <div class="overflow-hidden">
    <p><b>Body</b> Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison.</p>
  </div>
</div>
```

