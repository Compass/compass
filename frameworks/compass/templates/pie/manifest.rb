description "Integration with http://css3pie.com/"

file 'PIE.htc', :like => :css
stylesheet 'pie.scss', :erb => true

help %Q{
CSS PIE is a javascript library that progressively enhances
Internet Explorer to render many modern CSS capabilities
wherever possible. To install:

  compass install compass/pie

This will install an example stylesheet and a PIE.htc behavior file
that must be loaded into your pages for IE.
This file must be delivered with the following mime-type:

  Content-Type: text/x-component

For more information see:
  http://css3pie.com/

CSS PIE is written by and copyright to: Jason Johnston

Compass is using css3pie version 1.0-beta3. It can be upgraded by downloading
a newer behavior file and replacing the one that comes with compass.
}

welcome_message %Q{
The PIE.htc file must be delivered with the following mime-type:

  Content-Type: text/x-component

Please ensure that your webserver is properly configured.

Unfornately, due to the suckiness of IE, PIE does not work with relative assets.

For more information see:
  http://css3pie.com/
}
