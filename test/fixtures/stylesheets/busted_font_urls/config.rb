# Require any additional compass plugins here.
project_type = :stand_alone
css_dir = "tmp"
sass_dir = "sass"
fonts_dir = "fonts"
output_style = :compact
# To enable relative image paths using the images_url() function:
# http_images_path = :relative
http_fonts_path = "/fonts"
line_comments = false

asset_cache_buster do |path, file|
  pathname = Pathname.new(path)
  dirname = pathname.dirname
  basename = pathname.basename(pathname.extname)
  extname = pathname.extname

  case pathname.basename(pathname.extname).to_s
  when "grid"
    new_path = "#{dirname}/#{basename}-BUSTED#{extname}"
    {:path => new_path, :query => nil}
  when "feed"
    "query_string"
  when "dk"
    {:query => "query_string"}
  end
end


asset_host do |path|
  "http://assets%d.example.com" % (path.size % 4)
end
