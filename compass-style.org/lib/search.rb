require 'json'

STOP_WORDS = %w{
  a about above across after afterwards again against all almost
  alone along already also although always am among amongst amoungst
  amount an and another any anyhow anyone anything anyway anywhere
  are around as at back be became because become becomes becoming
  been before beforehand behind being below beside besides between
  beyond bill both bottom but by call can cannot cant co computer con
  could couldnt cry de describe detail do done down due during each
  eg eight either eleven else elsewhere empty enough etc even ever
  every everyone everything everywhere except few fifteen fify fill
  find fire first five for former formerly forty found four from
  front full further get give go had has hasnt have he hence her here
  hereafter hereby herein hereupon hers herself him himself his how
  however hundred i ie if in inc indeed interest into is it its
  itself keep last latter latterly least less ltd made many may me
  meanwhile might mill mine more moreover most mostly move much must
  my myself name namely neither never nevertheless next nine no
  nobody none noone nor not nothing now nowhere of off often on once
  one only onto or other others otherwise our ours ourselves out over
  own part per perhaps please put rather re same see seem seemed
  seeming seems serious several she should show side since sincere
  six sixty so some somehow someone something sometime sometimes
  somewhere still such system take ten than that the their them
  themselves then thence there thereafter thereby therefore therein
  thereupon these they thick thin third this those though three
  through throughout thru thus to together too top toward towards
  twelve twenty two un under until up upon us very via was we well
  were what whatever when whence whenever where whereafter whereas
  whereby wherein whereupon wherever whether which while whither who
  whoever whole whom whose why will with within without would yet you
  your yours yourself yourselves
} unless defined?(STOP_WORDS)

def search_terms_for(item)
  if item.identifier =~ /^\/(reference|tutorials)/
    content = item.rep_named(:default).compiled_content
    doc = Nokogiri::HTML(content)
    full_text = doc.css("p, h1, h2, h3, h4, h5, h6").map{|el| el.inner_text}.join(" ")
    "#{item[:title]} #{item[:meta_description]} #{full_text}".gsub(/[\W\s_]+/m,' ').downcase.split(/\s+/).uniq - STOP_WORDS
  else
    []
  end
end

def search_index
  id = 0;
  idx = {
    "approximate" => {},
    "terms" => {},
    "items" => {}
  }
  @items.each do |item|
    search_terms_for(item).each do |term|
      idx["terms"][term] ||= []
      idx["terms"][term] << id
      (0...term.length).each do |c|
        subterm = term[0...c]
        # puts "Indexing: #{subterm}"
        idx["approximate"][subterm] ||= []
        unless idx["approximate"][subterm].include?(id)
          idx["approximate"][subterm] << id
        end
      end
      # puts "Indexed: #{term}"
    end
    idx["items"][id] = {
      "url" => "#{item.identifier}",
      "title" => item[:title],
      "crumb" => item[:crumb]
    }
    id += 1
  end
  idx
end
