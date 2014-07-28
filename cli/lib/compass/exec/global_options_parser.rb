module Compass::Exec::GlobalOptionsParser
  def set_options(opts)
    super
    set_global_options(opts)
  end
  def set_global_options(opts)
    opts.on('-r LIBRARY', '--require LIBRARY',
            "Require the given ruby LIBRARY before running commands.",
            "  This is used to access compass plugins without having a",
            "  project configuration file."
      ) do |library|
        ::Compass.configuration.require library
      end

    opts.on('-l FRAMEWORK_DIR', '--load FRAMEWORK_DIR',
            "Load the framework or extensions found in the FRAMEWORK directory."
      ) do |framework_dir|
        require 'pathname'
        ::Compass.configuration.load Pathname.new(framework_dir).realpath
      end

    opts.on('-L FRAMEWORKS_DIR', '--load-all FRAMEWORKS_DIR',
            "Load all the frameworks or extensions found in the FRAMEWORKS_DIR directory."
      ) do |frameworks_dir|
        require 'pathname'
        ::Compass.configuration.discover Pathname.new(frameworks_dir).realpath
      end

    opts.on('-I IMPORT_PATH', '--import-path IMPORT_PATH',
            "Makes files under the IMPORT_PATH folder findable by Sass's @import directive."
      ) do |import_path|
        require 'pathname'
        ::Compass.configuration.add_import_path Pathname.new(import_path).realpath
      end

    opts.on('-q', '--quiet', :NONE, 'Quiet mode.') do
      self.options[:quiet] = true
    end

    opts.on('--trace', :NONE, 'Show a full stacktrace on error') do
      self.options[:trace] = true
    end

    opts.on('--force', :NONE, 'Allows compass to overwrite existing files.') do
      self.options[:force] = true
    end

    opts.on('--boring', :NONE, 'Turn off colorized output.') do
      self.options[:color_output] = false
    end

    opts.on_tail("-?", "-h", "--help", "Show this message") do
      puts opts
      exit
    end

  end

end
