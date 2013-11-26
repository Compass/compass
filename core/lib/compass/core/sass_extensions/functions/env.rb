module Compass::Core::SassExtensions::Functions::Env
  extend Compass::Core::SassExtensions::Functions::SassDeclarationHelper

  def compass_env
    compass_opts = options[:compass] || {}
    Sass::Script::String.new((compass_opts[:environment] || "development").to_s)
  end
  declare :compass_env, []

  DEFAULT_TIME = Sass::Script::String.new("%T%:z")
  def current_time(format = DEFAULT_TIME)
    assert_type format, :String
    Sass::Script::String.new(Time.now.strftime(format.value))
  end
  declare :current_time, []
  declare :current_time, [:format]

  DEFAULT_DATE = Sass::Script::String.new("%F")
  def current_date(format = DEFAULT_DATE)
    current_time(format)
  end
  declare :current_date, []
  declare :current_date, [:format]

  NOT_ABSOLUTE = Sass::Script::Bool.new(false)
  def current_source_file(absolute = NOT_ABSOLUTE)
    if absolute.to_bool
      Sass::Script::String.new(options[:original_filename].to_s)
    else
      filename = Pathname.new(options[:original_filename].to_s)
      sass_path = Pathname.new(Compass.configuration.sass_path)
      relative_filename = filename.relative_path_from(sass_path).to_s rescue filename
      Sass::Script::String.new(relative_filename.to_s)
    end
  end
  declare :current_source_file, []
  declare :current_source_file, [:absolute]

  def current_output_file(absolute = NOT_ABSOLUTE)
    Sass::Script::String.new(options[:css_filename].to_s)
    if absolute.to_bool
      Sass::Script::String.new(options[:css_filename].to_s)
    else
      filename = Pathname.new(options[:css_filename].to_s)
      css_path = Pathname.new(Compass.configuration.css_path)
      relative_filename = filename.relative_path_from(css_path).to_s rescue filename
      Sass::Script::String.new(relative_filename.to_s)
    end
  end
  declare :current_output_file, []
  declare :current_output_file, [:absolute]

  unless Sass::Util.has?(:public_instance_method, Sass::Script::Functions, :inspect)
    # This is going to be in sass 3.3, just here temporarily.
    def inspect(value)
      unquoted_string(value.to_sass)
    end
    declare :inspect, [:value]
  end
end
