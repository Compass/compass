helpers_dir =  File.join(File.expand_path('../', __FILE__), 'helpers')

REPO_ROOT = File.expand_path('../../../', __FILE__)

%w(io command_line test_case diff).each do |helper|
  require File.join(helpers_dir, helper)
end
