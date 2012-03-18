module Compass
  module Configuration
    # The Compass configuration data storage class manages configuration data that comes from a variety of
    # different sources and aggregates them together into a consistent API
    # Some of the possible sources of configuration data:
    #   * Compass default project structure for stand alone projects
    #   * App framework specific project structures for rails, etc.
    #   * User supplied explicit configuration
    #   * Configuration data provided via the command line interface
    #
    # There are two kinds of configuration data that doesn't come from the user:
    #
    # 1. Configuration data that is defaulted as if the user had provided it themselves.
    #    This is useful for providing defaults that the user is likely to want to edit
    #    but shouldn't have to provide explicitly when getting started
    # 2. Configuration data that is defaulted behind the scenes because _some_ value is
    #    required.
    class Data

      attr_reader :name
      extend Sass::Callbacks


      include Compass::Configuration::Inheritance
      include Compass::Configuration::Serialization
      include Compass::Configuration::Adapters
      extend  Compass::Configuration::Paths

      # on_sprite_saved
      # yields the filename
      # usage: on_sprite_saved {|filename| do_something(filename) }
      define_callback :sprite_saved
      chained_method :run_sprite_saved

      # on_sprite_generated
      # yields 'ChunkyPNG::Image'
      # usage: on_sprite_generated {|sprite_data| do_something(sprite_data) }
      define_callback :sprite_generated
      chained_method :run_sprite_generated

      # on_sprite_removed
      # yields the filename
      # usage: on_sprite_removed {|filename| do_something(filename) }
      define_callback :sprite_removed
      chained_method :run_sprite_removed

      # on_stylesheet_saved
      # yields the filename
      # usage: on_stylesheet_saved {|filename| do_something(filename) }
      define_callback :stylesheet_saved
      chained_method :run_stylesheet_saved

      # on_stylesheet_error
      # yields the filename & message
      # usage: on_stylesheet_error {|filename, message| do_something(filename, message) }
      define_callback :stylesheet_error
      chained_method :run_stylesheet_error

      inherited_accessor *ATTRIBUTES

      strip_trailing_separator *ATTRIBUTES.select{|a| a.to_s =~ /dir|path/}

      inherited_array *ARRAY_ATTRIBUTES

      def initialize(name, attr_hash = nil)
        raise "I need a name!" unless name
        @name = name
        set_all(attr_hash) if attr_hash
        self.top_level = self
      end

      def set_all(attr_hash)
        # assert_valid_keys!(attr_hash)
        attr_hash.each do |a, v|
          if self.respond_to?("#{a}=")
            self.send("#{a}=", v)
          end
        end
      end

      def add_import_path(*paths)
        paths.map!{|p| defined?(Pathname) && Pathname === p ? p.to_s : p}
        # The @added_import_paths variable works around an issue where
        # the additional_import_paths gets overwritten during parse
        @added_import_paths ||= []
        @added_import_paths += paths
        self.additional_import_paths ||= []
        self.additional_import_paths += paths
      end

      # When called with a block, defines the asset host url to be used.
      # The block must return a string that starts with a protocol (E.g. http).
      # The block will be passed the root-relative url of the asset.
      # When called without a block, returns the block that was previously set.
      def asset_host(&block)
        @set_attributes ||= {}
        if block_given?
          @set_attributes[:asset_host] = true
          @asset_host = block
        else
          if @asset_host
            @asset_host
          elsif inherited_data.respond_to?(:asset_host)
            inherited_data.asset_host
          end
        end
      end

      # When called with a block, defines the cache buster strategy to be used.
      # If the block returns nil or a string, then it is appended to the url as a query parameter.
      # In this case, the returned string must not include the starting '?'.
      # The block may also return a hash with :path and/or :query values and it
      # will replace the original path and query string with the busted values returned.
      # The block will be passed the root-relative url of the asset.
      # If the block accepts two arguments, it will also be passed a File object
      # that points to the asset on disk -- which may or may not exist.
      # When called without a block, returns the block that was previously set.
      #
      # To disable the asset cache buster:
      #
      #     asset_cache_buster :none
      def asset_cache_buster(simple = nil, &block)
        @set_attributes ||= {}
        if block_given?
          @set_attributes[:asset_cache_buster] = true
          @asset_cache_buster = block
        elsif !simple.nil?
          if simple == :none
            @set_attributes[:asset_cache_buster] = true
            @asset_cache_buster = Proc.new {|_,_| nil}
          else
            raise ArgumentError, "Unexpected argument: #{simple.inspect}"
          end
        else
          if set?(:asset_cache_buster)
            @asset_cache_buster
          elsif inherited_data.respond_to?(:asset_cache_buster)
            inherited_data.asset_cache_buster
          end
        end
      end

      def watch(glob, &block)
        @watches ||= []
        @watches << [glob, block]
      end
      
      def watches
        if defined?(@watches)
          @watches
        elsif inherited_data.respond_to?(:watches)
          inherited_data.watches
        else
          []
        end
      end

      # Require a compass plugin and capture that it occured so that the configuration serialization works next time.
      def require(lib)
        (self.required_libraries ||= []) << lib
        super
      end

      def load(framework_dir)
        (self.loaded_frameworks ||= []) << framework_dir
        Compass::Frameworks.register_directory framework_dir
      end

      # Finds all extensions within a directory and registers them.
      def discover(frameworks_dir)
        (self.framework_path ||= []) << frameworks_dir
        Compass::Frameworks.discover frameworks_dir
      end

      def relative_assets?
        # the http_images_path is deprecated, but here for backwards compatibility.
        relative_assets || http_images_path == :relative
      end

      private

      def assert_valid_keys!(attr_hash)
        illegal_attrs = attr_hash.keys - ATTRIBUTES - ARRAY_ATTRIBUTES
        if illegal_attrs.size == 1
          raise Error, "#{illegal_attrs.first.inspect} is not a valid configuration attribute."
        elsif illegal_attrs.size > 0
          raise Error, "Illegal configuration attributes: #{illegal_attrs.map{|a| a.inspect}.join(", ")}"
        end
      end

    end
  end
end
