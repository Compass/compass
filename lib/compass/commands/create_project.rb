require 'fileutils'
require 'compass/commands/stamp_pattern'

module Compass
  module Commands
    class CreateProject < StampPattern

      def initialize(working_path, options)
        super(working_path, options.merge(:pattern => "project", :pattern_name => nil))
      end

      def is_project_creation?
        true
      end

    end
  end
end