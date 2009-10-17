require 'spec/expectations'
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../../test')))

require 'test_helper'

require 'compass/exec'

include Compass::CommandLineHelper
include Compass::IoHelper

Before do
  @cleanup_directories = []
end
 
After do
  @cleanup_directories.each do |dir|
    FileUtils.rm_rf dir
  end
end

When /I enter the command: compass create ([^\s]+) ?(.+)?/ do |dir, args|
  @cleanup_directories << dir
  compass 'create', dir, *(args || '').split
end

# When /I enter the command: compass ([^\s]+) ?(.+)?/ do |command, args|
#   compass command, *args.split
# end

 
Then /a directory ([^ ]+) is (not )?created/ do |directory, negated|
  File.directory?(directory).should == !negated
end
 
Then /an? \w+ file ([^ ]+) is created/ do |filename|
  File.exists?(filename).should == true
end

Then /an? \w+ file ([^ ]+) is reported created/ do |filename|
  @last_result.should =~ /create #{Regexp.escape(filename)}/
end

Then /a \w+ file ([^ ]+) is (?:reported )?compiled/ do |filename|
  @last_result.should =~ /compile #{Regexp.escape(filename)}/
end

Then /I am told how to link to ([^ ]+) for media "([^"]+)"/ do |stylesheet, media|
  @last_result.should =~ %r{<link href="#{stylesheet}" media="#{media}" rel="stylesheet" type="text/css" />}
end

Then /I am told how to conditionally link "([^"]+)" to ([^ ]+) for media "([^"]+)"/ do |condition, stylesheet, media|
  @last_result.should =~ %r{<!--\[if #{condition}\]>\s+<link href="#{stylesheet}" media="#{media}" rel="stylesheet" type="text/css" />\s+<!\[endif\]-->}mi
end
