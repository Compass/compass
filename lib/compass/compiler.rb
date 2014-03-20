module Compass
  class Compiler

    include Actions

    attr_accessor :working_path, :from, :to, :options, :sass_options, :staleness_checker, :importer

    def initialize(working_path, from, to, options)
      self.working_path = working_path.to_s
      self.from, self.to = File.expand_path(from), to
      self.logger = options.delete(:logger)
      sass_opts = options.delete(:sass) || {}
      self.options = options
      self.sass_options = options.dup
      self.sass_options.delete(:quiet)
      self.sass_options.update(sass_opts)
      self.sass_options[:cache_location] ||= determine_cache_location
      self.sass_options[:importer] = self.importer = Sass::Importers::Filesystem.new(from)
      self.sass_options[:compass] ||= {}
      self.sass_options[:compass][:logger] = self.logger
      self.sass_options[:compass][:environment] = Compass.configuration.environment
      self.staleness_checker = Sass::Plugin::StalenessChecker.new(sass_options)
    end

    def determine_cache_location
      Compass.configuration.cache_path || Sass::Plugin.options[:cache_location] || File.join(working_path, ".sass-cache")
    end

    def sass_files(options = {})
      exclude_partials = options.fetch(:exclude_partials, true)
      @sass_files = self.options[:sass_files] || Dir.glob(separate("#{from}/**/#{'[^_]' if exclude_partials}*.s[ac]ss"))
    end

    def relative_stylesheet_name(sass_file)
      sass_file[(from.length + 1)..-1]
    end

    def stylesheet_name(sass_file)
      if sass_file.index(from) == 0
        sass_file[(from.length + 1)..-6].sub(/\.css$/,'')
      else
        raise Compass::Error, "You must compile individual stylesheets from the project directory."
      end
    end

    def css_files
      @css_files ||= sass_files.map{|sass_file| corresponding_css_file(sass_file)}
    end

    def corresponding_css_file(sass_file)
      "#{to}/#{stylesheet_name(sass_file)}.css"
    end

    def target_directories
      css_files.map{|css_file| File.dirname(css_file)}.uniq.sort.sort_by{|d| d.length }
    end

    # Returns the sass file that needs to be compiled, if any.
    def out_of_date?
      sass_files.zip(css_files).each do |sass_filename, css_filename|
        return sass_filename if needs_update?(css_filename, sass_filename)
      end
      false
    end

    def needs_update?(css_filename, sass_filename)
      staleness_checker.stylesheet_needs_update?(css_filename, File.expand_path(sass_filename), importer)
    end

    # Determines if the configuration file is newer than any css file
    def new_config?
      config_file = Compass.detect_configuration_file
      return false unless config_file
      config_mtime = File.mtime(config_file)
      css_files.each do |css_filename|
        return config_file if File.exists?(css_filename) && config_mtime > File.mtime(css_filename)
      end
      nil
    end

    def clean!
      remove options[:cache_location]
      css_files.each do |css_file|
        remove css_file
      end
    end

    def run
      failure_count = 0
      if new_config?
        # Wipe out the cache and force compilation if the configuration has changed.
        remove options[:cache_location] if options[:cache_location]
        options[:force] = true
      end

      # Make sure the target directories exist
      target_directories.each {|dir| directory dir}

      # Compile each sass file.
      result = timed do
        sass_files.zip(css_files).each do |sass_filename, css_filename|
          begin
            compile_if_required sass_filename, css_filename
          rescue Sass::SyntaxError => e
            failure_count += 1
            handle_exception(sass_filename, css_filename, e)
          end
        end
      end
      if options[:time]
        puts "Compilation took #{(result.__duration * 1000).round / 1000.0}s"
      end
      return failure_count
    end

    def compile_if_required(sass_filename, css_filename)
      if should_compile?(sass_filename, css_filename)
        compile sass_filename, css_filename
      else
        logger.record :unchanged, basename(sass_filename) unless options[:quiet]
      end
    end

    def timed
      start_time = Time.now
      res = yield
      end_time = Time.now
      res.instance_variable_set("@__duration", end_time - start_time)
      def res.__duration
        @__duration
      end
      res
    end

    # Compile one Sass file
    def compile(sass_filename, css_filename)
      css_content = logger.red do
        timed do
          engine(sass_filename, css_filename).render
        end
      end
      duration = options[:time] ? "(#{(css_content.__duration * 1000).round / 1000.0}s)" : ""
      write_file(css_filename, css_content, options.merge(:force => true, :extra => duration))
      Compass.configuration.run_stylesheet_saved(css_filename)
    end

    def should_compile?(sass_filename, css_filename)
      options[:force] || needs_update?(css_filename, sass_filename)
    end

    # A sass engine for compiling a single file.
    def engine(sass_filename, css_filename)
      syntax = (sass_filename =~ /\.(s[ac]ss)$/) && $1.to_sym || :sass
      opts = sass_options.merge(:filename => sass_filename, :css_filename => css_filename, :syntax => syntax)
      Sass::Engine.new(File.read(sass_filename), opts)
    end

    # Place the syntax error into the target css file,
    # formatted to display in the browser (in development mode)
    # if there's an error.
    def handle_exception(sass_filename, css_filename, e)
      exception_file = basename(e.sass_filename)
      file = basename(sass_filename)
      exception_file = nil if exception_file == file
      formatted_error = "(Line #{e.sass_line}#{ " of #{exception_file}" if exception_file}: #{e.message})"
      logger.record :error, file, formatted_error
      Compass.configuration.run_stylesheet_error(sass_filename, formatted_error)
      write_file css_filename, error_contents(e, sass_filename), options.merge(:force => true)
    end

    # Haml refactored this logic in 2.3, this is backwards compatibility for either one
    def error_contents(e, sass_filename)
      if Sass::SyntaxError.respond_to?(:exception_to_css)
        e.sass_template = sass_filename
        Sass::SyntaxError.exception_to_css(e, :full_exception => show_full_exception?)
      else
        Sass::Plugin.options[:full_exception] ||= show_full_exception?
        Sass::Plugin.send(:exception_string, e)
      end
    end

    # We don't want to show the full exception in production environments.
    def show_full_exception?
      Compass.configuration.environment == :development
    end

  end
end
