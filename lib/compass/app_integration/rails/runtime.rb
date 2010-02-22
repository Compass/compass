unless defined?(Compass::RAILS_LOADED)
  Compass::RAILS_LOADED = true
  
  if ActionPack::VERSION::MAJOR >= 3
    # figure something out so image_path works with rails integration
  else
    %w(action_controller sass_plugin urls).each do |lib|
      require "compass/app_integration/rails/actionpack2/#{lib}"
    end
  end
  
  # Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
  class Sass::Script::Functions::EvaluationContext
    include Sass::Script::Functions
    private
    include ActionView::Helpers::AssetTagHelper
  end
end
