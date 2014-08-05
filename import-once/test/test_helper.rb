require 'sass'
require 'compass/import-once/activate'
require 'sass-globbing'
require 'test/unit'
require 'diff_as_string'

class Test::Unit::TestCase
  include DiffAsString
end
