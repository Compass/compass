module Compass::SassExtensions::Functions::Urls
  def image_url_with_rails_integration(path, only_path = Sass::Script::Bool.new(false), cache_buster = Sass::Script::Bool.new(true))
    if (@controller = Sass::Plugin.rails_controller) && @controller.respond_to?(:request) && @controller.request
      begin
        if only_path.to_bool
          Sass::Script::String.new image_path(path.value)
        else
          Sass::Script::String.new "url(#{image_path(path.value)})"
        end
      ensure
        @controller = nil
      end
    else
      image_url_without_rails_integration(path, only_path, cache_buster)
    end
  end
  alias_method_chain :image_url, :rails_integration
end