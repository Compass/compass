module Compass
  module Installers

    class Base
      attr_accessor :template_path, :target_path, :working_path
      attr_accessor :options
      attr_accessor :manifest
      attr_accessor :logger
      attr_accessor :css_dir, :sass_dir, :images_dir, :javascripts_dir

      def initialize(template_path, target_path, options = {})
        @template_path = template_path
        @target_path = target_path
        @working_path = Dir.getwd
        @options = options
        @manifest = Manifest.new(manifest_file)
        configure_option_with_default :logger
      end

      def manifest_file
        @manifest_file ||= File.join(template_path, "manifest.rb")
      end

      # Runs the installer.
      # Every installer must conform to the installation strategy of configure, prepare, install, and then finalize.
      # A default implementation is provided for each step.
      def run
        configure
        prepare
        install
        finalize
      end

      # The default configure method -- it sets up directories from the options
      # and corresponding default_* methods for those not found in the options hash.
      # It can be overridden it or augmented for reading config files,
      # prompting the user for more information, etc.
      def configure
        [:css_dir, :sass_dir, :images_dir, :javascripts_dir].each do |opt|
          configure_option_with_default opt
        end
      end

      # The default prepare method -- it is a no-op.
      # Generally you would create required directories, etc.
      def prepare
      end

      def configure_option_with_default(opt)
        value = options[opt]
        value ||= begin
          default_method = "default_#{opt}".to_sym
          send(default_method) if respond_to?(default_method)
        end
        send("#{opt}=", value)
      end
  
      # The default install method. Calls install_<type> methods in the order specified by the manifest.
      def install
        manifest.each do |entry|
          send("install_#{entry.type}", entry.from, entry.to, entry.options)
        end
      end

      # The default finalize method -- it is a no-op.
      # This could print out a message or something.
      def finalize
      end


      def install_stylesheet(from, to, options)
        copy from, "#{sass_dir}/#{to}"
      end

      def install_image(from, to, options)
        copy from, "#{images_dir}/#{to}"
      end

      def install_script(from, to, options)
        copy from, "#{javascripts_dir}/#{to}"
      end

      def install_file(from, to, options)
        copy from, to
      end

      def default_logger
        Compass::Logger.new
      end

      # returns an absolute path given a path relative to the current installation target.
      # Paths can use unix style "/" and will be corrected for the current platform.
      def targetize(path)
        File.join(target_path, separate(path))
      end

      # returns an absolute path given a path relative to the current template.
      # Paths can use unix style "/" and will be corrected for the current platform.
      def templatize(path)
        File.join(template_path, separate(path))
      end

      # Write paths like we're on unix and then fix it
      def separate(path)
        path.gsub(%r{/}, File::SEPARATOR)
      end

      # copy/process a template in the compass template directory to the project directory.
      def copy(from, to, options = nil)
        options ||= self.options
        from = templatize(from)
        to = targetize(to)
        if File.exists?(to) && !options[:force]
          #TODO: Detect differences & provide an overwrite prompt
          msg = "#{basename(to)} already exists."
          raise InstallationError.new(msg)
        elsif File.exists?(to)
          logger.record :overwrite, basename(to)
          FileUtils.rm to unless options[:dry_run]
          FileUtils.cp from, to unless options[:dry_run]
        else
          logger.record :create, basename(to)
          FileUtils.cp from, to unless options[:dry_run]
        end
      end

      # create a directory and all the directories necessary to reach it.
      def directory(dir, options = nil)
        options ||= self.options
        dir = targetize(dir)
        if File.exists?(dir) && File.directory?(dir)
            logger.record :exists, basename(dir)
        elsif File.exists?(dir)
          msg = "#{basename(dir)} already exists and is not a directory."
          raise InstallationError.new(msg)
        else
          logger.record :directory, basename(dir)
          FileUtils.mkdir_p(dir) unless options[:dry_run]
        end          
      end

      def write_file(file_name, contents, options = nil)
        options ||= self.options
        file_name = targetize(file_name)
        if File.exists?(file_name) && !options[:force]
          msg = "File #{basename(file_name)} already exists. Run with --force to force creation."
          raise InstallationError.new(msg)
        end
        if File.exists?(file_name)
          logger.record :overwrite, basename(file_name)
        else
          logger.record :create, basename(file_name)
        end
        open(file_name,'w') do |file|
          file.write(contents)
        end
      end

      def basename(file)
        relativize(file) {|f| File.basename(file)}
      end
      
      def relativize(path)
        if path.index(working_path+File::SEPARATOR) == 0
          path[(working_path+File::SEPARATOR).length..-1]
        elsif block_given?
          yield path
        else
          path
        end
      end

    end
  end
end
