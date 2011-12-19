---
title: Creating Compass Extensions
layout: tutorial
classnames:
  - tutorial
---
Compass Extensions
==================

Compass, at its heart, is a framework upon which sass-based stylesheet frameworks
are built. It provides the tools for building, installing and using reusable
stylesheets that provide anything from full-fledged layout frameworks to designs
for widgets or even full page designs. All using the power of sass to keep the
semantic meaning of the html pages clear and free of design details.

This document describes the compass extension toolset so that you can build
your own compass extension.

Basic Extension Layout
----------------------

<pre>
<strong>my_extension</strong>
|
|- <strong>stylesheets</strong> (this directory will be on the sass load path)
|  |
|  |- my_extension (not technically required, but it's good to scope imports by the name of the extension)
|  |  |
|  |  |- _module_one.sass (this file would be imported using <code>@import my_extension/module_one.sass</code>)
|  |  |- _module_two.sass (this file would be imported using <code>@import my_extension/module_two.sass</code>)
|  |  |- ...
|  |
|  |- _my_extension.sass (This file will import the entire extension using <code>@import my_extension.sass</code>)
|
|- <strong>templates</strong> (this is where templates/patterns go)
|  |
|  |- <strong>project</strong> (this should be provided if you'd like people to be able to base their project on the extension)
|  |  |
|  |  |- <strong>manifest.rb</strong> (this file should declare the contents of the template)
|  |  |- screen.sass (this would be the main stylesheet, importing from your extension and demonstrating its use)
|  |  |- print.sass (this file would set up basic print styles)
|  |  |- ie.sass (if you want, you can provide custom styles for IE)
|  |
|  |- some_pattern
|     |
|     |- <strong>manifest.rb</strong>
|     |- some.sass (some sass is probably in order, always import from the extension library as much as possible)
|     |- some_script.js (yes, you can provide javascript code)
|     |- some_image.png (and images)
|     |- some_content.html.haml (and even html and haml)
|     |- some_other_file.txt (and other arbitrary files)
|
|- <strong>lib</strong> (optional ruby code)
   |
   |- <strong>my_extension.rb</strong> (this code can register your framework if you deviate from conventions and require sass extensions, etc.)
   |
   |- my_extension
      |
      |- sass_extensions.rb (this is the standard location to place sass functions)
</pre>

Names in <strong>bold</strong> are part of the extension naming convention.

Generating an Extension
-----------------------

If you want a leg up to get started working on your extension,
you can use compass to generate an extension with the following command:

    compass create my_extension --using compass/extension 

This will create a few basic files and folders to get you started.

If you prefer to use the scss syntax for your extension run the following command instead:

    compass create my_extension --using compass/extension -x scss

Advanced Layout Options
-----------------------

### Library File Location

The extension library file referenced above as `my_extension/lib/my_extension.rb`
can actually be stored at any of the following three locations:

1. `my_extension/compass_init.rb`
2. `my_extension/lib/my_extension.rb` (NOTE: You must use this one if you're distributing as a rubygem.)
3. `my_extension/my_extension.rb`

The first of those locations found (in the above order) will be loaded.
The compass_init.rb file takes priority, so that extensions that want to work
differently as compass extensions than they do as normal ruby libraries,
have a way of targeting compass.

<a name="registration"></a>
### Stylesheet and Template Locations

If you'd like to store your stylesheets and/or templates in a non-standard location within your extension,
you must provide a library file and register the extension explicitly like so:

    base_directory  = File.join(File.dirname(__FILE__), '..')
    stylesheets_dir = File.join(base_directory, 'my', 'stylesheets')
    templates_dir   = File.join(base_directory, 'my', 'templates')
    Compass::Frameworks.register('my_extension', :stylesheets_directory => stylesheets_dir, :templates_directory => templates_dir)

If you're following the standard naming convention, but the stylesheet and
template directories are not at the top level, you can just do this instead:

    # path from the library file to where you're keeping your compass stuff.
    base_directory  = File.join(File.dirname(__FILE__), '..', 'compass')
    Compass::Frameworks.register('my_extension', :path => base_directory)

### Adding Configuration Options to Compass

For details on how to add new configuration options to compass [read this](/help/tutorials/extending/#adding-configuration-properties).

Conventions to Follow
---------------------

The following are not required, but are standards that your framework
should attempt to adhere to unless there's a good reason not to do so.

1. Have a single import for your framework.
2. Break up your framework into modules so that people can import just smaller
   pieces for faster load times when they're not using everything.
3. Use partials (files starting with an underscore) for stylesheets that are meant
   to be imported. If you do not Sass will generate css
   files for your libraries in some configurations.
4. Provide a project template. If you do not, your project should only be
   providing widgets or page designs, etc.

Building a Template (a.k.a. Pattern)
====================================

Manifest Files
--------------

The manifest file declares the template contents and tells compass information
about the files in the template.

### An Example Manifest File

    description "My awesome compass plugin."
    
    stylesheet 'screen.sass', :media => 'screen, projection'
    stylesheet 'partials/_base.sass'
    stylesheet 'print.sass',  :media => 'print'
    stylesheet 'ie.sass',     :media => 'screen, projection', :condition => "lt IE 8"
    
    image 'grid.png'
    javascript 'script.js'
    
    html 'welcome.html.haml', :erb => true
    file 'README'
    
    help %Q{
    This is a message that users will see if they type
    
      compass help my_extension
    
    You can use it to help them learn how to use your extension.
    }
    
    welcome_message %Q{
    This is a message that users will see after they install this pattern.
    Use this to tell users what to do next.
    }
    

You may also see some real manifest files here:

* [blueprint](http://github.com/chriseppstein/compass/blob/master/frameworks/blueprint/templates/project/manifest.rb)
* [compass-css-lightbox](http://github.com/ericam/compass-css-lightbox/blob/master/templates/project/manifest.rb)

### Manifest Declarations


**Easy Mode:** If you just have some basic files and nothing fancy going on, simply place this line in your manifest:

    discover :all

If the file is missing `discover :all` is the default

This will cause compass to find all the files in your template and use the files' extension to determine where they should go. Alternatively, you can request that compass only discover files of a certain type. For example, the following will only discover javascript and image assets, you could then declare other file types on your own.

    discover :javascripts
    discover :images

The following types may be discovered: `:stylesheets`, `:images`, `:javascripts`, `:fonts`, `:html`, `:files`, and `:directories`

**Normal Mode:** There are seven kinds of manifest declarations:

1. `stylesheet` - Declares a sass file.
2. `image` - Declares an image.
3. `javascript` - Declares a javascript file.
4. `font` - Declares a font file.
5. `html` - Declares an html file.
6. `file` - Declares a random file.
7. `directory` - Declares a directory should be created.

All declarations take the path to the file as their first argument. Note that the
normal slash `/` can and should be used in a manifest. Compass will take care of
the cross platform issues. The path to the file will be reproduced in the user's
project, so please keep that in mind when creating folders. The location where
files are going to be installed is dictated by the user's project configuration,
however, a template can place things into subdirectories relative to those locations.

Common options:

* `:erb` - When set to true, the file will be processed via the ERB templating language.
  See the "Advanced Manifests" section below for more details.
* `:to` - The location where the file should be installed relative to the
  type-specific location.
* `:like` - Most often used with a `file` declaration, this option allows you to
  install into the location of another manifest type (and also :css). E.g. :like => :css

Stylesheet options:

* `:media` - this is used as a hint to the user about the media attribute of the
  stylesheet link tag.
* `:condition` - this is used to hint the user that a conditional comment should be
  used to import the stylesheet with the given condition.

Directory options:

* `:within` - where the directory should be created. If omitted, the directory
  will be relative to the project directory. Can be one of: the following
  * `sass_dir`
  * `javascripts_dir`
  * `fonts_dir`
  * `images_dir`

HTML files:

You can provide html as haml or as plain html. If you provide haml, the haml will be
converted to html when it is installed, unless the project allows haml files.
Providing html files is usually done to demonstrate how to use a more complicated
design and to get the user started off with working product.

### Advanced Manifests and Templates

* ERB Processing - This can be used to customize the contents of the file in an
  extension template. The template will be processed in the context of a
  TemplateContext instance, which gives you access to the full project configuration
  information as well as the command line options. Since it's unlikely many templates
  will need this functionality, I leave it as an exercise of the user to figure it out
  and if they can't to contact the compass-devs mailing list for assistance.
* `no_configuration_file!` - calling this method within the manifest will tell
  the installer to skip the creation of a configuration file.
* `skip_compilation!` - calling this method within the manifest will tell the
  installer to skip compilation of sass files to css.

Distributing Extensions as Ruby Gems
------------------------------------

Rubygems is a flexible, easy-to-use system for distributing ruby software.
If you have any questions about rubygems, I suggest that you start looking
for help [here](http://help.rubygems.org/).

The big advantages of using rubygems to distribute your extension is that
it allows your extension to be a dependency for other projects and that each
install is versioned, which makes supporting your extension easier.

Tips for Developing Extensions
------------------------------

* If you're developing a simple extension, you may find it convenient to place
  your extension within an existing compass project in the extension folder.
* Never specify an extension in your imports as this can cause issue when the
  syntax of a file changes.

Packaging an Extension as a RubyGem
-----------------------------------

You do not _have_ to make your extension a ruby gem. But if you do, you get some benefits you would not have otherwise:

* Releases
* Versions
* A standard way of asking your users what release they are using.
* Better integration with ruby-based projects via tools like
  [Bundler](http://gembundler.com/).

### Creating a Gem

Before you begin, please ensure you have gem version `1.3.6` or greater. `gem -v` will tell you the currently installed version.

1. Define your gemspec file at the top of your extension. Here's [an example of
   one](http://github.com/ericam/compass-css-lightbox/blob/master/css-lightbox.gemspec).
   The gemspec should have the same name as your gem.
2. Register your framework by adding `lib/my_extension.rb` and registering it:
   
       require 'compass'
       extension_path = File.expand_path(File.join(File.dirname(__FILE__), ".."))
       Compass::Frameworks.register('my_extension', :path => extension_path)
   
   This is how compass knows where to find your extension's files when a user requires it.
   For more options, go back up and read about [Stylesheet and Template Locations](#registration).
3. Build a gem: `gem build my_extension.gemspec`. This will build your gem file and
   add the current version to the name. E.g. `my_extension-0.0.1.gem`
4. Test your gem by installing it locally: `gem install my_extension-0.0.1.gem`

### Releasing a Gem

The ruby community is nice and will host your gem files for free. To release your gem:

    gem push my_extension-0.0.1.gem

Your ruby gem will be hosted on [rubygems.org](http://rubygems.org/).
Please familiarize yourself with [their documentation](http://rubygems.org/pages/gem_docs).

Installing Extensions
=====================

How extensions are installed varies according to the decisions you make about
how you are packaging and releasing your gem. There will be a standard approach
in a future release, but until then, it is suggested that you provide your users
with succinct installation instructions.

Installing Extensions Released as RubyGems
------------------------------------------

When creating a new project:

    sudo gem install my_extension
    compass create my_project -r my_extension --using my_extension

The `-r` option is annoying and will not be needed in a future version of compass.
But for now, it tells compass to find and load the extension from the local
rubygems repository.

To install via rubygems into an existing project:

    gem install my_extension
    # edit the project configuration file and add:
    require 'my_extension'
    compass install my_extension

Or if you have other patterns besides the project pattern:

    compass install my_extension/pattern

Installing Ad-hoc Extensions
----------------------------

Ad-hoc extensions are any set of files and folders following the basic conventions
described above. They could be installed via a zip file or by checking the code out
from source control. Ad-hoc extensions will be automatically found in the extensions
directory of a project and registered for import without needing a `require` statement
in the compass configuration file.

Currently, ad-hoc extensions can only be installed into the extensions directory
of an existing compass project. This will be fixed in a future release of compass.
Until then, you may need to instruct your users to create a bare project to get started:

    compass create my_project --bare

This will create a project directory, a sass directory (with no sass files) and a configuration file.

The standard location for extensions is `project_root/extensions` for stand-alone
projects and `project_root/vendor/plugins/compass_extensions` for rails projects.
Additionally, the user may customize their extensions directory by setting
`extensions_dir` in their compass configuration file.

To install into an existing project, simply place the extension into a project's
extension directory. This could be done via a git clone or by extracting an archive.
The name of the directory it creates should be the name of the extension. The project
will now have access to the extension.

Verifying that an Extension is Installed Correctly
--------------------------------------------------

The user can verify that they have access to your extension by typing:

    compass help

And they should see the framework in the list of available frameworks.
Alternatively, if you've provided a `help` message in the manifest, then
the user can type:

    compass help my_extension
    - or -
    compass help my_extension/pattern_name

*Note:* The user might need to provide the `-r` option to help in order for compass to
find a gem-based extension before a project exists. This is not needed for
extensions installed into the extensions directory, or if the project is already
required in the current directory's project configuration.

