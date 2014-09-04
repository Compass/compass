require 'sass'
require 'compass/import-once/activate'
require 'sass-globbing'
require 'minitest/autorun'
require 'diff_as_string'

class Minitest::Test
  include DiffAsString
end
