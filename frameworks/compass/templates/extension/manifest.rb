file 'stylesheets/main.sass', :to => "stylesheets/_#{File.basename(options[:pattern_name])}.sass"
file 'templates/project/manifest.rb'
file 'templates/project/screen.sass'

no_configuration_file!
skip_compilation!