Compass Extensions
==================

Compass, at it's heart, is a framework upon which sass-based stylesheet frameworks are built. It provides the tools for building, installing and using reusable stylesheets that provide anything from full-fledged layout frameworks to designs for widgets or even full page designs. All using the power of sass to keep the semantic meaning of the html pages clear and free of design details.

This document describes the compass extension toolset so that you can build your own compass extension.

Basic Extension Layout
----------------------

<pre>
<strong>an_extension</strong>
|
|- <strong>stylesheets</strong> (this directory will be on the sass load path)
|  |
|  |- an_extension (not technically required, but it's good to scope imports by the name of the extension)
|  |  |
|  |  |- _module_one.sass (this file would be imported using <code>@import an_extension/module_one.sass</code>)
|  |  |- _module_two.sass (this file would be imported using <code>@import an_extension/module_two.sass</code>)
|  |  |- ...
|  |
|  |- _an_extension.sass (This file will import the entire extension using <code>@import an_extension.sass</code>)
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
   |- <strong>an_extension.rb</strong> (this code can register your framework if you deviate from conventions and require sass extensions, etc.)
   |
   |- an_extension
      |
      |- sass_extensions.rb (this is the standard location to place sass functions)
</pre>

Names in <strong>bold</strong> are part of the extension naming convention.

Generating an Extension
-----------------------

If you want a leg up to get started working on your extension, you can use compass to generate an extension with the following command:

    compass -p extension -n an_extension .

This will create a few basic files and folders to get you started, use the -n option to specify the name of your extension.

Advanced Layout Options
-----------------------

### Library File Location

The extension library file referenced above as `an_extension/lib/an_extension.rb` can actually be stored at any of the following three locations:

1. `an_extension/compass_init.rb`
2. `an_extension/lib/an_extension.rb`
3. `an_extension/an_extension.rb`

The first of those locations found (in the above order) will be loaded. The compass_init.rb file takes priority, so that extensions that want to work differently as compass extensions than they do as normal ruby libraries, have a way of targeting compass.

### Stylesheet and Template Locations

If you'd like to store your stylesheets and/or templates in a non-standard location within your extension,
you must provide a library file and register the extension explicitly like so:

    base_directory  = File.join(File.dirname(__FILE__), '..') # assuming you're in the lib directory
    stylesheets_dir = File.join(base_directory, 'my', 'stylesheets') # always use File.join for support on unix and windows
    templates_dir   = File.join(base_directory, 'my', 'templates') # always use File.join for support on unix and windows
    Compass::Frameworks.register('an_extension', :stylesheets_directory => stylesheets_dir, :templates_directory => templates_dir)

If you're following the standard naming convention, but the stylesheet and template directories are not at the top level, you can just do this instead:

    base_directory  = File.join(File.dirname(__FILE__), '..', 'compass') # path from the library file to where you're keeping your compass stuff.
    Compass::Frameworks.register('an_extension', :path => base_directory)

Conventions to Follow
---------------------

The following are not required, but are standards that your framework should attempt to adhere to unless there's a good reason not to do so.

1. Have a single import for your framework.
2. Break up your framework into modules so that people can import just smaller pieces for faster load times when they're not using everything.
3. Use partials (files starting with an underscore) for stylesheets that are meant to be imported. If you do not Sass will generate css
   files for your libaries in some configurations.
4. Provide a project template. If you do not, your project should only be providing widgets or page designs, etc.

Building a Template (a.k.a. Pattern)
====================================

Manifest Files
--------------

The manifest file declares the template contents and tells compass information about the files in the template.

### An Example Manifest File

    stylesheet 'screen.sass', :media => 'screen, projection'
    stylesheet 'partials/_base.sass'
    stylesheet 'print.sass',  :media => 'print'
    stylesheet 'ie.sass',     :media => 'screen, projection', :condition => "lt IE 8"
    
    image 'grid.png'
    javascript 'script.js'
    
    html 'welcome.html.haml', :erb => true
    file 'README'

### Manifest Declarations

There are five kinds of manifest declarations:

1. `stylesheet` - Declares a sass file.
2. `image` - Declares an image.
3. `javascript` - Declares a javascript file.
4. `html` - Declares an html file.
5. `file` - Decares a random file.

All declarations take the path to the file as their first argument. Note that the normal slash `/` can and should be used in a manifest. Compass will take care of the cross platform issues. The path to the file will be reproduced in the user's project, so please keep that in mind when creating folders. The location where files are going to be installed is dictated by the user's project configuration, however, a template can place things into subdirectories relative to

Common options:

* `:erb` - When set to true, the file will be processed via the ERB templating language. See the "Advanced Manifests" section below for more details.
* `:to` - The location where the file should be installed relative to the type-specific location.
* `:like` - Most often used with a `file` declaration, this option allows you to install into the location of another manifest type (and also :css). E.g. :like => :css

Stylesheet options:

* `:media` - this is used as a hint to the user about the media attribute of the stylesheet link tag.
* `:condition` - this is used to hint the user that a conditional comment should be used to import the stylesheet with the given condition.

HTML files:

You can provide html as haml or as plain html. If you provide haml, the haml will be converted to html when it is installed, unless the project allows haml files. Providing html files is usually done to demonstrate how to use a more complicated design and to get the user started off with working product.

### Advanced Manifests and Templates

* ERB Processing - This can be used to customize the contents of the file in an extension template. The template will be processed in the context of a TemplateContext instance, which gives you access to the full project configuration information as well as the command line options. Since it's unlikely many templates will need this functionality, I leave it as an exercise of the user to figure it out and if they can't to contact the compass-devs mailing list for assistance.
* `no_configuration_file!` - calling this method within the manifest will tell the installer to skip the creation of a configuration file.
* `skip_compilation!` - calling this method within the manifest will tell the installer to skip compilation of sass files to css.

Distributing Extensions as Ruby Gems
------------------------------------

How to build and distribute ruby gems is outside the scope of this document. But delivering an extension as a ruby gem makes it easier to manage software dependencies, install, and uninstall.

Tips for Developing Extensions
------------------------------

* If you're developing a simple extension, you may find it convenient to place your extension within an existing compass project in the extension folder.

Installing Extensions
---------------------

TBD: How to install extensions that are not managed via ruby gems and when there's no existing project. Maybe in ~/.compass/extensions?

TBD: How to install extensions for rails projects? Maybe in vendor/plugins/compass_extensions?

To install via ruby gems:

    sudo gem install an-extension
    compass -r `an_extension` -f an_extension my_project

To install into an existing project, simply place the extension into a project's extension directory. This could be done via a git clone or by extracting an archive.

To install via rubygems into an existing project:

    sudo gem install an-extension
    # edit the project configuration file and add:
    require 'an_extension'