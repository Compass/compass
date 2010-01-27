class AssetDataSource < Nanoc3::DataSource
  identifier :filesystem_assets

  def items
    files = []
    Dir.glob("assets/**/*").each do |f|
      files << f if File.file?(f)
    end
    files.map do |f|
      identifier = f[7..-1].gsub(/\.[^.]+$/,'')+"/"
      attrs = {:extension => File.extname(f)[1..-1]}
      Nanoc3::Item.new(File.read(f), attrs, identifier, File.mtime(f))
    end
  end
end
