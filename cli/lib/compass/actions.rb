module Compass
  module Actions

    attr_writer :logger

    def logger
      @logger ||= ::Compass::Logger.new
    end

    # copy/process a template in the compass template directory to the project directory.
    def copy(from, to, options = nil, binary = false)
      options ||= self.options if self.respond_to?(:options)
      if binary
        contents = File.new(from,"rb").read
      else
        contents = File.new(from).read
      end  
      write_file to, contents, options, binary
    end

    # create a directory and all the directories necessary to reach it.
    def directory(dir, options = nil)
      options ||= self.options if self.respond_to?(:options)
      options ||= {}
      if File.exists?(dir) && File.directory?(dir)
          # do nothing
      elsif File.exists?(dir)
        msg = "#{basename(dir)} already exists and is not a directory."
        raise Compass::FilesystemConflict.new(msg)
      else
        log_action :directory, separate("#{basename(dir)}/"), options
        FileUtils.mkdir_p(dir)
      end
    end

    # Write a file given the file contents as a string
    def write_file(file_name, contents, options = nil, binary = false)
      options ||= self.options if self.respond_to?(:options)
      skip_write = false
      contents = process_erb(contents, options[:erb]) if options[:erb]
      if File.exists?(file_name)
        existing_contents = IO.read(file_name)
        if existing_contents == contents
          log_action :identical, basename(file_name), options
          skip_write = true
        elsif options[:force]
          log_action :overwrite, basename(file_name), options
        else
          msg = "File #{basename(file_name)} already exists. Run with --force to force overwrite."
          raise Compass::FilesystemConflict.new(msg)
        end
      else
        log_action :create, basename(file_name), options
      end
      if skip_write
        FileUtils.touch file_name
      else
        mode = "w"
        mode << "b" if binary
        open(file_name, mode) do |file|
          file.write(contents)
        end
      end
    end

    def process_erb(contents, ctx = nil)
      ctx = Object.new.instance_eval("binding") unless ctx.is_a? Binding
      ERB.new(contents).result(ctx)
    end

    def remove(file_name)
      file_name ||= ''
      if File.directory?(file_name)
        FileUtils.rm_rf file_name
        log_action :remove, basename(file_name)+"/", options
      elsif File.exists?(file_name)
        File.unlink file_name
        log_action :remove, basename(file_name), options
      end
    end

    def basename(file)
      relativize(file) {|f| File.basename(file)}
    end

    def relativize(path)
      path = File.expand_path(path)
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

    def log_action(action, file, options)
      quiet = !!options[:quiet]
      quiet = false if options[:loud] && options[:loud] == true
      quiet = false if options[:loud] && options[:loud].is_a?(Array) && options[:loud].include?(action)
      unless quiet
        logger.record(action, file, options[:extra].to_s)
      end
    end
  end
end
