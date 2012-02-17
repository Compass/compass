group :tests do
  guard :test do
    watch(%r{^lib/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch(%r{^test/units/.+_test\.rb$})
    watch('test/test_helper.rb') { "test" }
  end
end

group :features do
  guard :cucumber do
    watch(%r{^features/.+\.feature$})
    watch(%r{^features/support/.+$}) { 'features' }
    watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
  end
end