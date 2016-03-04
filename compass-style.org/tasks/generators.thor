require 'bundler'
Bundler.setup

require 'fileutils'
require 'compass'

COMPASS_DIR = File.expand_path(File.join(File.dirname(__FILE__), "../.."))

class Generate < Thor
  desc "example path/to/module", "Generate a new example."

  method_option :title, :type => :string, :aliases => "-t", :desc => %(Title of the example.)
  method_option :description, :type => :string, :aliases => "-d", :desc => %(Description of the example, which is shown below the link.)
  method_option :mixin, :type => :string, :aliases => "-m", :desc => %(Name of the specific mixin in the module if the example isn't about the whole module.)

  def example(module_path)
    module_path = module_path.dup
    module_path = "compass/#{module_path.chomp("/")}"

    options = @options.merge(:stylesheet => stylesheet_path(module_path))

    title = options[:title] || (options[:mixin] && titleize(options[:mixin])) || titleize(File.basename(module_path))

    directory = "examples/#{module_path}"
    puts "Generating /#{directory}/"
    puts "DIRECTORY content/#{directory}/"
    FileUtils.mkdir_p("content/#{directory}/")

    file_name = "content/examples/#{module_path}.haml"
    puts "   CREATE #{file_name}"
    open(file_name, "w") do |example_file|
      mixin = "mixin: #{options[:mixin]}\n" if options[:mixin]
      example_contents = <<-EXAMPLE
      | ---
      | title: #{title}
      | description: #{options[:description] || "How to use #{title}"}
      | framework: compass
      | stylesheet: #{options[:stylesheet]}
      | #{mixin}example: true
      | ---
      | - render "partials/example" do
      |   %p Lorem ipsum dolor sit amet.
      EXAMPLE
      example_file.puts example_contents.gsub(/^ +\| /, '')
    end

    file_name = "content/examples/#{module_path}/markup.haml"
    puts "   CREATE #{file_name}"
    open(file_name, "w") do |example_file|
      example_contents = <<-EXAMPLE
        | .example
        |   .title #{title}
        |   %p This file gets included into the example.
        |   %p And the source is shown to the user as HTML and as Haml.
      EXAMPLE
      example_file.puts example_contents.gsub(/^ +\| /, '')
    end

    file_name = "content/examples/#{module_path}/stylesheet.scss"
    puts "   CREATE #{file_name}"
    open(file_name, "w") do |example_file|
      example_contents = <<-EXAMPLE
        | @import "#{module_path}";
        |
        | // This file is used to style the example markup.
        | // And the source is shown to the user as SCSS, Sass and as CSS.
        |
        | .example {
        |   .title {
        |     font-size: 36px;
        |     margin-bottom: 30px;
        |     color: #333;
        |     border: none;
        |   }
        |
        |   p { color: #666; }
        | }
      EXAMPLE
      example_file.puts example_contents.gsub(/^ +\| /, '')
    end
  end

  desc "reference path/to/module", "Generate a reference page for the given module."

  method_option :title, :type => :string, :aliases => "-t", :desc => %(Title of the reference.)

  def reference(module_path)
    module_path = module_path.dup
    module_path = "compass/#{module_path.chomp("/")}"

    options = @options.merge(:stylesheet => stylesheet_path(module_path))

    title = options[:title] || titleize(File.basename(module_path))

    directory = "reference/#{module_path}"
    puts "Generating /#{directory}/"
    puts "DIRECTORY content/#{directory}/"
    FileUtils.mkdir_p "content/#{directory}"

    file_name = "content/reference/#{module_path}.haml"
    puts "   CREATE #{file_name}"
    open(file_name, "w") do |reference_file|
      contents = <<-REFERENCE
      | ---
      | title: Compass #{title}
      | crumb: #{title}
      | framework: compass
      | stylesheet: #{options[:stylesheet]}
      | layout: core
      | classnames:
      |   - reference
      |   - core
      | ---
      | - render "reference" do
      |   %p Lorem ipsum dolor sit amet.
      REFERENCE
      reference_file.puts contents.gsub(/^ +\| /, '')
    end
  end

  private
  def titleize(string)
    string.split('-').map(&:capitalize).join(' ')
  end

  def stylesheet_path(module_path)
    array = module_path.split("/")
    stylesheet_name = array.pop
    prefix = array.join("/")

    stylesheet = Dir["../core/stylesheets/#{prefix}/_#{stylesheet_name}.{scss,sass}"].first
    raise "no stylesheet found for module #{module_path}" if stylesheet.nil?
    stylesheet = File.expand_path(stylesheet)

    "#{prefix}/#{File.basename(stylesheet)}"
  end
end
