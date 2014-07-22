task default: %w[test]

desc "Run all tests"
task :test do
  sh './test_all.sh'
end


desc "Clean up all test files"
task :test_cleanup do
  dirs = [
    'core/.sass-cache/',
    'core/test/integrations/projects/busted_font_urls/tmp/',
    'core/test/integrations/projects/busted_image_urls/tmp/',
    'core/test/integrations/projects/compass/tmp/',
    'core/test/integrations/projects/envtest/tmp/',
    'core/test/integrations/projects/image_urls/tmp/',
    'core/test/integrations/projects/relative/tmp/',
    'core/test/integrations/projects/uses_only_stylesheets_ext/tmp/',
    'core/test/integrations/projects/valid/tmp/',
    'import-once/.sass-cache/'
  ]
  dirs.each { |dir| rm_rf dir }
end
