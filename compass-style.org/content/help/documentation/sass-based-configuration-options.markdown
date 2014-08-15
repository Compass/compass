---
title: Sass-based Configuration Options
layout: documentation
classnames:
  - documentation
---
# Sass-based Configuration Options

Most of the options available in the Ruby-based configuration file are
used to configure the Sass compiler. These options cannot be configured
from within your Sass files.

However some Compass options are possible to set from within Sass
because they are only used to control how Compass's built-in functions
work. For example, url generation using `image-url()` and `font-url()`.

The options that can be set via Sass configuration are:

* `asset-cache-buster` - String, Function reference, or `null`. The function
  reference must accept two arguments (url path, filename) and can
  return either a string to be interpreted as a query parameter or a map
  containing the keys query and/or path mapped to a string. The string
  is a simple value to set as the query parameter on all urls, when
  `null`, the cache busting feature is disabled.
* `asset-host` - Function reference, or `null`. When `null` this feature
  is disabled (default). A referenced function must accept a single
  argument (the root relative url) and return a full url (starting with
  "http").
* `disable-warnings` - Boolean. When true, warnings will not be output.
* `fonts-dir` - String. Relative to project directory.
* `fonts-path` - String. Absolute path.
* `generated-images-dir` - String. Relative to project directory.
* `generated-images-path` - String. Absolute path.
* `http-fonts-dir` - String. Relative to project directory.
* `http-fonts-path` - String. Absolute path.
* `http-generated-images-dir` - String. Relative to http path.
* `http-generated-images-path` - String. Absolute path.
* `http-images-dir` - String. Relative to project directory.
* `http-images-path` - String. Absolute path.
* `http-path` - String. URL Prefix of all urls starting with '/'.
* `images-dir` - String. Relative to project directory.
* `images-path` - String. Absolute path.
* `relative-assets` - Boolean. When true, generate relative paths from
  the css file to the asset.

The have the same meaning as the corresponding options in the ruby
configuration format. However, there are some things that are different
that are worth explaining. 

## Working with paths.

Compass provides a function called `absolute-path` that will turn any
path relative to the sass file it is called from into an absolute path.
In order to make your stylesheets work on both windows and unix-based
var gulp = require('gulp');
var sass = require('gulp-ruby-sass');

gulp.task('default', function () {
    return gulp.src('src/scss/app.scss')
        .pipe(sass({sourcemap: true, sourcemapPath: '../scss'}))
        .on('error', function (err) { console.log(err.message); })
        .pipe(gulp.dest('dist/css'));
});operating systems, you should use the `join-file-segments` function
instead of a file separator.

For example. If your configuration partial was stored in a subdirectory
of your sass folder you would want to set `$project-path` to
`absolute-path(join-file-segments('..', '..'))`.

In some cases it is useful to parse a url or filename.
The function `split-filename($filename)` returns a triple of
`(directory, basename, extension)`. 

## Working with Function References

Some configuration options passed to compass accept a function
reference. This is an identifier that is the same name as a Sass
function defined in either Sass or Ruby. What arguments the function
accepts and should return depends on the particular configuration
property. For example:

    @function my-cache-buster($url, $file) {
      @return (query: "h=#{md5sum($file)}");
    }
    
    @include compass-configuration($asset-cache-buster: my-cache-buster);


## Configuration File Best Practices

It is suggested that all compass configuration performed from within
Sass should be kept in a single partial named `project-setup`. This file
should be imported into every Sass file that is to be used with Compass.


## Understanding the project setup file

    $project-path: absolute-path("..");

The global `$project-path` must be set to an absolute path to the
directory of the`project. This global is used to initial compass
when importing `compass/configuration`.

    $debug-configuration: true;

Causes compass to output useful debugging information about how it is
configured.

    @import "compass/configuration";

Initializes compass and makes some useful configuration utilities available.

        $compass-options: (http_path: "/");
        @include compass-configuration($compass-options);

Configures Compass according to your specific needs. If this mixin is
called more than once it will give you a warning. To reconfigure compass
with different options, pass `$reconfigure: true` to the
compass-configuration mixin.

