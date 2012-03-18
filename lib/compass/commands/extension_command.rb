require 'fileutils'
require 'compass/commands/base'

module Compass
  module Commands
    module ExtensionsOptionParser
      def set_options(opts)
        opts.banner = %Q{
Usage: compass extension install EXTENSION_NAME [options]
       compass extension uninstall EXTENSION_NAME [options]
       compass extension list

Description:
  Manage the list of extensions on your system.
  Compass to all of your compass projects.

Example:
  compass extension install sassy-buttons
  compass extension uninstall sassy-buttons

}
        super
      end
    end

    class ExtensionCommand < Base

      register :extension

      class << self
        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(ExtensionsOptionParser)
        end
        def usage
          option_parser([]).to_s
        end
        def description(command)
          "Manage the list of compass extensions on your system"
        end
        def parse!(arguments)
          {:arguments => arguments}
        end
      end
      include InstallerCommand

      def initialize(working_path, options)
        super(working_path, options)
      end

      # all commands must implement perform
      def perform
        require 'rubygems/gem_runner'
        Gem::GemRunner.new.run(options[:arguments])
      end

    end
  end
end

