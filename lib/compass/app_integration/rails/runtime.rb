unless defined?(Compass::RAILS_LOADED)
  Compass::RAILS_LOADED = true
  begin
    require 'action_pack/version'
    if ActionPack::VERSION::MAJOR >= 3
      if ActionPack::VERSION::MINOR < 1
        require 'compass/app_integration/rails/actionpack30'
      else
        require 'compass/app_integration/rails/actionpack31'
      end
    else
      require 'compass/app_integration/rails/actionpack2x'
    end
  rescue LoadError, NameError
    $stderr.puts "Compass could not access the rails environment."
  end
end
