module Compass::SassExtensions::Functions::Display
  DEFAULT_DISPLAY = {
    :block => %w{address article aside blockquote center dir div dd details dl dt fieldset
                  figcaption figure form footer frameset h1 h2 h3 h4 h5 h6 hr header hgroup
                  isindex menu nav noframes noscript ol p pre section summary ul},
    :inline => %w{a abbr acronym audio b basefont bdo big br canvas cite code command
                  datalist dfn em embed font i img input keygen kbd label mark meter output
                  progress q rp rt ruby s samp select small span strike strong sub
                  sup textarea time tt u var video wbr},
    :"inline-block" => %w{img},
    :table => %w{table},
    :"list-item" => %w{li},
    :"table-row-group" => %w{tbody},
    :"table-header-group" => %w{thead},
    :"table-footer-group" => %w{tfoot},
    :"table-row" => %w{tr},
    :"table-cell" => %w{th td},
    :"html5-block" => %w{article aside details figcaption figure footer header hgroup menu nav section summary},
    :"html5-inline" => %w{audio canvas command datalist embed keygen mark meter output progress rp rt ruby time video wbr},
  }
  DEFAULT_DISPLAY[:html5] = (DEFAULT_DISPLAY[:"html5-block"] + DEFAULT_DISPLAY[:"html5-inline"]).sort
  # returns a comma delimited string for all the
  # elements according to their default css3 display value.
  def elements_of_type(display)
    Sass::Script::String.new(DEFAULT_DISPLAY.fetch(display.value.to_sym).join(", "))
  end
end
