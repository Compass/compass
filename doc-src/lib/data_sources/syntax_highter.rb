require 'nokogiri'
require 'coderay'
class SyntaxHighlighterFilter < Nanoc3::Filter
  identifier :highlight
  
  def highlight(code, type)
    hl_map = Hash.new(:coderay)
    hl_map[:sass] = :pygmentize
    send(hl_map[type], code, type)
  end

  def pygmentize(code, type)
    # -O linenos=table
    IO.popen("pygmentize -l #{type} -f html -O encoding=utf-8", "r+") do |io|
      io.write(code)
      io.close_write
      return io.read
    end
  end
  
  def coderay(code, type)
    # :line_numbers => :table,
    type = :css if type == :scss
    CodeRay.scan(code, type).div(:css => :class)
  end

  def run(content, params={})
    doc = Nokogiri::HTML.fragment(content)
    [:html, :css, :sass, :scss].each do |format|
      doc.css("pre.source-code.#{format}, code.#{format}").each do |el|
        new_element = Nokogiri.make(highlight(el.inner_text, format))
        new_element.set_attribute("class", new_element.attribute("class").value+" "+el.attribute("class").value)
        if id = el.attribute("id")
          new_element.set_attribute("id", id)
        end
        el.replace new_element
      end
    end
    doc.to_s
  end
  
end
