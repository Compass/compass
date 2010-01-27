require 'fileutils'

class Generate < Thor
  desc "example IDENTIFIER", "Generate a new example."
  def example(identifier)
    identifier = identifier.dup
    identifier << "/" unless identifier[identifier.length - 1] == ?/
    identifier = identifier[1..-1] if identifier[0] == ?/
    puts "Generating /examples/#{identifier}"
    puts "DIRECTORY content/examples/#{identifier}"
    FileUtils.mkdir_p("content/examples/#{identifier}")
    puts "   CREATE content/examples/#{identifier[0..-2]}.haml"
    open("content/examples/#{identifier[0..-2]}.haml", "w") do |example_file|
      example_contents = <<-EXAMPLE
      | ---
      | title: Blueprint Pull Example
      | description: Uses pull to change the display order of columns.
      | framework: blueprint
      | stylesheet: blueprint/_grid.sass
      | mixin: pull
      | example: true
      | ---
      | = render "partials/example"
      EXAMPLE
      example_file.puts example_contents.gsub(/^ +\| /, '')
    end
    puts "   CREATE content/examples/#{identifier[0..-2]}/markup.haml"
    open("content/examples/#{identifier[0..-2]}/markup.haml", "w") do |example_file|
      example_contents = <<-EXAMPLE
        | .example
        |   %h1.markup In Haml
        |   %p This file gets included into the example.
        |   %p And the source is shown to the user as HTML.
      EXAMPLE
      example_file.puts example_contents.gsub(/^ +\| /, '')
    end
    puts "   CREATE content/examples/#{identifier[0..-2]}/stylesheet.sass"
    open("content/examples/#{identifier[0..-2]}/stylesheet.sass", "w") do |example_file|
      example_contents = <<-EXAMPLE
        | .example
        |   h1.markup
        |     /* This file is used to style the example markup. */
        |     p
        |       /* And the source is shown to the user as Sass and as CSS. */
      EXAMPLE
      example_file.puts example_contents.gsub(/^ +\| /, '')
      puts "open http://localhost:3000/examples/#{identifier}"
      puts "./bin/nanoc3 aco"
    end
  end

  desc "reference FRAMEWORK STYLESHEET", "Generate a reference page for the given stylesheet."
  def reference(identifier)
  end
end