
Use these utilities to conditionally hide elements based on viewport width.

## Prefix Naming Convention

Hide utilities differ from other breakpoint-based styles in Basscss. Each hide utility only applies to one breakpoint range.

<div class="overflow-auto">
  <table class="mb2 table-flush table-light">
    <thead>
      <tr> <th>Prefix</th> <th>Description</th> </tr>
    </thead>
    <tbody>
      <tr> <td>xs-</td> <td>below 40em</td> </tr>
      <tr> <td>sm-</td> <td>40em – 52em</td> </tr>
      <tr> <td>md-</td> <td>52em – 64em</td> </tr>
      <tr> <td>lg-</td> <td>above 64em</td> </tr>
    </tbody>
  </table>
</div>


## Hide content
Resize the browser window to see the effect.

```html
<h3 class="xs-hide">Hidden below 40em</h3>
<h3 class="sm-hide red">Hidden between 40 and 52em</h3>
<h3 class="md-hide red">Hidden between 52 and 64em</h3>
<h3 class="lg-hide red">Hidden above 64em</h3>
```

## Responsive Line Break
Control wrapping at different screen widths.

```html
<h1>
  Responsive Line Break
  <br class="xs-hide">
  To Control Wrapping
</h1>
```

## Accessible Hide

To visually hide things like form labels in an accessible way, use the `.hide` utility.

```html
<form>
  <label for="search" class="hide">Search</label>
  <input id="search" type="search" class="input">
</form>
```

## Display None

Set display none with this utility. Use this with caution as it might cause accessibility issues depending on where it’s used.

```html
<div>Visible</div>
<div class="display-none">Hidden</div>
```

