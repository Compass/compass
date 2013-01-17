module Compass::SassExtensions::Functions::Env

  def compass_env
    Sass::Script::String.new((options[:compass][:environment] || "development").to_s)
  end

  def current_time(format)
    time = Time.now.strftime(format.to_s)

    Sass::Script::String.new(time.to_s)
  end

  alias :current_date :current_time

  def current_source_file
    Sass::Script::String.new(options[:filename].to_s)
  end

  def current_output_file
    Sass::Script::String.new(options[:css_filename].to_s)
  end

end
