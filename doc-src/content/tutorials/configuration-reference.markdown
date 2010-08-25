---
title: Configuration Reference
layout: tutorial
classnames:
  - tutorial
---
# Configuration Reference

The compass configuration file is a ruby file, which means that we can do some
clever things if we want to. But don’t let it frighten you; it’s really quite
easy to set up your project.

## Basic format

Most configuration properties are a simple assignment to a configuration property.
For example:

    css_dir = "stylesheets"

Most configuration properties have a value that is a “basic” type. There are three
basic types that can be set to a property:

* **String** – Text is surrounded by either single or double quotes.
  E.g. `"this is a string"`
* **Symbol** – A symbol starts with a colon and has no spaces in it.
  Symbols are used to represent values where the set of possible values are limited.
  E.g. `:foo` or `:foo_bar_baz`
* **Boolean** – `true` or `false`

There are two kinds of composite values:

* **Array** – An Array is a comma delimited list of basic values surrounded by
  square brackets. E.g. `["one", "two", "three"]`.
* **Hash** – A Hash is an association or mapping of one value to another.
  It is a comma delimited list of associations surrounded by curly brackets.
  An association is two values separated by `=>`. E.g. `{:foo => "aaa", :bar => "zzz"}`

## Comments

Use the hash sign `#` to comment out everything from the hash sign to the end
of the line.

## Import Note for Windows Users

The backslash character (`\`) is a special character in a string delimited by
double quotes (`"`). If you are working with folders in your paths, you should
either use **single quotes** to delimit your strings or escape your backslash
by doubling it like `"some\\path"`.

## Loading Compass Plugins

Compass relies on the ruby `require` mechanism to load other libraries of code.
To load a compass-compatible plugin, simply require it at the top of your
configuration file. If you used the -r option to access another library at project
creation time, this will already be set up for you.

Example:

    require 'ninesixty'
    require 'susy'

## Overriding Configuration Settings

When using the compass command line, configuration options that you set on the
command line will override the corresponding settings in your configuration file.

## Configuration Properties

<table> 
	<tr> 
		<th>Property Name</th> 
		<th>Type </th> 
		<th>Description </th> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>project_type</code> </td> 
		<td style="vertical-align:top;">Symbol </td> 
		<td style="vertical-align:top;">Can be <code>:stand_alone</code> or
		  <code>:rails</code>. Defaults to <code>:stand_alone</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>environment</code> </td> 
		<td style="vertical-align:top;">Symbol </td> 
		<td style="vertical-align:top;">The environment mode.
		  Defaults to <code>:production</code>, can also be <code>:development</code>
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>project_path</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">Not needed in <code>:stand_alone</code> mode
		  where it can be inferred by context. Sets the path to the root of the project.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>http_path</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The path to the project when running within the
		  web server. Defaults to <code>"/"</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>css_dir</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The directory where the css stylesheets are kept.
		  It is relative to the <code>project_path</code>.
		  Defaults to <code>"stylesheets"</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>css_path</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The full path to where css stylesheets are kept.
		  Defaults to <code>&lt;project_path&gt;/&lt;css_dir&gt;</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>http_stylesheets_path</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The full http path to stylesheets on the web server. Defaults to <code>http_path + "/" + css_dir</code>. </td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>sass_dir</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The directory where the sass stylesheets are kept.
		  It is relative to the <code>project_path</code>. Defaults to <code>"src"</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>sass_path</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The full path to where sass stylesheets are kept.
		  Defaults to <code>&lt;project_path&gt;/&lt;sass_dir&gt;</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>images_dir</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The directory where the images are kept.
		  It is relative to the <code>project_path</code>.
		  Defaults to <code>"images"</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>images_path</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The full path to where images are kept.
		  Defaults to <code>&lt;project_path&gt;/&lt;images_dir&gt;</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>http_images_path</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The full http path to images on the web server.
		  Defaults to <code>http_path + "/" + images_dir</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>javascripts_dir</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The directory where the javascripts are kept.
		  It is relative to the <code>project_path</code>. Defaults to
		  <code>"javascripts"</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>javascripts_path</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The full path to where javascripts are kept.
		  Defaults to <code>&lt;project_path&gt;/&lt;javascripts_dir&gt;</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>http_javascripts_path</code> </td> 
		<td style="vertical-align:top;">String </td> 
		<td style="vertical-align:top;">The full http path to javascripts on the web server.
		  Defaults to <code>http_path + "/" + javascripts_dir</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>output_style</code> </td> 
		<td style="vertical-align:top;">Symbol </td> 
		<td style="vertical-align:top;">The output style for the compiled css.
		  One of: <code>:nested</code>, <code>:expanded</code>, <code>:compact</code>,
		  or <code>:compressed</code>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>relative_assets</code> </td> 
		<td style="vertical-align:top;">Boolean </td> 
		<td style="vertical-align:top;">Indicates whether the compass helper functions
		  should generate relative urls from the generated css to assets, or absolute urls
		  using the http path for that asset type.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>additional_import_paths</code> </td> 
		<td style="vertical-align:top;">Array of Strings </td> 
		<td style="vertical-align:top;">Other paths on your system from which to import
		  sass files. See the <code>add_import_path</code> function for a simpler
		  approach.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>sass_options</code> </td> 
		<td style="vertical-align:top;">Hash </td> 
		<td style="vertical-align:top;">These options are passed directly to the
		  Sass compiler. For more details on the format of sass options, please read the
		  <a href="http://sass-lang.com/docs/yardoc/SASS_REFERENCE.md.html#options">sass options documentation</a>.
		</td> 
	</tr> 
	<tr> 
		<td style="vertical-align:top;"><code>line_comments</code> </td> 
		<td style="vertical-align:top;">Boolean </td> 
		<td style="vertical-align:top;">Indicates whether line comments should be added
		  to compiled css that says where the selectors were defined. Defaults to false
		  in production mode, true in development mode.
		</td> 
	</tr> 
</table>

## Configuration Functions

**`add_import_path`** – Call this function to add a path to the list of sass import
paths for your compass project. E.g.:

    add_import_path "/Users/chris/work/shared_sass"

---

**`asset_host`** – Pass this function a block of code that will define the asset
host url to be used. The block must return a string that starts with a protocol
(E.g. http). The block will be passed the root-relative url of the asset.
For example, this picks one of four asset hosts numbered 0-3, depending on
the name of the asset:

    asset_host do |asset|
      "http://assets%d.example.com" % (asset.hash % 4)
    end

By default there is no asset host used. When `relative_assets` is true
the asset host configuration is ignored.

---

**`asset_cache_buster`** – Pass this function a block of code that defines the
cache buster strategy to be used. The block must return nil or a string that can
be appended to a url as a query parameter. The returned string must not include
the starting `?`. The block will be passed the root-relative url of the asset.
If the block accepts two arguments, it will also be passed a path
that points to the asset on disk — which may or may not exist.

    # Increment the deploy_version before every release to force cache busting.
    deploy_version = 1
    asset_cache_buster do |http_path, real_path|
      if File.exists?(real_path)
        File.mtime(real_path).strftime("%s") 
      else
        "v=#{deploy_version}"
      end
    end
