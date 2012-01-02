%w(stand_alone merb).each do |lib|
  require "compass/app_integration/#{lib}"
end

module Compass
  module AppIntegration
    module Helpers
      attr_accessor :project_types
      DEAFULT_PROJECT_TYPES = {
        :merb => "Compass::AppIntegration::Merb", 
        :stand_alone => "Compass::AppIntegration::StandAlone"
      }

      def init
        @project_types ||= DEAFULT_PROJECT_TYPES
      end

      def lookup(type)
        unless @project_types[type].nil?
          eval @project_types[type]
        else
          raise Compass::Error, "No application integration exists for #{type}"
        end
      end

      def register(type, klass)
        @project_types[type] = klass
      end

      protected

      # Stolen from ActiveSupport
      def camelize(s)
        s.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      end

    end
    extend Helpers
    init
  end
end
