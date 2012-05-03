module Compass
  module AppIntegration
    module Rails
      extend self
      def initialize!
        Compass::Util.compass_warn("WARNING:  Please remove the call to Compass::AppIntegration::Rails.initialize! from #{caller[0].sub(/:.*$/,'')};\nWARNING:  This is done automatically now. If this is default compass initializer you can just remove the file.")
      end
      def root
        Compass::Util.compass_warn("WARNING:  Please remove the call to Compass::AppIntegration::Rails.root from #{caller[0].sub(/:.*$/,'')};\nWARNING:  This is done automatically now. If this is default compass initializer you can just remove the file.")
        ::Rails.root
      end
      def env
        Compass::Util.compass_warn("WARNING:  Please remove the call to Compass::AppIntegration::Rails.env from #{caller[0].sub(/:.*$/,'')};\nWARNING:  This is done automatically now. If this is default compass initializer you can just remove the file.")
        ::Rails.env
      end
    end
  end
end
