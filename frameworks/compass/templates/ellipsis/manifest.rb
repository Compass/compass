description "Plugin for cross-browser ellipsis truncated text."

file 'xml/ellipsis.xml', :like => :css
stylesheet 'ellipsis.sass'

help %Q{
First, install the plugin to get the xml file that makes this work in firefox:

  compass install compass/ellipsis

Then @include "ellipsis" into your selectors to enable ellipsis
there when text gets too long.

The ellipsis.sass file is just an example for how to use this plugin,
feel free to delete it.

For more information see:
  http://mattsnider.com/css/css-string-truncation-with-ellipsis/
}

welcome_message %Q{
The ellipsis.sass file is just an example for how to use this plugin,
feel free to delete it.

For more information see:
  http://mattsnider.com/css/css-string-truncation-with-ellipsis/  
}