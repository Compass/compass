description "Generate a compass extension."

unless options.include?(:preferred_syntax)
  options[:preferred_syntax] = 'sass'
end

file 'templates/project/manifest.rb'
file "stylesheets/main.sass", :to => "stylesheets/_#{File.basename(options[:pattern_name]||options[:project_name]||'main')}.#{options[:preferred_syntax]}"

file "templates/project/screen.sass", :to => "templates/project/screen.#{options[:preferred_syntax]}"


help %Q{
  To generate a compass extension:
  compass create my_extension --using compass/extension
}

welcome_message %Q{
For a full tutorial on how to build your own extension see:

http://compass-style.org/help/tutorials/extensions/

}, :replace => true

no_configuration_file!
skip_compilation!
