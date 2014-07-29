require 'fileutils'
require 'compass/core'

require "minitest/autorun"
require File.expand_path(File.join(File.dirname(__FILE__), "..", "helpers", "diff"))

include Compass::Diff

