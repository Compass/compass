module Compass
  module Actions

    attr_writer :logger

    def logger
      @logger ||= Logger.new
    end

    # copy/process a template in the compass template directory to the project directory.
    def copy(from, to, options = nil)
      options ||= self.options if self.respond_to?(:options)
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
      options ||= self.options if self.respond_to?(:options)
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
      options ||= self.options if self.respond_to?(:options)
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