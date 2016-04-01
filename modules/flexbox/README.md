
These flexbox-based utilities can replace the need for a grid system in many instances, and provide powerful constraint-based micro-layout solutions.
To learn more about the flexbox module, see [Using CSS flexible boxes](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes) and the [CSS Flexible Box Layout Module Specification](https://www.w3.org/TR/css-flexbox-1/).

To set a container to display flex, add the `.flex` class.

```html
<div class="flex">
  <div>Hamburger</div>
  <div>Hot Dog</div>
</div>
```

To set a container to display flex at certain breakpoints, use the `.sm-flex`, `.md-flex`, and `.lg-flex` styles.

```html
<div class="sm-flex">
  <div>Hamburger</div>
  <div>Hot Dog</div>
</div>
<div class="md-flex">
  <div>Hamburger</div>
  <div>Hot Dog</div>
</div>
<div class="lg-flex">
  <div>Hamburger</div>
  <div>Hot Dog</div>
</div>
```

To set a flexbox container to column direction, use `.flex-column`.

```html
<div class="flex flex-column">
  <span>Hamburger</span>
  <span>Hot Dog</span>
</div>
```

To enable wrapping of flexbox containers, use `.flex-wrap`.

```html
<div class="flex flex-wrap">
  <div class="col-4">Hamburger</div>
  <div class="col-4">Hamburger</div>
  <div class="col-4">Hamburger</div>
  <div class="col-4">Hamburger</div>
  <div class="col-4">Hamburger</div>
</div>
```

To set a flexbox item to automatically fill the available space, use the `flex-auto` utility.

```html
<div class="flex border">
  <div class="flex-auto border">Hamburger</div>
  <div class="border">Hot Dog</div>
</div>
```

To prevent a flexbox item from growing or shrinking, use the `flex-none` utility.

```html
<div class="flex border">
  <div class="flex-none border">Hamburger</div>
  <div class="border">Hot Dog</div>
</div>
```

To control alignment of flexbox items, use the `align-items` utilities. These styles uses a shorthand naming convention. `items` for the `align-items` property and `start` and `end` for the `flex-start` and `flex-end` values.

```html
<div class="flex items-start border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex items-end border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex items-center border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex items-baseline border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex items-stretch border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
```

To align flexbox items on an item-by-item basis, use the `align-self` utilities. These override values set by the `align-items` property. A shorthand naming convention of `self` for the `align-self` property is used.

```html
<div class="flex items-center border">
  <h1 class="self-start border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex items-center border">
  <h1 class="self-end border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex items-start border">
  <h1 class="self-center border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex items-center border">
  <h1 class="self-baseline border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex items-center border">
  <h1 class="self-stretch border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
```

To control the spacing for items on the main axis, use the `justify-content` utilities. These styles use a shorhand naming convention. `justify` for the `justify-content` property and `around` and `between` for the `space-around` and `space-between` values.

```html
<div class="flex justify-start border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex justify-end border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex justify-center border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex justify-between border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
<div class="flex justify-around border">
  <h1 class="border">Hamburger</h1>
  <div class="border">Hot Dog</div>
</div>
```

To align items along the cross-axis, use the `align-content` utilities. A shorthand naming convention `content` is used for the `align-content` property.

```html
<div class="flex flex-wrap content-start border" style="min-height: 128px">
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
</div>
```

```html
<div class="flex flex-wrap content-end border" style="min-height: 128px">
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
</div>
```

```html
<div class="flex flex-wrap content-center border" style="min-height: 128px">
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
</div>
```

```html
<div class="flex flex-wrap content-between border" style="min-height: 128px">
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
</div>
```

```html
<div class="flex flex-wrap content-around border" style="min-height: 128px">
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
</div>
```

```html
<div class="flex flex-wrap content-stretch border" style="min-height: 128px">
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
  <div class="col-6 border">Hamburger</div>
</div>
```

To change the order of flexbox items, use the `order` utilities.

```html
<div class="flex">
  <div class="order-2">.order-2</div>
  <div class="order-1">.order-1</div>
  <div class="order-last">.order-last</div>
  <div class="order-3">.order-3</div>
  <div class="order-0">.order-0</div>
</div>
```

