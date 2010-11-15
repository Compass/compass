module Compass::SassExtensions::Functions::If
  def if(truth, if_true, if_false = nil)
    if truth.to_bool
      if_true
    else
      if_false || Sass::Script::Bool.new(false)
    end
  end
end
