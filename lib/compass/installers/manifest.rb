module Compass
  module Installers

    class Manifest
      include Enumerable

      # A Manifest entry
      class Entry < Struct.new(:type, :from, :options)
        def to
          options[:to] || from
        end
      end

      attr_reader :options
      def initialize(manifest_file = nil, options = {})
        @entries = []
        @options = options
        @generate_config = true
        @compile_after_generation = true
        parse(manifest_file) if manifest_file
      end

      def self.known_extensions
        @known_extensions ||= {}
      end

      def self.plural_types
        @plural_types ||= {}
      end

      def self.type(t, options = {})
        Array(options[:extensions]).each do |ext|
          self.known_extensions[ext] = t
        end
        self.plural_types[options[:plural]] = t if options[:plural]
        eval <<-END
          def #{t}(from, options = {})
             @entries << Entry.new(:#{t}, from, options)
          end
          def has_#{t}?
            @entries.detect {|e| e.type == :#{t}}
          end
          def each_#{t}
            @entries.select {|e| e.type == :#{t}}.each {|e| yield e}
          end
        END
      end

      type :stylesheet, :plural => :stylesheets, :extensions => %w(scss sass)
      type :image,      :plural => :images,      :extensions => %w(png gif jpg jpeg tiff gif)
      type :javascript, :plural => :javascripts, :extensions => %w(js)
      type :font,       :plural => :fonts,       :extensions => %w(eot otf woff ttf)
      type :html,       :plural => :html,        :extensions => %w(html haml)
      type :file,       :plural => :files
      type :directory,  :plural => :directories

      def discover(type)
        type = self.class.plural_types[type] || type
        dir = File.dirname(@manifest_file)
        Dir.glob("#{dir}/**/*").each do |file|
          next if /manifest\.rb/ =~ file
          short_name = file[(dir.length+1)..-1]
          options = {}
          ext = if File.extname(short_name) == ".erb"
            options[:erb] = true
            File.extname(short_name[0..-5])
          else
            File.extname(short_name)
          end[1..-1]
          file_type = self.class.known_extensions[ext]
          file_type = :file if file_type.nil?
          file_type = :directory if File.directory?(file)
          if type == :all || type == file_type
            send(file_type, short_name, options)
          end
        end
      end

      def help(value = nil)
        if value
          @help = value
        else
          @help
        end
      end

      attr_reader :welcome_message_options

      def welcome_message(value = nil, options = {})
        if value
          @welcome_message = value
          @welcome_message_options = options
        else
          @welcome_message
        end
      end

      def welcome_message_options
        @welcome_message_options || {}
      end

      def description(value = nil)
        if value
          @description = value
        else
          @description
        end
      end

      # Enumerates over the manifest files
      def each
        @entries.each {|e| yield e}
      end

      def generate_config?
        @generate_config
      end

      def compile?
        @compile_after_generation
      end

      protected

      def no_configuration_file!
        @generate_config = false
      end

      def skip_compilation!
        @compile_after_generation = false
      end

      def with_manifest(manifest_file)
        @manifest_file = manifest_file
        yield
      ensure
        @manifest_file = nil
      end

      # parses a manifest file which is a ruby script
      # evaluated in a Manifest instance context
      def parse(manifest_file)
        with_manifest(manifest_file) do
          if File.exists?(manifest_file)
            open(manifest_file) do |f| 
              eval(f.read, instance_binding, manifest_file)
            end 
          else
              eval("discover :all", instance_binding, manifest_file)
          end 
        end 
      end 


      def instance_binding
        binding
      end
    end

  end
end
