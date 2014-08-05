require "bundler"
Bundler.setup

require "rake"

desc "Watch the site for changes."
task :watch do
  sh "nanoc watch"
end

desc "Compile the site."
task :compile do
  sh "nanoc compile"
end

desc "View the site in a browser."
task :view do
  sh "nanoc view -H thin"
end

desc "View the site in a browser with live updating (sluggish)."
task :aco do
  sh "nanoc aco -H thin"
end
