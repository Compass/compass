require File.join(File.dirname(__FILE__), 'base')

module Compass
  module Commands
    class InstallRails < Base
      def initialize(working_directory, options)
        super(working_directory, options)
      end
      def perform
        set_install_location
        set_output_location
        directory options[:stylesheets_location]
        template 'project/screen.sass', "#{options[:stylesheets_location]}/screen.sass", options
        template 'project/print.sass',  "#{options[:stylesheets_location]}/print.sass", options
        template 'project/ie.sass',     "#{options[:stylesheets_location]}/ie.sass", options
        write_file projectize('config/initializers/compass.rb'), initializer_contents
        if has_application_layout?
          next_steps
        else
          write_file projectize('app/views/layouts/application.html.haml'), application_layout_contents
        end
      end
      
      def initializer
        init_file = 
        if File.exists?(init_file) && !options[:force]
          msg = "File #{basename(init_file)} already exists. Run with --force to force project creation."
          raise ::Compass::Exec::ExecError.new(msg)
        end
        if File.exists?(init_file)
          print_action :overwrite, basename(init_file)
        else
          print_action :create, basename(init_file)
        end
        output = open(init_file,'w')
        output.write(initializer_contents)
        output.close
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

      def project_directory
        working_directory
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
