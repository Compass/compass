$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'compass'
require 'rspec'
require 'rspec/autorun'

module CompassGlobalInclude
  class << self
    def included(klass)
      klass.instance_eval do
        let(:images_src_path) { File.join(File.dirname(__FILE__), 'test_project', 'public', 'images') }
      end
    end
  end
end

RSpec.configure do |config|
  config.include(CompassGlobalInclude)
end
