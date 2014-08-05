module Compass
  module RailsHelper
    def generate_rails_app_directories(name)
      Dir.mkdir name
      Dir.mkdir File.join(name, "config")
      Dir.mkdir File.join(name, "config", "initializers")
      Dir.mkdir File.join(name, "tmp")
    end

    # Generate a rails application without polluting our current set of requires
    # with the rails libraries. This will allow testing against multiple versions of rails
    # by manipulating the load path.
    def generate_rails_app(name, dir = nil)
      if pid = fork
        Process.wait(pid)
        if $?.exitstatus == 2
          raise LoadError, "Couldn't load rails"
        elsif $?.exitstatus != 0
          raise "Failed to generate rails application."
        end
      else
        begin
          require 'action_pack/version'
          if ActionPack::VERSION::MAJOR >= 3
            require 'rails/generators'
            require 'rails/generators/rails/app/app_generator'
            require 'mocha'
            dir ||= File.join(File.expand_path('../../', __FILE__))
            args = [File.join(dir, name), '-q', '-f', '--skip-bundle', '--skip-gemfile']
            
            #stub this so you can generate more apps
            Rails::Generators::AppGenerator.any_instance.stubs(:valid_const?).returns(true)
            Rails::Generators::AppGenerator.start(args, {:destination_root => dir})
            
          else
            require 'rails/version'
            require 'rails_generator'
            require 'rails_generator/scripts/generate'
            Rails::Generator::Base.use_application_sources!
            capture_output do
              Rails::Generator::Base.logger = Rails::Generator::SimpleLogger.new $stdout
              Rails::Generator::Scripts::Generate.new.run([name], :generator => 'app')
            end
          end
        rescue LoadError
          Kernel.exit!(2)
        rescue => e
          $stderr.puts e
          Kernel.exit!(1)
        end
        Kernel.exit!(0)
      end
    end
  end
end
