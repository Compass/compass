
# Custom Builds

<p class="h3">
  Basscss is a collection of interoperable CSS modules
  and can be used in conjunction with many other frameworks, libraries, and stylesheets.
</p>

# Future CSS
Basscss is written in spec-compliant CSS with bleeding edge features and uses [cssnext](https://cssnext.github.io/) to transpile to CSS that is compatible with today’s browsers. Basscss can also be transpiles with [Rework](https://github.com/reworkcss/rework). To learn more about using future CSS features, see the [Future CSS Guide](/docs/guides/css4).


# Bassplate
The quickest way to start customizing Basscss is through the official boilerplate project
[Bassplate](//github.com/basscss/bassplate),
which includes scripts and basic file and folder structure for building a simple website.

To get started, clone the repo, install dependencies, and run the start script.

```bash
git clone https://github.com/basscss/bassplate.git new-project
cd new-project
rm -rf .git
npm install
npm start
```

This will start a server at `http://localhost:8080` and watch the `/src` folder for changes.
Edit the files in `/src/css` to customize the compiled stylesheet.


# Npm Packages

All individual Basscss modules are available on npm.


# Importing files

Basscss uses npm to manage its CSS modules. Cssnext automatically inlines files with the following syntax.
If you’re using Rework or Myth, be sure to use the `rework-npm` plugin to correctly import files.

To import modules that have been installed through npm, use the following syntax:

```css
@import 'basscss-base-typography';
@import 'basscss-defaults';
```

To import modules relative to the parent file, use this syntax:

```css
@import './custom-buttons';
```

Import custom properties (variables) last. Just as with other CSS declarations, whatever is last in the source code is used.

```css
@import 'basscss-utility-layout';
@import './variables';
```


# Sass
Although Basscss is written in spec-compliant CSS4,
you can also incorporate it into an existing Sass project with the [css-to-scss](https://github.com/jxnblk/css-scss) transpiled partials in the [`basscss-sass`](https://github.com/basscss/basscss-sass) repo. Be sure to include the variables file `basscss-sass/defaults` before all other partials.

```scss
@import: 'basscss-sass/defaults';
@import: 'basscss-sass/utility-layout';
```

To override the default values, include your own variable definitions before Basscss.

```scss
// Custom variables
@import: 'variables';

// Basscss
@import: 'basscss-sass/defaults';
@import: 'basscss-sass/utility-layout';
```

## Bower
Although Basscss’s individual modules are distributed through npm, the core package is available through Bower, which also contains the compiled CSS.

```bash
bower install basscss
```


