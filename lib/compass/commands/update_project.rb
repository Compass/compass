require File.join(File.dirname(__FILE__), 'project_base')
require File.join(Compass.lib_directory, 'compass', 'compiler')

module Compass
  module Commands
    class UpdateProject < ProjectBase
      
      def initialize(working_path, options)
        super
        assert_project_directory_exists!
      end

      def perform
        compiler = Compass::Compiler.new(working_path,
          projectize(Compass.configuration.sass_dir),
          projectize(Compass.configuration.css_dir),
          Compass.sass_engine_options.merge(:quiet => options[:quiet],
                                            :force => options[:force]))
        compiler.run
      end

    end
  end
end