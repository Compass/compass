require "compass/import-once/version"
require "compass/import-once/importer"
require "compass/import-once/engine"
require 'set'

module Compass
  # although this is part of the compass suite of gems, it doesn't depend on compass,
  # so any sass-based project can use to to get import-once behavior for all of their
  # importers.
  module ImportOnce
    class << self
      # A map of css filenames to a set of engine cache keys that uniquely identify what has
      # been imported. The lifecycle of each key is handled by code wrapped around Sass's
      # render, to_css and render_with_sourcemap methods on the Sass::Engine.
      #
      # Ideally, Sass would provide a place in it's public API to put
      # information that persists for only the duration of a single compile and would be accessible
      # for all sass engines and sass functions written in ruby.
      def import_tracker
        Thread.current[:import_once_tracker] ||= {}
      end

      def activate!
        require 'compass/import-once/activate'
      end
    end
  end
end
