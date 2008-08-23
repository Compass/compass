class String
  # see if string has any content
  def blank?; self.length.zero?; end
  
  # strip space after :, remove newlines, replace multiple spaces with only one space, remove comments
  def strip_space!
    replace self.gsub(/:\s*/, ':').gsub(/\n/, '').gsub(/\s+/, ' ').gsub(/(\/\*).*?(\*\/)/, '')
  end
  
  # remove newlines, insert space after comma, replace two spaces with one space after comma
  def strip_selector_space!
    replace self.gsub(/(\n)/, '').gsub(',', ', ').gsub(',  ', ', ')
  end
  
  # remove leading whitespace, remove end whitespace
  def strip_side_space!
    replace self.gsub(/^\s+/, '').gsub(/\s+$/, $/)
  end
end

class NilClass
  def blank?
    true
  end
end

class File
  # string output from file
  def self.path_to_string(path)
    File.new(path).read
  end
  
  # saves a string to a specified file path
  def self.string_to_file(string, path)
    directory = File.dirname(path)
    FileUtils.mkdir_p directory unless File.directory?(directory)
    File.open(path, 'w') { |f| f << string }
  end
end