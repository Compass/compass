Given /^the "([^\"]*)" directory exists$/ do |directory|
  directory.gsub!('~', ENV["HOME"]) if directory.include?('~/')
  FileUtils.mkdir_p directory
end

Given /^and I have a fake extension at (.*)$/ do |directory|
  directory.gsub!('~', ENV["HOME"]) if directory.include?('~/')
  FileUtils.mkdir_p File.join(directory, 'stylesheets')
  FileUtils.mkdir_p File.join(directory, 'templates/project')
  open(File.join(directory, 'templates/project/manifest.rb'),"w") do |f|
    f.puts %Q{
      description "This is a fake extension"

      help "this is the fake help"

      welcome_message "this is a fake welcome"
    }
  end
end

Then /^the list of frameworks includes "([^\"]*)"$/ do |framework|
  @last_result.split("\n").map{|f| f.gsub(/(^\s+[*-]\s+)|(\s+$)/,'')}.should include(framework)
end

