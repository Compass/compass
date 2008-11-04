require 'optparse'
require 'rubygems'
require 'haml'

module Compass
  module Exec
    class ExecError < StandardError
    end


    def report_error(e, options)
      $stderr.puts "#{e.class} on line #{get_line e} of #{get_file e}: #{e.message}"
      if options[:trace]
        e.backtrace[1..-1].each { |t| $stderr.puts "  #{t}" }
      else
        $stderr.puts "Run with --trace to see the full backtrace"
      end
    end

    def get_file(exception)
      exception.backtrace[0].split(/:/, 2)[0]
    end

    def get_line(exception)
      # SyntaxErrors have weird line reporting
      # when there's trailing whitespace,
      # which there is for Haml documents.
      return exception.message.scan(/:(\d+)/)[0] if exception.is_a?(::Haml::SyntaxError)
      exception.backtrace[0].scan(/:(\d+)/)[0]
    end
    module_function :report_error, :get_file, :get_line

    class Compass
      
      attr_accessor :args, :options, :opts

      def initialize(args)
        self.args = args
        self.options = {}
      end

      def run!
        begin
          parse!
          perform!
        rescue Exception => e
          raise e if e.is_a? SystemExit
          if e.is_a?(ExecError) || e.is_a?(OptionParser::ParseError)
            $stderr.puts e.message
          else
            ::Compass::Exec.report_error(e, @options)
          end
          exit 1
        end
        exit 0
      end
      
      protected
      
      def perform!
        if options[:command]
          do_command(options[:command])
        else
          puts self.opts
        end
      end
      
      def parse!
        self.opts = OptionParser.new(&method(:set_opts))
        self.opts.parse!(self.args)    
        if ARGV.size > 0
          self.options[:project_name] = ARGV.shift
        end
        self.options[:command] ||= self.options[:project_name] ? :create_project : :update_project
        self.options[:environment] ||= :production
        self.options[:framework] ||= :compass
      end
      
      def set_opts(opts)
        opts.banner = <<END
Usage: compass [options] [project]

Description:
  When project is given, generates a new project of that name as a subdirectory of
  the current directory.
  
  If you change any source files, you can update your project using --update.

Options:
END
        opts.on('-u', '--update', :NONE, 'Update the current project') do
          self.options[:command] = :update_project
        end

        opts.on('-w', '--watch', :NONE, 'Monitor the current project for changes and update') do
          self.options[:command] = :watch_project
        end

        opts.on('-f FRAMEWORK', '--framework FRAMEWORK', [:compass, :blueprint], 'Set up a new project using the selected framework. Legal values: compass (default), blueprint') do |framework|
          self.options[:framework] = framework
        end

        opts.on('-e ENV', '--environment ENV', [:development, :production], 'Use sensible defaults for your current environment: development, production (default)') do |env|
          self.options[:environment] = env
        end

        opts.on('-s STYLE', '--output-style STYLE', [:nested, :expanded, :compact, :compressed], 'Select a CSS output mode (nested, expanded, compact, compressed)') do |style|
          self.options[:style] = style
        end
        
        opts.on('--rails', "Install compass into your Ruby on Rails project found in the current directory.") do
          self.options[:command] = :install_rails
        end

        opts.on('-q', '--quiet', :NONE, 'Quiet mode.') do
          self.options[:quiet] = true
        end

        opts.on('--dry-run', :NONE, 'Dry Run. Tells you what it plans to do.') do
          self.options[:dry_run] = true
        end

        opts.on('--trace', :NONE, 'Show a full traceback on error') do
          self.options[:trace] = true
        end
        
        opts.on('--force', :NONE, 'Force. Allows some commands to succeed when they would otherwise fail.') do
          self.options[:force] = true
        end

        opts.on('--imports', :NONE, 'Emit an import path suitable for use with the Sass command-line tool.') do
          #XXX cross platform support?
          print ::Compass::Frameworks::ALL.map{|f| f.stylesheets_directory}.join(File::PATH_SEPARATOR)
          exit
        end

        opts.on_tail("-?", "-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "Print version") do
          self.options[:command] = :print_version
        end
      end
      
      def do_command(command)
        require File.join(File.dirname(__FILE__), 'commands', command.to_s)
        command_class_name = command.to_s.split(/_/).map{|p| p.capitalize}.join('')
        command_class = eval("::Compass::Commands::#{command_class_name}")
        command_class.new(Dir.getwd, options).perform
      end

    end
  end
end
