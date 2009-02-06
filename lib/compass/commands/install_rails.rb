require File.join(File.dirname(__FILE__), 'base')
require File.join(File.dirname(__FILE__), 'create_project')

module Compass
  module Commands
    class InstallRails < CreateProject
      def initialize(*args)
        super        
      end

      def perform
        set_install_location
        set_output_location
        directory options[:stylesheets_location]
        framework_templates.each do |t|
          template "project/#{t}", "#{options[:stylesheets_location]}/#{t}", options
        end
        write_file 'config/initializers/compass.rb', initializer_contents
        if has_application_layout?
          next_steps
        else
          write_file 'app/views/layouts/application.html.haml', application_layout_contents
        end
      end
      
      def initializer_contents
        %Q{require 'compass'
# If you have any compass plugins, require them here.
Sass::Plugin.options[:template_location] = {
  "\#{RAILS_ROOT}#{File::SEPARATOR}#{options[:stylesheets_location]}" => "\#{RAILS_ROOT}#{File::SEPARATOR}#{options[:css_location]}"
}
Compass::Frameworks::ALL.each do |framework|
  Sass::Plugin.options[:template_location][framework.stylesheets_directory] = "\#{RAILS_ROOT}#{File::SEPARATOR}#{options[:css_location]}"
end
}
      end

      def application_layout_contents
        %Q{!!! XML
!!!
%html{:xmlns => "http://www.w3.org/1999/xhtml", "xml:lang" => "en", :lang => "en"}
  %head
    %meta{'http-equiv' => "content-type", :content => "text/html;charset=UTF-8"}
    %title= @browser_title || 'Default Browser Title'
    = stylesheet_link_tag '#{stylesheet_prefix}screen.css', :media => 'screen, projection'
    = stylesheet_link_tag '#{stylesheet_prefix}print.css', :media => 'print'
    /[if IE]
      = stylesheet_link_tag '#{stylesheet_prefix}ie.css', :media => 'screen, projection'
  %body
    %h1 Welcome to Compass
    = yield
}
      end

      def next_steps
        puts <<NEXTSTEPS

Congratulations! Your project has been configured to use Compass.
Next add these lines to the head of your application.html.haml:

%head 
  = stylesheet_link_tag '#{stylesheet_prefix}screen.css', :media => 'screen, projection'
  = stylesheet_link_tag '#{stylesheet_prefix}print.css', :media => 'print'
  /[if IE]
    = stylesheet_link_tag '#{stylesheet_prefix}ie.css', :media => 'screen, projection'

(you are using haml, aren't you?)
NEXTSTEPS
      end

      def has_application_layout?
        File.exists?(projectize('app/views/layouts/application.rhtml')) ||
        File.exists?(projectize('app/views/layouts/application.html.erb')) ||
        File.exists?(projectize('app/views/layouts/application.html.haml'))
      end

      def stylesheet_prefix
        if options[:css_location].length >= 19
          "#{options[:css_location][19..-1]}/"
        else
          nil
        end
      end

      def set_install_location
        print "Compass recommends that you keep your stylesheets in app/stylesheets/ instead of the Sass default location of public/stylesheets/sass/.\nIs this OK? (Y/n) "
        answer = gets
        self.options[:stylesheets_location] = separate(answer.downcase[0] == ?n ? 'public/stylesheets/sass' : 'app/stylesheets')
      end
      def set_output_location
        print "\nCompass recommends that you keep your compiled css in public/stylesheets/compiled/ instead the Sass default of public/stylesheets/.\nHowever, if you're exclusively using Sass, then public/stylesheets/ is recommended.\nEmit compiled stylesheets to public/stylesheets/compiled? (Y/n) "
        answer = gets
        self.options[:css_location] = separate(answer.downcase[0] == ?n ? 'public/stylesheets' : 'public/stylesheets/compiled')
      end
    end
  end
end
