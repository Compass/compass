module Compass
  module Commands
    class Base
      attr_accessor :working_directory, :options
      def initialize(working_directory, options)
        self.working_directory = working_directory
        self.options = options
      end
      
      def perform
        raise StandardError.new("Not Implemented")
      end

      protected
      
      def projectize(path)
        File.join(project_directory, separate(path))
      end
      # create a directory and all the directories necessary to reach it.
      def directory(subdir, options = nil)
        options ||= self.options
        dir = subdir ? projectize(subdir) : project_directory
        if File.exists?(dir) && File.directory?(dir) && options[:force]
            print_action :exists, basename(dir) + File::SEPARATOR
        elsif File.exists?(dir) && File.directory?(dir)
          msg = "Directory #{basename(dir)} already exists. Run with --force to force project creation."
          raise ::Compass::Exec::ExecError.new(msg)
        elsif File.exists?(dir)
          msg = "#{basename(dir)} already exists and is not a directory."
          raise ::Compass::Exec::ExecError.new(msg)
        else
          print_action :directory, basename(dir) + File::SEPARATOR
          FileUtils.mkdir_p(dir) unless options[:dry_run]
        end          
      end

      # copy/process a template in the compass template directory to the project directory.
      def template(from, to, options)
        to = projectize(to)
        from = File.join(templates_directory, separate(from))
        if File.exists?(to) && !options[:force]
          #TODO: Detect differences & provide an overwrite prompt
          msg = "#{basename(to)} already exists."
          raise ::Compass::Exec::ExecError.new(msg)
        elsif File.exists?(to)
          print_action :remove, basename(to)
          FileUtils.rm to unless options[:dry_run]
        end
        print_action :create, basename(to)
        FileUtils.cp from, to unless options[:dry_run]
      end

      def write_file(file_name, contents)
        if File.exists?(file_name) && !options[:force]
          msg = "File #{basename(file_name)} already exists. Run with --force to force creation."
          raise ::Compass::Exec::ExecError.new(msg)
        end
        if File.exists?(file_name)
          print_action :overwrite, basename(file_name)
        else
          print_action :create, basename(file_name)
        end
        output = open(file_name,'w')
        output.write(contents)
        output.close
      end

      # returns the path to the templates directory and caches it
      def templates_directory
        @templates_directory ||= File.expand_path(File.join(File.dirname(__FILE__), separate("../../../frameworks/#{options[:framework]}/templates")))
      end

      # Write paths like we're on unix and then fix it
      def separate(path)
        path.gsub(%r{/}, File::SEPARATOR)
      end
      
      def basename(file, extra = 0)
        if file.length > (working_directory.length + extra)
          file[(working_directory.length + extra + 1)..-1]
        else
          File.basename(file)
        end
      end
      
      ACTIONS = [:directory, :exists, :remove, :create, :overwrite]
      MAX_ACTION_LENGTH = ACTIONS.inject(0){|memo, a| [memo, a.to_s.length].max}
      def print_action(action, extra)
        puts "#{' ' * (MAX_ACTION_LENGTH - action.to_s.length)}#{action} #{extra}" if !options[:quiet] || options[:dry_run]
      end
      
    end
  end
end