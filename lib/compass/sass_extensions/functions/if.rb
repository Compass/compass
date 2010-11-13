module Compass::SassExtensions::Functions::If
  def if(truth, if_true, if_false)
    if truth.to_bool
      if_true
    else
      if_false
    end
  end
end
