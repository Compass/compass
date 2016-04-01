
Immutable padding utilities are based on a global white space scale defined with custom properties.
These can dramatically help reduce the size of large stylesheets and allow for greater flexibility and quicker iteration when designing in the browser.

## Naming Convention

Due to the ubiquitous nature of setting padding,
these utilities use a shorthand naming convention.

<div class="overflow-scroll">
  <table class="mb2 table-flush table-light">
    <thead>
      <tr> <th>Shorthand</th> <th>Description</th> </tr>
    </thead>
    <tbody>
      <tr> <td>p</td> <td>Padding</td> </tr>
      <tr> <td>t</td> <td>Top</td> </tr>
      <tr> <td>r</td> <td>Right</td> </tr>
      <tr> <td>b</td> <td>Bottom</td> </tr>
      <tr> <td>l</td> <td>Left</td> </tr>
      <tr> <td>x</td> <td>X-axis (left and right)</td> </tr>
      <tr> <td>y</td> <td>Y-axis (top and bottom)</td> </tr>
      <tr> <td>n</td> <td>Negative (margin only)</td> </tr>
      <tr> <td>0</td> <td>0 reset</td> </tr>
      <tr> <td>1</td> <td>--space-1 (default .5rem)</td> </tr>
      <tr> <td>2</td> <td>--space-2 (default 1rem)</td> </tr>
      <tr> <td>3</td> <td>--space-3 (default 2rem)</td> </tr>
      <tr> <td>4</td> <td>--space-4 (default 4rem)</td> </tr>
    </tbody>
  </table>
</div>

Padding utilities are only available in symmetrical orientations.
This is to normalize the spacing used around elements and maintain a consistent visual rhythm.

```css
.p0  { padding: 0 }
.pt0 { padding-top: 0 }
.pr0 { padding-right: 0 }
.pb0 { padding-bottom: 0 }
.pl0 { padding-left: 0 }
.px0 { padding-left: 0; padding-right:  0 }
.py0 { padding-top: 0;  padding-bottom: 0 }

.p1  { padding:        var(--space-1) }
.pt1 { padding-top:    var(--space-1) }
.pr1 { padding-right:  var(--space-1) }
.pb1 { padding-bottom: var(--space-1) }
.pl1 { padding-left:   var(--space-1) }
.py1 { padding-top:    var(--space-1); padding-bottom: var(--space-1) }
.px1 { padding-left:   var(--space-1); padding-right:  var(--space-1) }

.p2  { padding:        var(--space-2) }
.pt2 { padding-top:    var(--space-2) }
.pr2 { padding-right:  var(--space-2) }
.pb2 { padding-bottom: var(--space-2) }
.pl2 { padding-left:   var(--space-2) }
.py2 { padding-top:    var(--space-2); padding-bottom: var(--space-2) }
.px2 { padding-left:   var(--space-2); padding-right:  var(--space-2) }

.p3  { padding:        var(--space-3) }
.pt3 { padding-top:    var(--space-3) }
.pr3 { padding-right:  var(--space-3) }
.pb3 { padding-bottom: var(--space-3) }
.pl3 { padding-left:   var(--space-3) }
.py3 { padding-top:    var(--space-3); padding-bottom: var(--space-3) }
.px3 { padding-left:   var(--space-3); padding-right:  var(--space-3) }

.p4  { padding:        var(--space-4) }
.pt4 { padding-top:    var(--space-4) }
.pr4 { padding-right:  var(--space-4) }
.pb4 { padding-bottom: var(--space-4) }
.pl4 { padding-left:   var(--space-4) }
.py4 { padding-top:    var(--space-4); padding-bottom: var(--space-4) }
.px4 { padding-left:   var(--space-4); padding-right:  var(--space-4) }
```

## Box

To create a simple box component, use padding along with color utilities.

```html
<div class="p2 bg-white border rounded">
  A simple box
</div>
```

```html
<div class="overflow-hidden border rounded">
  <div class="p2 bold white bg-blue">
    Panel Header
  </div>
  <div class="p2">
    Panel Body
  </div>
  <div class="p2 bg-silver">
    Panel Footer
  </div>
</div>
```

<span class="red">Padding should never be declared outside of these utilities.</span>
This is meant to help create consistency and avoid magic numbers.
If, for some reason, the default white space scale does not suit your design, customize and extend it before use.

