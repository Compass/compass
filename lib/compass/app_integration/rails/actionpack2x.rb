%w(action_controller sass_plugin urls).each do |lib|
  require "compass/app_integration/rails/actionpack2x/#{lib}"
end

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
  private
  include ActionView::Helpers::AssetTagHelper
end
