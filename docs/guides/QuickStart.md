
**This guide is a work in progress**

# Quick Start

<p class="h3">
  Basscss uses a different approach than many other CSS frameworks and libraries. This approach, along with things like the multiclass pattern, may seem odd at first, but it is key to writing and maintaining sensible CSS and avoiding unwanted side effects.
</p>

## Semantic Markup

As with any web project, start with well-structured semantic markup. This means using the elements that accurately describe the content.
The boilerplate `index.html` file in [Bassplate](https://github.com/basscss/bassplate) is a good place to start.

## Styling a Blog

As a quick demonstration of what Basscss can do, this guide will walk through putting together a simple blog template.

## Container

To keep the page from getting too wide and to give the page some margins, add a container div. `.container` sets a max-width and centers the element. `px2` means 2 units of padding on the x-axis (left and right).

```html
<div class="container px2">
</div>
```

## Page Header

Inside the container, add a page header.

```html
<header>
  <h1>Hamburger Blog</h1>
  <p>Musing on beef patties</p>
</header>
```

The title of the site is in an `h1` tag since its the highest level heading in the page's hierarchy. To keep the heading semantically correct and adjust the font size, add the `.h2` class to make it smaller.

```html
<h1 class="h2">Hamburger Blog</h1>
```

To make fine-tuned adjustments to the spacing between the `h1` and `p`, use margin white space utilities. `mt0` means margin-top 0, and `mb0` means margin-bottom 0.

```html
<header>
  <h1 class="h2 mb0">Hamburger Blog</h1>
  <p class="mt0">Musings on beef patties</p>
</header>
```

## Article

Below the page header, add a `main` element for the content of the page and an `article` element for the article.

```html
<main>
  <article>
  </article>
</main>
```

