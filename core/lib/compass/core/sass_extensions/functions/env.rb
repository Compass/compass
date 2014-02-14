module Compass::Core::SassExtensions::Functions::Env
  extend Compass::Core::SassExtensions::Functions::SassDeclarationHelper
  extend Sass::Script::Value::Helpers

  def compass_env
    compass_opts = options[:compass] || {}
    identifier((compass_opts[:environment] || "development").to_s)
  end
  declare :compass_env, []

  DEFAULT_TIME = identifier("%T%:z")
  def current_time(format = DEFAULT_TIME)
    assert_type format, :String
    identifier(Time.now.strftime(format.value))
  end
  declare :current_time, []
  declare :current_time, [:format]

  DEFAULT_DATE = identifier("%F")
  def current_date(format = DEFAULT_DATE)
    current_time(format)
  end
  declare :current_date, []
  declare :current_date, [:format]

  NOT_ABSOLUTE = bool(false)
  def current_source_file(absolute = NOT_ABSOLUTE)
    if absolute.to_bool
      identifier(options[:original_filename].to_s)
    else
      filename = Pathname.new(options[:original_filename].to_s)
      sass_path = Pathname.new(Compass.configuration.sass_path)
      relative_filename = filename.relative_path_from(sass_path).to_s rescue filename
      identifier(relative_filename.to_s)
    end
  end
  declare :current_source_file, []
  declare :current_source_file, [:absolute]

  def current_output_file(absolute = NOT_ABSOLUTE)
    if absolute.to_bool
      identifier(options[:css_filename].to_s)
    else
      filename = Pathname.new(options[:css_filename].to_s)
      css_path = Pathname.new(Compass.configuration.css_path)
      relative_filename = filename.relative_path_from(css_path).to_s rescue filename
      identifier(relative_filename.to_s)
    end
  end
  declare :current_output_file, []
  declare :current_output_file, [:absolute]

  def compass_extensions
    exts = Sass::Util.ordered_hash(identifier("compass") => quoted_string(Compass::Core::VERSION))
    if defined?(Compass::Frameworks::ALL)
      Compass::Frameworks::ALL.each do |framework|
        next if framework.name == "compass"
        exts[identifier(framework.name)] =
          framework.version ? quoted_string(framework.version) : bool(true);
      end
    end
    map(exts)
  end
  declare :compass_extensions, []

  def at_stylesheet_root
    bool(environment.selector.nil?)
  end
  declare :at_stylesheet_root, []
end
