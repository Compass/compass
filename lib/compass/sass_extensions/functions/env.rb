module Compass::SassExtensions::Functions::Env
  extend Compass::SassExtensions::Functions::SassDeclarationHelper

  def compass_env
    Sass::Script::String.new((options[:compass][:environment] || "development").to_s)
  end
  register_sass_function :compass_env, []

  DEFAULT_TIME = Sass::Script::String.new("%T%:z")
  def current_time(format = DEFAULT_TIME)
    assert_type format, :String
    Sass::Script::String.new(Time.now.strftime(format.value))
  end
  register_sass_function :current_time, []
  register_sass_function :current_time, [:format]

  DEFAULT_DATE = Sass::Script::String.new("%F")
  def current_date(format = DEFAULT_DATE)
    current_time(format)
  end
  register_sass_function :current_date, []
  register_sass_function :current_date, [:format]

  NOT_ABSOLUTE = Sass::Script::Bool.new(false)
  def current_source_file(absolute = NOT_ABSOLUTE)
    if absolute.to_bool
      Sass::Script::String.new(options[:original_filename].to_s)
    else
      filename = Pathname.new(options[:original_filename].to_s)
      sass_path = Pathname.new(Compass.configuration.sass_path)
      relative_filename = filename.relative_path_from(sass_path).to_s rescue path
      Sass::Script::String.new(relative_filename)
    end
  end
  register_sass_function :current_source_file, []
  register_sass_function :current_source_file, [:absolute]

  def current_output_file(absolute = NOT_ABSOLUTE)
    Sass::Script::String.new(options[:css_filename].to_s)
    if absolute.to_bool
      Sass::Script::String.new(options[:css_filename].to_s)
    else
      filename = Pathname.new(options[:css_filename].to_s)
      css_path = Pathname.new(Compass.configuration.css_path)
      relative_filename = filename.relative_path_from(css_path).to_s rescue path
      Sass::Script::String.new(relative_filename)
    end
  end
  register_sass_function :current_output_file, []
  register_sass_function :current_output_file, [:absolute]

end
