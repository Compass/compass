---
title: Production Stylesheets
layout: tutorial
classnames:
  - tutorial
---
Production Stylesheets
======================

See the [Configuration Reference](/help/tutorials/configuration-reference/) for a
complete list of available configuration options.

Strategies for Compiling Stylesheets for Production
---------------------------------------------------

**Option A:** Use the compass production defaults.

    compass compile -e production --force

*Note:* This only changes the compass defaults, options you've specified explicitly
in your configuration will not be changed.

**Option B:** Override your configuration file settings on the command line  

    compass compile --output-style compressed --force

**Option C:** Create a separate configuration file for production

    cp config.rb prod_config.rb
    
    ..edit prod_config.rb to suit  your needs..
    
    compass compile -c prod_config.rb --force

