
This module contains responsive float and width utilities to create a variety of grid layouts.
Use this module in combination with layout, white space, and other utilities.

Start by using a `.clearfix` container.

```html
<div class="clearfix">
</div>
```

To optionally set a max-width, use a utility from the basscss-layout module.
The `.mx-auto` utility sets margin left and right auto to center the container.

```html
<div class="max-width-4 mx-auto">
  <div class="clearfix">
  </div>
</div>
```

Float columns using the `.col` style. This also sets box-sizing border-box for each column.

```html
<div class="clearfix border">
  <div class="col border">.col</div>
  <div class="col border">.col</div>
</div>
```

Add column width utilities. The total column-width number should add up to 12.

```html
<div class="clearfix border">
  <div class="col col-6 border">.col.col-6</div>
  <div class="col col-6 border">.col.col-6</div>
</div>
```

## Responsive Grid
Use breakpoint-prefixed column utilities to change the grid at different screen widths.

All breakpoint-based styles in Basscss follow the same naming convention.

<div class="overflow-auto">
  <table class="mb2 table-flush table-light">
    <thead>
      <tr> <th>Prefix</th> <th>Description</th> </tr>
    </thead>
    <tbody>
      <tr> <td>(no prefix)</td> <td>Not scoped to a breakpoint</td> </tr>
      <tr> <td>sm-</td> <td>--breakpoint-sm (default: min-width 40em)</td> </tr>
      <tr> <td>md-</td> <td>--breakpoint-md (default: min-width 52em)</td> </tr>
      <tr> <td>lg-</td> <td>--breakpoint-lg (default: min-width 64em)</td> </tr>
    </tbody>
  </table>
</div>

Apply the grid from the small breakpoint and up with the `.sm-col` and `.sm-col-6` utilities.

```html
<div class="clearfix border">
  <div class="sm-col sm-col-6 border">.sm-col.sm-col-6</div>
  <div class="sm-col sm-col-6 border">.sm-col.sm-col-6</div>
</div>
```

Add width adjustments for larger breakpoints. Resize the viewport width of the browser to see the effect.

```html
<div class="clearfix border">
  <div class="sm-col sm-col-6 md-col-5 lg-col-4 border">.sm-col.sm-col-6.md-col-5.lg-col-4</div>
  <div class="sm-col sm-col-6 md-col-7 lg-col-8 border">.sm-col.sm-col-6.md-col-7.lg-col-8</div>
</div>
```


## Gutters

Use padding and negative margin utilities to create gutters based on the white space scale.
The negative margin ensures content inside each column lines up with content outside of the grid.
When using negative margin, be sure to compensate for the extra width created
with a padded parent element or by using overflow hidden.
Otherwise, horizontal scrolling may occur.

Create gutters with a width of 2 units using `.mxn2` and `.px2`.

```html
<div class="clearfix mxn2 border">
  <div class="sm-col sm-col-6 md-col-5 lg-col-4 px2"><div class="border">.px2</div></div>
  <div class="sm-col sm-col-6 md-col-7 lg-col-8 px2"><div class="border">.px2</div></div>
</div>
```

For larger or smaller gutters, use any other step on the white space scale.

```html
<div class="clearfix mxn1 border">
  <div class="col col-6 px1"><div class="border">.px1</div></div>
  <div class="col col-6 px1"><div class="border">.px1</div></div>
</div>
<div class="clearfix mxn3 border">
  <div class="col col-6 px3"><div class="border">.px3</div></div>
  <div class="col col-6 px3"><div class="border">.px3</div></div>
</div>
```

## Nesting
Nest entire grid structures within columns to created nested grids.

```html
<div class="clearfix mxn2 border">
  <div class="sm-col sm-col-6 md-col-5 lg-col-4 px2"><div class="border">Unnested</div></div>
  <div class="sm-col sm-col-6 md-col-7 lg-col-8 px2">
    <div class="clearfix mxn2">
      <div class="col col-6 px2"><div class="border">Nested</div></div>
      <div class="col col-6 px2"><div class="border">Nested</div></div>
    </div>
  </div>
</div>
```

## Reversed
To reverse the order of columns, use the `.col-right` class to float columns right.

```html
<div class="clearfix border">
  <div class="col-right col-6 border">.col-right.col-6</div>
  <div class="col col-6 border">.col.col-6</div>
</div>
```

## Centering Columns
Use the `.mx-auto` class to center columns within their containers.

```html
<div class="clearfix mxn2 border">
  <div class="col-8 px2 mx-auto">
    <div class="border">Centered Column</div>
  </div>
</div>
```

## Breakpoint Based Floats
Column float utilities can be used independently of width utilities to control floating at different breakpoints.
This example demonstrates a responsive media object.

```html
<div class="clearfix border">
  <div class="sm-col p2 border">.sm-col</div>
  <div class="overflow-hidden border">.overflow-hidden</div>
</div>
```

## Width Utilities
Column width utilities can also be used independently to add percentage based widths to any block or inline-block element.

```html
<div class="border">
  <div class="right sm-col-6 md-col-4 p2 border">.sm-col-6.md-col-4</div>
  <p>Bacon ipsum dolor sit amet chuck prosciutto landjaeger ham hock filet mignon shoulder hamburger pig venison. Ham bacon corned beef, sausage kielbasa flank tongue pig drumstick capicola swine short loin ham hock kevin.</p>
</div>
```

