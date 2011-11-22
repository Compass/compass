---
title: Testing Your Stylesheets
layout: tutorial
crumb: Testing
classnames:
  - tutorial
---

# Test Unit

    require 'compass/test_case'
    class StylesheetsTest < Compass::TestCase
      def test_stylesheets
        my_sass_files.each do |sass_file|
          assert_compiles(sass_file) do |result|
            assert_not_blank result
          end
        end
      end
      protected
      def my_sass_files
        Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), "../..", "app/stylesheets/**/[^_]*.sass")))
      end
    end