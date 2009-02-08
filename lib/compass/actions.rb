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
        raise Compass::FilesystemConflict.new(msg)
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
        raise Compass::FilesystemConflict.new(msg)
      else
        logger.record :directory, separate("#{basename(dir)}/")
        FileUtils.mkdir_p(dir) unless options[:dry_run]
      end          
    end

    # Write a file given the file contents as a string
    def write_file(file_name, contents, options = nil)
      options ||= self.options if self.respond_to?(:options)
      if File.exists?(file_name) && !options[:force]
        msg = "File #{basename(file_name)} already exists. Run with --force to force creation."
        raise Compass::FilesystemConflict.new(msg)
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

    # Compile one Sass file
    def compile(sass_filename, css_filename, options)
      logger.record :compile, basename(sass_filename)
      if File.exists?(css_filename)
        logger.record :overwrite, basename(css_filename)
      else
        logger.record :create, basename(css_filename)
      end
      engine = ::Sass::Engine.new(open(sass_filename).read,
                                  :filename => sass_filename,
                                  :line_comments => options[:environment] == :development,
                                  :style => options[:style],
                                  :css_filename => css_filename,
                                  :load_paths => options[:load_paths])
      css_content = engine.render
      open(css_filename,'w') {|output| output.write(css_content)} unless options[:dry_run]
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

    # Write paths like we're on unix and then fix it
    def separate(path)
      path.gsub(%r{/}, File::SEPARATOR)
    end

    # Removes the trailing separator, if any, from a path.
    def strip_trailing_separator(path)
      (path[-1..-1] == File::SEPARATOR) ? path[0..-2] : path
    end

  end
end