$: << File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'fileutils'
require 'compass'

class Generate < Thor
  desc "example IDENTIFIER [../frameworks/fmwk/stylesheets/path/to/_module.sass]", "Generate a new example."
  method_options :title => :string, :framework => :string, :stylesheet => :string, :mixin => :string
  def example(identifier, stylesheet = nil)
    identifier = identifier.dup
    identifier << "/" unless identifier[identifier.length - 1] == ?/
    identifier = identifier[1..-1] if identifier[0] == ?/
    stylesheet = stylesheet && dereference(stylesheet) || {}
    options = @options.merge(stylesheet)
    puts "Generating /examples/#{identifier}"
    puts "DIRECTORY content/examples/#{identifier}"
    FileUtils.mkdir_p("content/examples/#{identifier}")
    puts "   CREATE content/examples/#{identifier[0..-2]}.haml"
    open("content/examples/#{identifier[0..-2]}.haml", "w") do |example_file|
      mixin = "mixin: #{options[:mixin]}\n" if options[:mixin]
      example_contents = <<-EXAMPLE
      | ---
      | title: #{options[:framework].capitalize} #{options[:mixin].capitalize if options[:mixin]} Example
      | description: How to do X with Y
      | framework: #{options[:framework]}
      | stylesheet: #{options[:stylesheet]}
      | #{mixin}example: true
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
      puts "bundle exec nanoc3 co && open http://localhost:3000/docs/examples/#{identifier} && bundle exec nanoc3 aco"
    end
  end

  desc "reference ../frameworks/fmwk/stylesheets/path/to/_module.sass", "Generate a reference page for the given stylesheet."
  method_options :title => :string
  def reference(stylesheet)
    stylesheet = dereference(stylesheet)
    identifier = "reference/#{stylesheet[:framework]}/#{stylesheet[:stylesheet]}"
    identifier.gsub!(%r{/_},'/')
    identifier.gsub!(/\.s[ac]ss/,'')
    identifier.gsub!(%r{/#{stylesheet[:framework]}/#{stylesheet[:framework]}/},"/#{stylesheet[:framework]}/")

    module_name = File.basename(identifier).gsub(/\.[^.]+$/,'').capitalize
    framework_name = stylesheet[:framework].capitalize

    title = @options[:title] || "#{framework_name} #{module_name}"
    crumb = @options[:title] || module_name

    file_name = "content/#{identifier}.haml"
    directory = File.dirname(file_name)

    puts "DIRECTORY #{directory}"
    FileUtils.mkdir_p directory

    puts "   CREATE #{file_name}"
    open(file_name, "w") do |reference_file|
      contents = <<-CONTENTS
      | --- 
      | title: #{title}
      | crumb: #{crumb}
      | framework: #{stylesheet[:framework]}
      | stylesheet: #{stylesheet[:stylesheet]}
      | classnames:
      |   - reference
      | ---
      | - render 'reference' do
      |   %p
      |     Lorem ipsum dolor sit amet.
      CONTENTS
      reference_file.puts contents.gsub(/^ +\| /, '')

      puts "     ITEM /#{identifier}/"
    end
  end

  private
  def dereference(stylesheet)
    stylesheet = File.expand_path(stylesheet)
    framework = Compass::Frameworks::ALL.find{|f| stylesheet.index(f.stylesheets_directory) == 0}
    raise "No Framework found for #{stylesheet}" unless framework
    {
      :framework => framework.name,
      :stylesheet => stylesheet[framework.stylesheets_directory.length+1..-1]
    }
  end
end
