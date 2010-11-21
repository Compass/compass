module Compass::SassExtensions::Functions::If
  def if(truth, if_true = nil, if_false = nil)
    if truth.to_bool
      if_true || Sass::Script::Bool.new(true)
    else
      if_false || Sass::Script::Bool.new(false)
    end
  end
end
