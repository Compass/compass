require 'sass/plugin'

class Compass::SassCompiler

  include Compass::Actions

  attr_writer :logger
  attr_reader :quiet
  attr_reader :error_count
  attr_accessor :config
  attr_accessor :display_compilation_times
  attr_accessor :working_path
  attr_accessor :only_sass_files

  def initialize(options = {}, config = Compass.configuration)
    options = options.dup
    self.config = config
    self.display_compilation_times = options.delete(:time)
    self.working_path = options.delete(:working_path) || Dir.pwd
    self.only_sass_files = options.delete(:only_sass_files) || []
    @quiet = options[:quiet]
    plugin_options = config.to_sass_plugin_options.merge(options)
    if only_sass_files.any?
      plugin_options[:template_location] = []
      plugin_options[:load_paths] = config.sass_load_paths
    end
    plugin_options[:always_update] = true if options.delete(:force)
    plugin_options[:compass] ||= {}
    plugin_options[:compass][:logger] = logger
    @compiler = Sass::Plugin::Compiler.new(plugin_options)
    @start_times = {}
    @error_count = 0

    public_methods(true).grep(/^when_/).each do |callback|
      @compiler.send(callback.to_s.sub(/^when_/, 'on_')) {|*args| send(callback, *args) }
    end
  end

  def compile!
    @compiler.update_stylesheets(individual_files)
  end

  def watch!(options = {}, &block)
    skip_initial_update = options.fetch(:skip_initial_update, false)
    begin
      @compiler.watch(individual_files, options.merge(:skip_initial_update => skip_initial_update), &block)
    rescue Sass::SyntaxError => e
      skip_initial_update = true
      retry
    end
  end

  def individual_files
    only_sass_files.map {|sass_file| [sass_file, corresponding_css_file(sass_file)]}
  end

  def clean!
    @compiler.clean(individual_files)
  end

  def file_list
    @compiler.file_list(individual_files)
  end

  def when_updating_stylesheets(individual_files)
    @start_times = {}
    @error_count = 0
  end

  def when_compilation_starting(sass_file, css, sourcemap)
    @start_times[sass_file] = Time.now
  end

  def when_template_created(sass_file)
    logger.record :created, relativize(sass_file)
  end

  def when_template_deleted(sass_file)
    logger.record :deleted, relativize(sass_file)
  end

  def when_template_modified(sass_file)
    logger.record :modified, relativize(sass_file)
  end

  def when_updated_stylesheet(sass_file, css, sourcemap)
    if css && display_compilation_times && @start_times[sass_file]
      duration = ((Time.now - @start_times[sass_file]) * 1000).round / 1000.0
      logger.record :write, "#{relativize(css)} (#{duration}s)"
    else
      logger.record :write, relativize(css) if css
    end
    config.run_stylesheet_saved(css) if css

    logger.record :write, relativize(sourcemap) if sourcemap
    config.run_sourcemap_saved(sourcemap) if sourcemap
  end

  def when_creating_directory(dirname)
    logger.record :directory, relativize(dirname)
  end

  def when_deleting_css(filename)
    logger.record :delete, relativize(filename)
    config.run_stylesheet_removed(filename) if filename
  end

  def when_deleting_sourcemap(filename)
    logger.record :delete, relativize(filename)
    config.run_sourcemap_removed(filename) if filename
  end

  def when_compilation_error(error, sass_file, css_file, sourcemap_file)
    @error_count += 1
    if error.respond_to?(:sass_filename)
      error_filename = error.sass_filename || sass_file
      if relativize(error_filename) == relativize(sass_file)
        logger.record :error, "#{relativize(sass_file)} (Line #{error.sass_line}: #{error.message})"
      else
        logger.record :error, "#{relativize(sass_file)} (Line #{error.sass_line} of #{relativize(error_filename)}: #{error.message})"
      end
    else
      logger.record :error, "#{relativize(sass_file)} (#{error.backtrace.first}: #{error.message})"
    end
    config.run_stylesheet_error(sass_file, error.message)
  end

  def logger
    @logger ||= Compass::Logger.new(:quiet => quiet)
  end

  def corresponding_css_file(sass_file)
    "#{config.css_path}/#{stylesheet_name(sass_file)}.css"
  end

  def stylesheet_name(sass_file)
    if sass_file.index(config.sass_path) == 0
      sass_file[(config.sass_path.length + 1)..-6].sub(/\.css$/,'')
    else
      raise Compass::Error, "Individual stylesheets must be in the sass directory."
    end
  end

  def sass_files(options = {})
    @compiler.template_location_array.map do |(sass_dir, css_dir)|
      glob = options[:include_partials] ?
               File.join("**","*.s[ac]ss*") :
               File.join("**","[^_]*.s[ac]ss*")
      Dir.glob(File.join(sass_dir, glob))
    end.flatten
  end
end
