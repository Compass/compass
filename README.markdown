# Compass

Build Status: ![Build Status](https://secure.travis-ci.org/chriseppstein/compass.png)

A [Sass][sass]-based CSS Meta-Framework that allows you to mix and match any of the following CSS frameworks:

- [Compass Core][compass_core_website] - [Wiki Documentation][compass_core_wiki]
- [Blueprint][blueprint_website] - [Wiki Documentation][bleuprint_wiki]
- [960][ninesixty_website] - [Wiki Documentation][ninesixty_wiki]
- [Susy][susy_website] - [Wiki Documentation][susy_wiki]
- [YUI][yui_website] - [Wiki Documentation][yui_wiki]
- New frameworks and extensions are [tracked on the wiki][plugins_wiki] as they are created.
- Other frameworks can be added relatively easily. Create your own!

## Compass Provides

1. A [command line tool][command_line_wiki] for managing your Sass projects.
2. Simple integration with [Ruby-on-Rails][ruby_on_rails_wiki], [Merb][merb_wiki], [StaticMatic][static_matic_wiki], and even [non-ruby application servers][command_line_wiki].
3. Loads of Sass mixins to make building your website a snap.

## Quick Start

    $ (sudo) gem install compass
    $ compass create my_compass_project --using blueprint
    $ cd my_compass_project
    $ compass watch

## More Information
Please see the [wiki][wiki]

## Author
Compass is written by [Chris Eppstein][chris_eppstein].<br>
Chris is the Software Architect of [Caring.com][caring.com] and a member of the [Sass][sass] core team.

## License
Copyright (c) 2008-2009 Christopher M. Eppstein<br>
All Rights Reserved.<br>
Released under a [slightly modified MIT License][license].

[sass]: http://sass-lang.com/ "Syntactically Awesome StyleSheets"
[compass_core_website]: http://github.com/chriseppstein/compass/tree/master/frameworks/compass
[compass_core_wiki]: http://github.com/chriseppstein/compass/wikis/compass-core-documentation
[blueprint_website]: http://blueprintcss.org/
[bleuprint_wiki]: http://github.com/chriseppstein/compass/wikis/blueprint-documentation
[yui_website]: http://developer.yahoo.com/yui/grids/
[yui_wiki]: http://github.com/chriseppstein/compass/wikis/yui-documentation
[plugins_wiki]: http://github.com/chriseppstein/compass/wikis/compass-plugins
[ninesixty_website]: http://960.gs/
[ninesixty_wiki]: http://github.com/chriseppstein/compass/wikis/960gs-documentation
[command_line_wiki]: http://wiki.github.com/chriseppstein/compass/command-line-tool
[wiki]: http://github.com/chriseppstein/compass/wikis/home
[ruby_on_rails_wiki]: http://wiki.github.com/chriseppstein/compass/ruby-on-rails-integration
[merb_wiki]: http://wiki.github.com/chriseppstein/compass/merb-integration
[static_matic_wiki]: http://wiki.github.com/chriseppstein/compass/staticmatic-integration
[chris_eppstein]: http://chriseppstein.github.com
[caring.com]: http://www.caring.com/ "Senior Care Resources"
[license]: http://github.com/chriseppstein/compass/tree/master/LICENSE.markdown
[susy_website]: http://www.oddbird.net/susy/
[susy_wiki]: http://github.com/chriseppstein/compass/wikis/susy-documentation 