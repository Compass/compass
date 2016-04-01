
# Future CSS Syntax

<p class="h3">
  Custom media queries and custom properties are powerful CSS features that
  provide more flexibility than similar features found in CSS preprocessors such as Sass and Less,
  with the potential for native browser support in the near future.
  With post-processors like [cssnext](https://cssnext.github.io) and [Rework](https://github.com/reworkcss/rework), you can start using these features today.
</p>

# Custom Properties

[Custom properties](http://dev.w3.org/csswg/css-variables/) are similar to variables in Sass and Less, but with a slightly different syntax.

## Defining Custom Properties

Although the specification allows defining custom properties with any selector, current post-processing tools require them to be declared in a rule with the `:root` selector. Note that custom property names are case-sensitive.

```css
:root {
  --blue: #0074d9;
}
```

Just as with other CSS properties, source order determines what value to use. Custom properties defined *later* in the source redefine earlier ones.

```css
:root {
  --blue: #f00;
  --blue: #0074d9; /* This value will be used */
}
```


## Using Custom Properties

To use custom properties in a declaration, use the `var()` syntax.

```css
.button-blue {
  color: white;
  background-color: var(--blue);
}
```

To define a fallback value, in case a variable has not been definied, separate the value with a comma. This works similarly to CSS font stacks.

```css
.button-blue {
  color: white;
  background-color: var(--blue, #0074d9);
}
```

Other variables can also be used as fallback values.

```css
.button-blue {
  color: white;
  background-color: var(--button-background-color, var(--blue), #0074d9);
}
```

Custom properties can also be defined based on other custom properties.

```css
:root {
  --blue: #0074d9;
  --button-background-color: var(--blue);
}
```

## Customizing Basscss

To adjust the default values, define custom properties after importing Basscss.

```css
@import 'basscss';

:root {
  --blue: #0088cc;
}
```


# Custom Media Queries

[W3C Custom Media Queries](http://dev.w3.org/csswg/mediaqueries/#custom-mq) allow using the same media query in multiple places, without the need to duplicate values across a stylesheet, and promote DRYer code.

## Defining Custom Media Queries

Use the `@custom-media` rule to define a custom media query.

```css
@custom-media --breakpoint-sm (min-width: 40em);
```

## Using Custom Media Queries

Use the extension-name within an `@media` rule to use the value.

```css
@media (--breakpoint-sm) {
  .sm-col { float: left }
}
```

# Other CSS features

Cssnext also supports these features:

- [The `color()` Function](http://dev.w3.org/csswg/css-color/#modifying-colors)
- [The `hwb()` Function](http://dev.w3.org/csswg/css-color/#the-hwb-notation)
- [The `gray()` Function](http://dev.w3.org/csswg/css-color/#grays)
- [Custom Selectors](http://dev.w3.org/csswg/css-extensions/#custom-selectors)
- [And more...](https://github.com/cssnext/cssnext#features)

