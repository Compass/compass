require File.join(File.dirname(__FILE__), 'project_base')
require File.join(File.dirname(__FILE__), 'update_project')
require File.join(File.dirname(__FILE__), '..', 'grid_builder')

module Compass
  module Commands
    class GenerateGridBackground < ProjectBase
      include Actions
      def initialize(working_path, options)
        super
        assert_project_directory_exists!
        Compass.add_configuration(options)
      end

      def perform
        unless options[:grid_dimensions] =~ /^(\d+)\+(\d+)(?:x(\d+))?$/
          puts "ERROR: '#{options[:grid_dimensions]}' is not valid."
          puts "Dimensions should be specified like: 30+10x20"
          puts "where 30 is the column width, 10 is the gutter width, and 20 is the (optional) height."
          return
        end
        column_width = $1.to_i
        gutter_width = $2.to_i
        height = $3.to_i if $3
        unless GridBuilder.new(options.merge(:column_width => column_width, :gutter_width => gutter_width, :height => height, :output_path => projectize(project_images_subdirectory), :working_path => self.working_path)).generate!
          puts "ERROR: Some library dependencies appear to be missing."
          puts "Have you installed rmagick? If not, please run:"
          puts "sudo gem install rmagick"
        end
      end
    end
  end
end