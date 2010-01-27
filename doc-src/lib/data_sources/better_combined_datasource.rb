# This is basically the default filesystem_combined datasource
# But items without a metadata header don't get an error.
class BetterFilesystemCombined < Nanoc3::DataSources::FilesystemCombined
  identifier :better_combined

  def parse_file(filename, kind)
    contents = File.read(filename)
    if contents =~ /^(-{5}|-{3})/
      # Split file
      pieces = contents.split(/^(-{5}|-{3})/).compact
      if pieces.size < 4
        raise RuntimeError.new(
          "The file '#{filename}' does not seem to be a nanoc #{kind}"
        )
      end

      # Parse
      meta    = YAML.load(pieces[2]) || {}
      content = pieces[4..-1].join.strip

      [ meta, content ]
    else
      [{}, contents]
    end
  end

end
  