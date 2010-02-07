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
    IO.popen("pygmentize -l #{type} -f html -O linenos=table", "r+") do |io|
      io.write(code)
      io.close_write
      return io.read
    end
  end
  
  def coderay(code, type)
    CodeRay.scan(code, type).div(:line_numbers => :table, :css => :class)
  end

  def run(content, params={})
    doc = Nokogiri::HTML.fragment(content)
    [:html, :css, :sass].each do |format|
      doc.css("code.#{format}").each do |el|
        el.parent.replace Nokogiri.make(highlight(el.inner_text, format))
      end
    end
    doc.to_s
  end
  
end
