begin
  # Try to require the preresolved locked set of gems.
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  # Fall back on doing an unlocked resolve at runtime.
  require "rubygems"
  require "bundler"
  Bundler.setup
end

require 'nanoc3/tasks'
$: << "lib"

desc "watch for changes and recompile"
task :watch do
  require 'fssm'
  require 'nanoc3'
  require 'nanoc3/cli'
  $:<< File.expand_path(File.dirname(__FILE__)+"/../lib")
  Dir['lib/commands/*.rb'].map{|d| d[4..-1]}.sort.each     { |f| require f }
  Dir['lib/data_sources/*.rb'].map{|d| d[4..-1]}.sort.each { |f| require f }
  Nanoc3::NotificationCenter.on(:compilation_started) do |rep|
    puts "Compiling: #{rep.path}"
  end

  rebuild_site = lambda do |base, relative|
    if relative && relative =~ /\.s[ac]ss/
      puts ">>> Change Detected to #{relative} : updating stylesheets <<<"
      system "bundle exec compass compile"
    else
      if !relative
        puts ">>> Compiling <<<"
      else
        puts ">>> Change Detected to #{relative} <<<"
      end
      start = Time.now
      # Nanoc3::CLI::Base.new.run(["co"])
      site = Nanoc3::Site.new('.')
      site.load_data
      begin
        site.compiler.run
        puts ">>> Done in #{((Time.now - start)*10000).round.to_f / 10}ms <<<"
        `growlnotify -m "Compilation Complete" --image misc/success-icon.png; exit 0`
      rescue Exception => e
        puts ">>> ERROR: #{e.message} <<<"
        puts e.backtrace.join("\n")
        `growlnotify -m "Compilation Error!" --image misc/error-icon.png; exit 0`
      end
    end
  end
  rebuild_site.call(nil,nil)

  puts ">>> Watching for Changes <<<"
  puts "Run: bundle exec serve .."
  monitor = FSSM::Monitor.new
  monitor.path("#{File.dirname(__FILE__)}/content", '**/*') do
    update(&rebuild_site)
    delete(&rebuild_site)
    create(&rebuild_site)
  end
  monitor.path("#{File.dirname(__FILE__)}/lib", '**/*') do
    update(&rebuild_site)
    delete(&rebuild_site)
    create(&rebuild_site)
  end
  monitor.path("#{File.dirname(__FILE__)}/layouts", '**/*') do
    update(&rebuild_site)
    delete(&rebuild_site)
    create(&rebuild_site)
  end
  monitor.path("#{File.dirname(__FILE__)}/assets", '**/*') do
    update(&rebuild_site)
    delete(&rebuild_site)
    create(&rebuild_site)
  end
  monitor.run
end

