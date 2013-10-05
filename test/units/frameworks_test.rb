require 'test_helper'
require 'fileutils'

class FrameworksTest < Test::Unit::TestCase

  COMPASS_FIXTURE = File.join(File.expand_path('../../', __FILE__), 'fixtures', 'stylesheets', 'compass')
  EXT_DIR = File.join(COMPASS_FIXTURE, 'extensions')
  MY_EXT = File.join(EXT_DIR, 'my_extension')
  MY_OTHER_EXT = File.join(EXT_DIR, 'my_other_extension')
  MY_OTHER_EXT_LIB = File.join(MY_OTHER_EXT, 'lib')

  def test_frameworks_add_correct_files_to_load_path
    Compass::Frameworks.discover(EXT_DIR)
    [MY_EXT, MY_OTHER_EXT, MY_OTHER_EXT_LIB].each do |dir|
      assert $:.include?(dir), "#{dir} is not in load path load path is : #{$:.join("\n")}"
    end
  end
end