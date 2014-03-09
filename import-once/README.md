# Import Once

This plugin changes the behavior of Sass's `@import` directive so that
if the same sass file is imported more than once, the second import
will be a no-op. This allows dependencies to behave how most people
expect them to behave and provides a considerable performance improvement
for some sass projects.

**Note**: Although this plugin is maintained by compass, it can be used
without compass in any Sass-based project.

## Installation

Either add this line to your application's Gemfile if you have one:

    gem 'compass-import-once', :require => 'compass/import-once/activate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install compass-import-once

## Usage

To use with the Sass command line:

```
sass -r 'compass/import-once/activate' ...
```

To enable in non-compass environments there's two options:

    require 'compass/import-once/activate'

or you can activate it conditionally:

    require 'compass/import-once'
    Compass::ImportOnce.activate!

## Forcing an Import

If a file must be imported a second time, you can force it by adding an
exclamation mark to the end of the import url. E.g.


```scss
@import "something";
@import "something!"; // this will be imported again.
```
