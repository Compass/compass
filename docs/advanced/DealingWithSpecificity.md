
# Dealing with Specificity

In some stylesheets with high-specificity selectors, you may want Basscss styles to override the existing ones.
Using the [postcss-importantly](https://github.com/XXXVII/postcss-importantly) plugin will add `!important` to each declaration.
By using an `!important` declaration, these styles will also override inline styles.

Use this plugin with caution. This is only recommended for use when needed and with basic utility styles such as those found in Basscss.

As a convenience, a compiled version of Basscss with `!important` declarations is available in the npm module or via CDN.

## PostCSS example

```css
@import 'basscss/css/basscss-important.css';
```

## Webpack example

```js
import basscssImportant from 'basscss/css/basscss-important.css'
```

## CDN

```html
<link href="https://npmcdn.com/basscss@8.0.0/css/basscss-important.css" rel="stylesheet">
```

