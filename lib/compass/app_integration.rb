require "compass/app_integration/stand_alone"

module Compass
  module AppIntegration
    module Helpers
      #attr_accessor :project_types
      DEAFULT_PROJECT_TYPES = {
        :stand_alone => "Compass::AppIntegration::StandAlone"
      }

      def init
        @project_types ||= DEAFULT_PROJECT_TYPES
      end

      def project_types
        @project_types
      end

      def any?
        @project_types == DEAFULT_PROJECT_TYPES
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

    end
    extend Helpers
    init
  end
end
