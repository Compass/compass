require 'net/http'
require 'fileutils'
require 'rubygems'
require 'zip/zip'

extdir = File.join(File.dirname(__FILE__),'extensions')
download_link = "http://github.com/chriseppstein/compass-960-plugin/zipball/master"

def fetch(uri_str, limit = 10)
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

  response = Net::HTTP.get_response(URI.parse(uri_str))
  case response
  when Net::HTTPSuccess     then response
  when Net::HTTPRedirection then fetch(response['location'], limit - 1)
  else
    response.error!
  end
end


if !File.exists?(extdir)
  begin
    puts "Downloading the ninesixty plugin."
    FileUtils.mkdir(extdir)
    zipfile = File.join(extdir, "ninesixty.zip")
    open(zipfile, "wb") do |tgz|
      tgz << fetch(download_link).body
    end
    puts "Unzipping the ninesixty plugin."
    Zip::ZipFile::open(zipfile) { |zf|
       zf.each { |e|
         fpath = File.join(extdir, e.name)
         FileUtils.mkdir_p(File.dirname(fpath))
         zf.extract(e, fpath)
       }
    }
    File.unlink(zipfile)
    funky_directory = Dir.glob(File.join(extdir,'chriseppstein-compass-960-plugin-*'))[0]
    FileUtils.mv(funky_directory, File.join(extdir,'ninesixty'))
  rescue Exception => e
    FileUtils.rmdir(extdir)
    raise
  end
end
