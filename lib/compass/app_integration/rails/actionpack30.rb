# TODO figure something out so image_path works with rails integration
%w(railtie).each do |lib|
  require "compass/app_integration/rails/actionpack30/#{lib}"
end

# Wierd that this has to be re-included to pick up sub-modules. Ruby bug?
class Sass::Script::Functions::EvaluationContext
  include Sass::Script::Functions
  private
  include ActionView::Helpers::AssetTagHelper
end
