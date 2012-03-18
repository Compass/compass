module Compass::Commands
end

require 'compass/commands/registry'

%w(base generate_grid_background default help list_frameworks project_base
   update_project watch_project create_project clean_project extension_command
   imports installer_command print_version project_stats stamp_pattern
   sprite validate_project write_configuration interactive unpack_extension
).each do |lib|
  require "compass/commands/#{lib}"
end
