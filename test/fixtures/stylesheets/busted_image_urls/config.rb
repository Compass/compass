# Require any additional compass plugins here.
project_type = :stand_alone
css_dir = "tmp"
sass_dir = "sass"
images_dir = "images"
output_style = :compact
# To enable relative image paths using the images_url() function:
# http_images_path = :relative
http_images_path = "/images"
line_comments = false

asset_cache_buster do |path, file|
  pathname = Pathname.new(path)
  
  case pathname.basename(pathname.extname).to_s
  when "grid"
    new_path = "%s/%s-BUSTED%s" % [pathname.dirname, pathname.basename(pathname.extname), pathname.extname]
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
