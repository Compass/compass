module Compass
  module Commands
    module PreviewOptionsParser
      def set_options(opts)
        opts.banner = (<<BANNER)
Usage: compass preview [options] [path/to/file]

Description:
  Print compiled CSS.

  For examples:
    $ compass preview --syntax=sass ./my_sass.txt ./more_my_sass.txt

    or from STDIN

    $ echo '.pale { @include opaticy(0.3); }' | compass preview

Options: 
BANNER

        opts.on('--syntax=FILETYPE', "Syntax `sass` or `scss` (default: `scss`)") do |syntax|
          self.options[:syntax] = syntax
        end

        opts.on('-i LIBRARY', 'Import library (default: `compass`)') do |lib|
          (self.options[:imports] ||= []) << lib
        end

        super
      end
    end

    class Preview < Base

      register :preview

      def perform
      end

      class << self

        def option_parser(arguments)
          parser = Compass::Exec::CommandOptionParser.new(arguments)
          parser.extend(PreviewOptionsParser)
        end

        def usage
          option_parser([]).to_s
        end

        def description(command)
          "Preview compiled css."
        end

        def parse!(arguments)
          parser = option_parser(arguments)
          parser.parse!
          options = {
            :syntax => :scss,
            :from_stdin => File.pipe?(STDIN) || File.select([STDIN], [], [], 0) != nil,
            :imports => ["compass"],
          }.merge(parser.options)

          content = ""

          options[:imports].each do |lib|
            content << %Q(@import "#{lib}";\n)
          end

          content << STDIN.read if options[:from_stdin]
          arguments.each do |file|
            content << File.read(file)
          end

          print Sass::Engine.new(content, :syntax => options[:syntax], :load_paths => Compass.configuration.sass_load_paths).render
        end
      end
    end
  end
end
