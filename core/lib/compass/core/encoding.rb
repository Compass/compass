if Sass::Util.windows?
  encodings = (ENV.keys + ENV.values).map{|v| v.encoding}.uniq
  if encodings.size > 1
    Sass::Util.sass_warn "Multiple system encodings find in your environment. Picking: #{encodings.first}"
  end
  Encoding.default_external ||= encodings.first
  Encoding.default_internal ||= encodings.first
end
