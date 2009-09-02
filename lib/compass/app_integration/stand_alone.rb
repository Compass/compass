['configuration_defaults', 'installer'].each do |lib|
  require File.join(File.dirname(__FILE__), 'stand_alone', lib)
end