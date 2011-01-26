module Compass
  module Installers
    class Base
    end
    class ManifestInstaller < Base
    end
  end

  module AppIntegration
    module Rails    
      class Installer < Compass::Installers::ManifestInstaller

        def completed_configuration
          config = {}
          config[:sass_dir] = prompt_sass_dir unless sass_dir_without_default
          config[:css_dir] = prompt_css_dir unless css_dir_without_default
          config unless config.empty?
        end

        def write_configuration_files(config_file = nil)
          config_file ||= targetize('config/compass.rb')
          unless File.exists?(config_file)
            directory File.dirname(config_file)
            write_file config_file, config_contents
          end
          unless rails3?
            directory File.dirname(targetize('config/initializers/compass.rb'))
            write_file targetize('config/initializers/compass.rb'), initializer_contents
          end
        end

        def rails3?
          File.exists?(targetize('config/application.rb'))
        end

        def prepare
          write_configuration_files
        end

        def gem_config_instructions
          if rails3?
            %Q{Add the following to your Gemfile:\n\n    gem "compass", ">= #{Compass::VERSION}"}
          else
            %Q{Add the following to your environment.rb:\n\n    config.gem "compass", :version => ">= #{Compass::VERSION}"}
          end
        end

        def finalize(options = {})
          if options[:create]
            puts <<-NEXTSTEPS

Congratulations! Your rails project has been configured to use Compass.
Just a couple more things left to do.

#{gem_config_instructions}

Then, make sure you restart your server.

Sass will automatically compile your stylesheets during the next
page request and keep them up to date when they change.
NEXTSTEPS
          end
          unless options[:prepare]
            if manifest.has_stylesheet?
              puts "\nNow add these lines to the head of your layout(s):\n\n"
              puts stylesheet_links
            end
          end
        end

        def hamlize?
          # XXX Is there a better way to detect haml in a particular rails project?
          require 'haml'
          true
        rescue LoadError
          false
        end

        def install_location_for_html(to, options)
          separate("public/#{pattern_name_as_dir}#{to}")
        end

        def prompt_sass_dir
          if rails3?
            nil
          else
            recommended_location = separate('app/stylesheets')
            default_location = separate('public/stylesheets/sass')
            print %Q{Compass recommends that you keep your stylesheets in #{recommended_location}
  instead of the Sass default location of #{default_location}.
  Is this OK? (Y/n) }
            answer = $stdin.gets.downcase[0]
            answer == ?n ? default_location : recommended_location
          end
        end

        def prompt_css_dir
          if rails3?
            nil
          else
            recommended_location = separate("public/stylesheets/compiled")
            default_location = separate("public/stylesheets")
            puts
            print %Q{Compass recommends that you keep your compiled css in #{recommended_location}/
  instead the Sass default of #{default_location}/.
  However, if you're exclusively using Sass, then #{default_location}/ is recommended.
  Emit compiled stylesheets to #{recommended_location}/? (Y/n) }
            answer = $stdin.gets
            answer = answer.downcase[0]
            answer == ?n ? default_location : recommended_location
          end
        end

        def config_contents
          project_path, Compass.configuration.project_path = Compass.configuration.project_path, nil
          ("# This configuration file works with both the Compass command line tool and within Rails.\n" +
           Compass.configuration.serialize)
        ensure
          Compass.configuration.project_path = project_path
        end

        def initializer_contents
          %Q{require 'compass'
            |require 'compass/app_integration/rails'
            |Compass::AppIntegration::Rails.initialize!
            |}.gsub(/^\s+\|/,'')
        end

        def stylesheet_prefix
          if css_dir.length >= 19
            "#{css_dir[19..-1]}/"
          else
            nil
          end
        end

        def stylesheet_links
          if hamlize?
            haml_stylesheet_links
          else
            html_stylesheet_links
          end
        end

        def haml_stylesheet_links
          html = "%head\n"
          manifest.each_stylesheet do |stylesheet|
            # Skip partials.
            next if File.basename(stylesheet.from)[0..0] == "_"
            ss_line = "  = stylesheet_link_tag '#{stylesheet_prefix}#{stylesheet.to.sub(/\.s[ac]ss$/,'.css')}'"
            if stylesheet.options[:media]
              ss_line += ", :media => '#{stylesheet.options[:media]}'"
            end
            if stylesheet.options[:condition]
              ss_line = "  /[if #{stylesheet.options[:condition]}]\n  " + ss_line
            end
            html << ss_line + "\n"
          end
          html
        end
        def html_stylesheet_links
          html = "<head>\n"
          manifest.each_stylesheet do |stylesheet|
            # Skip partials.
            next if File.basename(stylesheet.from)[0..0] == "_"
            ss_line = "<%= stylesheet_link_tag '#{stylesheet_prefix}#{stylesheet.to.sub(/\.s[ac]ss$/,'.css')}'"
            if stylesheet.options[:media]
              ss_line += ", :media => '#{stylesheet.options[:media]}'"
            end
            ss_line += " %>"
            if stylesheet.options[:condition]
              ss_line = "<!--[if #{stylesheet.options[:condition]}]>" + ss_line + "<![endif]-->"
            end
            html << "  #{ss_line}\n"
          end
          html << "</head>"
          html
        end
      end
    end
  end
end
