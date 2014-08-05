module Compass
  module Configuration
    # The serialization module manages reading and writing the configuration file(s).
    module Serialization
      def parse(config_file)
        raise Compass::Error, "Compass.configuration.parse(filename) has been removed. Please call Compass.add_project_configuration(filename) instead."
      end

      # parses a configuration file which is a ruby script
      def _parse(config_file)
        unless File.readable?(config_file)
          raise Compass::Error, "Configuration file, #{config_file}, not found or not readable."
        end
        open(config_file) do |f|
          parse_string(f.read, config_file)
        end
      end

      def get_binding
        binding
      end
      def parse_string(contents, filename)
        bind = get_binding
        eval(contents, bind, filename)
        local_vars_set = eval("local_variables", bind)
        local_vars_set.each do |local_var|
          if (ATTRIBUTES+ARRAY_ATTRIBUTES).include?(local_var.to_sym)
            value = eval(local_var.to_s, bind)
            value = value.to_s if value.is_a?(Pathname)
            self.send("#{local_var}=", value)
          end
        end
        if @added_import_paths
          @added_import_paths.each do |p|
            self.additional_import_paths << p unless self.additional_import_paths.include?(p)
          end
        end
        issue_deprecation_warnings
      end

      def serialize
        contents = ""
        (required_libraries || []).each do |lib|
          contents << %Q{require '#{lib}'\n}
        end
        unless (required_libraries || []).include?("compass/import-once/activate") ||
               (required_libraries || []).include?("compass/import-once")
          contents << "require 'compass/import-once/activate'\n"
        end
        (loaded_frameworks || []).each do |lib|
          contents << %Q{load '#{lib}'\n}
        end
        (framework_path || []).each do |lib|
          contents << %Q{discover '#{lib}'\n}
        end
        contents << "# Require any additional compass plugins here.\n"
        contents << "\n" if (required_libraries || []).any?
        (ATTRIBUTES + ARRAY_ATTRIBUTES).each do |prop|
          value = send("#{prop}_without_default")
          if value.is_a?(Proc)
            $stderr.puts "WARNING: #{prop} is code and cannot be written to a file. You'll need to copy it yourself."
          end
          if respond_to?("comment_for_#{prop}")
            contents << "\n"
            contents << send("comment_for_#{prop}")
          end
          if block_given? && (to_emit = yield(prop, value))
            contents << to_emit
          else
            contents << serialize_property(prop, value) unless value.nil?
          end
        end
        contents
      end

      def serialize_property(prop, value)
        if value.respond_to?(:serialize_to_config)
          value.serialize_to_config(prop) + "\n"
        else
          %Q(#{prop} = #{value.inspect}\n)
        end
      end

      def issue_deprecation_warnings
        if http_images_path == :relative
          $stderr.puts "DEPRECATION WARNING: Please set relative_assets = true to enable relative paths."
        end
      end

    end
    class Data
      include Serialization
    end
  end
end
