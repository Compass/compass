module Compass::SassExtensions::Functions::Env
  def compass_env
    Sass::Script::String.new((options[:compass][:environment] || "development").to_s)
  end
end
