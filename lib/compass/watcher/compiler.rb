module Compass
  module Watcher
   class Compiler
      include Compass::Actions
      attr_reader :working_path, :memory_store, :backing_store, :cache_store, :compiler_options, :compiler

      def initialize(working_path, additional_options={})
        @working_path       = working_path
        @compiler_options   = create_compiler_options(additional_options)
        @memory_store     ||= Sass::CacheStores::Memory.new
        @backing_store    ||= compiler_options[:cache_store]
        @backing_store    ||= Sass::CacheStores::Filesystem.new(determine_cache_location)
        @cache_store      ||= Sass::CacheStores::Chain.new(@memory_store, @backing_store)
        @compiler         ||= create_compiler
      end

      def compile
        @memory_cache.reset! if @memory_cache
        compiler.reset_staleness_checker!
        if file = compiler.out_of_date?
          begin
            time = Time.now.strftime("%T")
            log_action(:info, "Change detected at #{time} to: #{compiler.relative_stylesheet_name(file)}", compiler_options)
            compiler.run
            GC.start
          rescue StandardError => e
            ::Compass::Exec::Helpers.report_error(e, compiler_options)
          end
        end
      end

    private #=========================================================================================>

      def create_compiler_options(additional_options)
        compiler_opts = {:sass => Compass.sass_engine_options, :cache_store => @cache_store, :quiet => true, :loud => [:identical, :overwrite, :create]}.merge(additional_options)
        compiler_opts[:cache_location] ||= determine_cache_location
        if compiler_opts.include?(:debug_info)
          compiler_opts[:sass][:debug_info] = compiler_opts.delete(:debug_info)
        end
        
        compiler_opts
      end

      def create_compiler
        @memory_store.reset!
        Compass::Compiler.new(
          working_path,
          Compass.configuration.sass_path,
          Compass.configuration.css_path,
          compiler_options.dup
        )
      end

      def determine_cache_location
        Compass.configuration.cache_path || Sass::Plugin.options[:cache_location] || File.join(working_path, ".sass-cache")
      end
    end
  end
end