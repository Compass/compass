
# Tips & Tricks

<p class="h3">
  Basscss is a versatile starting point for any project.
  These tips and tricks will help you build on top of its foundation
  in an elegant and maintainable way.
</p>

# Avoid Overrides

When using any front end framework you should avoid overriding the built in styles.
Customize default values in the framework with variables where possible.
If using variables doesn’t suite your needs,
consider adding styles that extend, but don't override, the defaults.

If you want to alter the defaults in the source code,
make adjustments to the declared properties and values
before beginning to use the framework and be sure to document any changes to the default behavior.
If you do make adjustments after the framework has been set up in a project,
be cautious and notify any other contributors of those changes.


# Utility Styles are Immutable

The utility styles in Basscss should be considered immutable. These styles aid in scalability,
maintenance, and readability by clearing stating what they do. For example, `.block` should always
set display block and do nothing else. This is similar to the concept of doing one thing and doing it well.
If a particular style or utility doesn’t suite the needs of the element it’s applied to,
remove it and replace it with more appropriate styles.


# Look Before Adding

Before writing any new styles on top of Basscss, check the source code or documentation to see
if there is already a style that will do what you need. Chances are, there is,
or there is a combination of styles that can acheive the same thing.


# Avoid Magic Numbers

The type scale and white space scale in Basscss are intended
to bring consistency and help normalize visual design considerations.
Type sizes should never be specified outside of the type scale,
and margins and paddings should all be handled with the white space utilities.
Making one-off adjustments to things like font sizes and margins can quickly lead to code bloat,
harder-to-read markup, and a less consistent designs.


# Don’t Use Contextual Selectors

Some approaches to CSS suggest adjusting styles with contextual selectors.
The styles in Basscss should never be contextually adjusted.
Doing so would break the readability of classes in markup and the ability
to make quick iterative adjustments.
One of the major advantages of Basscss’s approach is the clarity of reading classes in markup
and the portability of styles.
For example, your navigation might exist in the header element today,
but future design decisions may require moving elements around.

If you need to adjust a style in one particular place,
consider how you could make that style as reusable as possible and how those
adjustments could be made with a style extension.
For example, if you want the button in your site header to
be larger and a different color from other buttons in your site,
consider making extensions like `.button-bigger` and `.button-orange`.
This will help your future self and others understand
what the styles are doing without having to reference the CSS.


# Handle Complexity in Markup

Large projects will inevitably become more complex.
Handling and maintaining that complexity in markup templates
is much easier than adding complexity to your stylesheet.
Before abstracting combinations of styles out in to new styles,
make sure to look for patterns and think about reusability,
and consider ways in which your templating engine can DRY up your code.
If you’re constantly duplicating the same markup to create UI elements like
media player controls or modals,
make use of things like partials, helpers, or components to keep things maintainable.

If you’re adding something like a background image,
consider using inline styles if that image will only be used in one place.
There’s no need to send extra CSS to pages that don’t contain this background image.


# Keep Specificity Low

Keeping specificity consistently low in a stylesheet helps mitigate the need to override styles
with highly specific styles or the `!important` flag.
High specificity in a stylesheet should be considered a code smell
and generally leads to more problems than it solves.
Basscss keeps selector specificity as low as possible to ensure interoperability and portability.


# Don’t Nest Selectors

Don’t nest selectors. It may be tempting to add a style for a parent element and all child elements together,
for example `.list-navigation li a`,
but this creates a tight coupling between CSS and markup
and makes future adjustments more difficult and limits the portability of styles.
Nesting selectors can also add unnecessary specificity that might be difficult to compensate for in the future.


# Don’t Use IDs as Selectors

Never use IDs as CSS selectors. IDs are useful to reference parts of an HTML document,
and work well as speedy JavaScript selectors, but they have limited applications in CSS.
Because only one element ID exists per document, the reusability of styles with ID selectors is inheritly limited.
IDs also create excessive specificity that will trump the majority of Basscss’s styles.


# Separate Structure and Skin

Keep structure and skin separate. Properties like colors, backgrounds and borders
often differ by location, can change with the design over time, and don’t have a huge impact on page layout.
Keeping structural styles and skins decoupled aids in interoperability and design flexibility.

