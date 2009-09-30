module Compass::Commands
end

require 'compass/commands/registry'

%w(base generate_grid_background list_frameworks project_base
   update_project watch_project create_project installer_command
   print_version stamp_pattern validate_project	write_configuration).each do |lib|
  require "compass/commands/#{lib}"
end
