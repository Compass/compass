require 'rubygems'
require 'sass'
require 'fileutils'
require 'pathname'
require File.join(File.dirname(__FILE__), 'base')
require File.join(File.dirname(__FILE__), 'update_project')

module Compass
  module Commands
    class WatchProject < UpdateProject
      attr_accessor :last_update_time
      def perform
        super
        self.last_update_time = most_recent_update_time
        loop do
          # TODO: Make this efficient by using filesystem monitoring.
          sleep 1
          file, t = should_update?
          if t
            begin
              puts ">>> Change detected to #{file} <<<"
              super
            rescue StandardError => e
              ::Compass::Exec.report_error(e, options)
            end
            self.last_update_time = t
          end
        end
      end
      def most_recent_update_time
        Dir.glob(separate("#{project_directory}/src/**/*.sass")).map {|sass_file| File.stat(sass_file).mtime}.max
      end
      def should_update?
        t = most_recent_update_time
        if t > last_update_time
          file = Dir.glob(separate("#{project_directory}/src/**/*.sass")).detect {|sass_file| File.stat(sass_file).mtime >= t}
          [file, t]
        end
      end
    end
  end
end