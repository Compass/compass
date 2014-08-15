require 'pathname'
module Compass::Core::SassExtensions::Functions::Configuration
  extend Compass::Core::SassExtensions::Functions::SassDeclarationHelper

  # Users who need to support windows and unix paths in their configuration
  # should construct them with this helper function.
  def join_file_segments(*segments)
    quoted_string(File.join(*segments.map{|s| assert_type s, :String; s.value}))
  end
  declare :absolute_path, [], :var_args => true

  # Returns an absolute path for the path relative to the sass file it was called from.
  def absolute_path(relative_path)
    quoted_string(File.expand_path(File.join(File.dirname(options[:filename]), relative_path.value)))
  end
  declare :absolute_path, [:relative_path]

  # split a file into directory, basename, and extension
  def split_filename(path)
    pathname = Pathname.new(path.value)
    list(quoted_string(pathname.dirname.to_s),
         quoted_string(pathname.basename(pathname.extname).to_s),
         quoted_string(pathname.extname.to_s),
         :space)
  end
  declare :split_filename, [:path]

  # Returns true if the compass compiler is compiling this stylesheet.
  def using_compass_compiler
    bool(options[:compass] && options[:compass][:compiler_in_use])
  end
  declare :using_compass_compiler, []

  def reset_configuration()
    Compass.reset_configuration!
    null()
  end
  declare :reset_configuration, []

  def add_sass_configuration(project_path)
    css_location = template_location = nil
    if options[:template_location] && options[:template_location].is_a?(Array)
      css_location = File.expand_path(options[:template_location].first.last)
      template_location = File.expand_path(options[:template_location].first.first)
    else
      css_location = File.expand_path(options[:css_location]) if options[:css_location]
      template_location = File.expand_path(options[:template_location]) if options[:template_location]
    end
    original_filename = File.expand_path(options[:original_filename]) if options[:original_filename]
    project_path = if project_path.value.nil?
                     if css_location && template_location
                       common_parent_directory(css_location, template_location)
                     end
                   else
                     project_path.value
                   end
    config = {
      :project_path => project_path,
      :cache => options[:cache],
      :additional_import_paths => options[:load_paths],
      :line_comments => options[:line_comments]
    }
    unless options[:quiet].nil?
      config.update(:disable_warnings => options[:quiet])
    end
    if project_path && css_location && (css_dir = relative_path_from(css_location, project_path))
      config.update(:css_dir => css_dir)
    elsif css_location
      config.update(:css_path => css_location)
    end
    if project_path && template_location && (sass_dir = relative_path_from(template_location, project_path))
      config.update(:sass_dir => sass_dir)
    elsif template_location
      config.update(:css_path => template_location)
    end
    config_name = "Sass Defaults: #{project_path ? relative_path_from(original_filename, project_path) : original_filename}"
    Compass.add_configuration(Compass::Configuration::Data.new(config_name, config))
    update_sass_options!
    null
  rescue => e
    puts e.backtrace.join("\n")
    raise
  end
  declare :add_sass_configuration, [:project_path]

  OPTION_TRANSFORMER = Hash.new() {|h, k| proc {|v, ctx| v.value } }
  OPTION_TRANSFORMER[:asset_cache_buster] = proc do |v, ctx|
    proc do |url, file|
      if ctx.environment.function(v.value) || Sass::Script::Functions.callable?(v.value.tr('-', '_'))
        result = ctx.call(v, ctx.quoted_string(url),
                             file.nil? ? ctx.null() : ctx.quoted_string(file.path))
        case result
        when Sass::Script::Value::String, Sass::Script::Value::Null
          result.value
        else
          ctx.assert_type(result, :Map) 
          result.value.keys.inject({}) do |r, k|
            ctx.assert_type k, :String
            ctx.assert_type(result.value[k], :String) unless result.value[k].value.nil?
            if k.value == "path" || k.value == "query"
              r[k.value.to_sym] = result.value[k].value
            end
            r
          end
        end
      else
        raise ArgumentError, "#{v.value} is not a function."
      end
    end
  end
  OPTION_TRANSFORMER[:asset_host] = proc do |v, ctx|
    proc do |file|
      if ctx.environment.function(v.value) || Sass::Script::Functions.callable?(v.value.tr('-', '_'))
        result = ctx.call(v, ctx.quoted_string(file))
        case result
        when Sass::Script::Value::String, Sass::Script::Value::Null
          result.value
        else
          ctx.assert_type(result, :String)
        end
      else
        raise ArgumentError, "#{v.value} is not a function."
      end
    end
  end

  def add_configuration(options)
    attributes = {}
    options.value.keys.each do |key|
      underscored = key.value.to_s.tr("-", "_")
      unless runtime_writable_attributes.find{|a| a.to_s == underscored}
        raise ArgumentError, "#{key} is not a valid configuration option."
      end
      underscored = underscored.to_sym
      attributes[underscored] = OPTION_TRANSFORMER[underscored].call(options.value[key], self)
    end
    name = "#{options.source_range.file}:#{options.source_range.start_pos.line}"
    Compass.add_configuration(Compass::Configuration::Data.new(name, attributes))
    update_sass_options!
    null
  end
  declare :add_configuration, [:options]

  private

  def runtime_writable_attributes
    Compass::Configuration::ATTRIBUTES - Compass::Configuration::RUNTIME_READONLY_ATTRIBUTES
  end

  def common_parent_directory(directory1, directory2)
    relative = Pathname.new(directory1).relative_path_from(Pathname.new(directory2))
    File.expand_path(directory2, relative.to_s.scan("..#{File::SEPARATOR}").join)
  end

  def relative_path_from(directory1, directory2)
    Pathname.new(directory1).relative_path_from(Pathname.new(directory2)).to_s
  end

  def update_sass_options!
    Compass.configuration.additional_import_paths.each do |lp|
      options[:load_paths] << lp unless options[:load_paths].include?(lp)
    end
    if Compass.configuration.disable_warnings
      Sass.logger.log_level = :error
    else
      Sass.logger.log_level = :warn
    end
  end
end
