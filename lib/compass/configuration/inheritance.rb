module Compass
  module Configuration
    # The inheritance module makes it easy for configuration data to inherit from
    # other instances of configuration data. This makes it easier for external code to layer
    # bits of configuration from various sources.
    module Inheritance

      def self.included(base)
        # inherited_data stores configuration data that this configuration object will
        # inherit if not provided explicitly.
        base.send :attr_accessor, :inherited_data, :set_attributes, :top_level

        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inherited_writer(*attributes)
          attributes.each do |attribute|
            line = __LINE__ + 1
            class_eval %Q{
              def #{attribute}=(value)                        # def css_dir=(value)
                @set_attributes ||= {}                        #   @set_attributes ||= {}
                @set_attributes[#{attribute.inspect}] = true  #   @set_attributes[:css_dir] = true
                @#{attribute} = value                         #   @css_dir = value
              end                                             # end

              def unset_#{attribute}!                         # def unset_css_dir!
                unset!(#{attribute.inspect})                  #   unset!(:css_dir)
              end                                             # end

              def #{attribute}_set?                           # def css_dir_set?
                set?(#{attribute.inspect})                    #   set?(:css_dir)
              end                                             # end
            }, __FILE__, line
          end
        end

        # Defines the default reader to be an inherited_reader that will look at the inherited_data for its
        # value when not set. The inherited reader calls to a raw reader that acts like a normal attribute
        # reader but prefixes the attribute name with "raw_".
        def inherited_reader(*attributes)
          attributes.each do |attribute|
            line = __LINE__ + 1
            class_eval %Q{
              def raw_#{attribute}                         # def raw_css_dir
                @#{attribute}                              #   @css_dir
              end                                          # end
              def #{attribute}_without_default             # def css_dir_without_default
                read_without_default(#{attribute.inspect}) #  read_without_default(:css_dir)
              end                                          # end
              def #{attribute}                             # def css_dir
                read(#{attribute.inspect})                 #  read(:css_dir)
              end                                          # end
            }, __FILE__, line
          end
        end

        def inherited_accessor(*attributes)
          inherited_reader(*attributes)
          inherited_writer(*attributes)
        end

        class ArrayProxy
          def initialize(data, attr)
            @data, @attr = data, attr
          end
          def to_ary
            @data.send(:"read_inherited_#{@attr}_array")
          end
          def to_a
            to_ary
          end
          def <<(v)
            @data.send(:"add_to_#{@attr}", v)
          end
          def >>(v)
            @data.send(:"remove_from_#{@attr}", v)
          end
          def serialize_to_config(prop)
            if v = @data.raw(prop)
              "#{prop} = #{v.inspect}"
            else
              s = ""
              if added = @data.instance_variable_get("@added_to_#{@attr}")
                added.each do |a|
                  s << "#{prop} << #{a.inspect}\n"
                end
              end
              if removed = @data.instance_variable_get("@removed_from_#{@attr}")
                removed.each do |r|
                  s << "#{prop} >> #{r.inspect}\n"
                end
              end
              if s[-1..-1] == "\n"
                s[0..-2]
              else
                s
              end
            end
          end
          def method_missing(m, *args, &block)
            a = to_ary
            if a.respond_to?(m)
              a.send(m,*args, &block)
            else
              super
            end
          end
        end

        def inherited_array(*attributes)
          inherited_reader(*attributes)
          inherited_writer(*attributes)
          attributes.each do |attr|
            line = __LINE__ + 1
            class_eval %Q{
              def #{attr}                                          # def sprite_load_paths
                ArrayProxy.new(self, #{attr.inspect})              #   ArrayProxy.new(self, :sprite_load_paths)
              end                                                  # end
              def #{attr}=(value)                                  # def sprite_load_paths=(value)
                @set_attributes ||= {}                             #   @set_attributes ||= {}
                @set_attributes[#{attr.inspect}] = true            #   @set_attributes[:sprite_load_paths] = true
                @#{attr} = Array(value)                            #   @sprite_load_paths = Array(value)
                @added_to_#{attr} = []                             #   @added_to_sprite_load_paths = []
                @removed_from_#{attr} = []                         #   @removed_from_sprite_load_paths = []
              end                                                  # end
              def read_inherited_#{attr}_array                     # def read_inherited_sprite_load_paths_array
                if #{attr}_set?                                    #  if sprite_load_paths_set?
                  @#{attr}                                         #    Array(@#{attr})
                else                                               #  else
                  value = if inherited_data                        #    value = Array(read(:sprite_load_paths))
                    Array(inherited_data.#{attr})
                  else
                    Array(read(#{attr.inspect}))
                  end
                  value -= Array(@removed_from_#{attr})            #    value -= Array(@removed_from_sprite_load_paths)
                  Array(@added_to_#{attr}) + value                 #    Array(@added_to_sprite_load_paths) + value
                end                                                #  end
              end                                                  # end
              def add_to_#{attr}(v)                                # def add_to_sprite_load_paths(v)
                if #{attr}_set?                                    #   if sprite_load_paths_set?
                  raw_#{attr} << v                                 #     raw_sprite_load_paths << v
                else                                               #   else
                  (@added_to_#{attr} ||= []) << v                  #     (@added_to_sprite_load_paths ||= []) << v
                end                                                #   end
              end                                                  # end
              def remove_from_#{attr}(v)                           # def remove_from_sprite_load_paths(v)
                if #{attr}_set?                                    #   if sprite_load_paths_set?
                  raw_#{attr}.reject!{|e| e == v}                  #     raw_sprite_load_path.reject!{|e| e == v}s
                else                                               #   else
                  (@removed_from_#{attr} ||= []) << v              #     (@removed_from_sprite_load_paths ||= []) << v
                end                                                #   end
              end                                                  # end
            }, __FILE__, line
          end
        end

        def chained_method(method)
          line = __LINE__ + 1
          class_eval %Q{
            alias_method :_chained_#{method}, method
            def #{method}(*args, &block)
              _chained_#{method}(*args, &block)
              if inherited_data
                inherited_data.#{method}(*args, &block)
              end
            end
          }, __FILE__, line
        end

        
      end

      module InstanceMethods

        def on_top!
          self.set_top_level(self)
        end

        def set_top_level(new_top)
          self.top_level = new_top
          if self.inherited_data.respond_to?(:set_top_level)
            self.inherited_data.set_top_level(new_top)
          end
        end


        def inherit_from!(data)
          if self.inherited_data
            self.inherited_data.inherit_from!(data)
          else
            self.inherited_data = data
          end
          self
        end

        def reset_inheritance!
          self.inherited_data = nil
        end

        def with_defaults(data)
          inherit_from!(data)
          yield
          reset_inheritance!
        end

        def unset!(attribute)
          @set_attributes ||= {}
          send("#{attribute}=", nil)
          @set_attributes.delete(attribute)
          nil
        end

        def set?(attribute)
          @set_attributes ||= {}
          @set_attributes[attribute]
        end

        def any_attributes_set?
          @set_attributes && @set_attributes.size > 0
        end

        def default_for(attribute)
          method = "default_#{attribute}".to_sym
          if respond_to?(method)
            send(method)
          end
        end

        # Read an explicitly set value that is either inherited or set on this instance
        def read_without_default(attribute)
          if set?(attribute)
            send("raw_#{attribute}")
          elsif inherited_data.nil?
            nil
          elsif inherited_data.respond_to?("#{attribute}_without_default")
            inherited_data.send("#{attribute}_without_default")
          elsif inherited_data.respond_to?(attribute)
            inherited_data.send(attribute)
          end
        end

        # Reads the raw value that was set on this object.
        # you generally should call raw_<attribute>() instead.
        def raw(attribute)
          instance_variable_get("@#{attribute}")
        end

        # Read a value that is either inherited or set on this instance, if we get to the bottom-most configuration instance,
        # we ask for the default starting at the top level.
        def read(attribute)
          if !(v = send("#{attribute}_without_default")).nil?
            v
          else
            top_level.default_for(attribute)
          end
        end

        def method_missing(meth, *args, &block)
          if inherited_data
            inherited_data.send(meth, *args, &block)
          else
            raise NoMethodError, meth.to_s
          end
        end

        def respond_to?(meth)
          if super
            true
          elsif inherited_data
            inherited_data.respond_to?(meth)
          else
            false
          end
        end

        def chain
          instances = [self]
          instances << instances.last.inherited_data while instances.last.inherited_data
          instances
        end

        def debug
          normalized_attrs = {}
          ATTRIBUTES.each do |prop|
            values = []
            chain.each do |instance|
              values << {
                :raw => (instance.send("raw_#{prop}") rescue nil),
                :value => (instance.send("#{prop}_without_default") rescue nil),
                :default => (instance.send("default_#{prop}") rescue nil),
                :resolved => instance.send(prop)
              }
            end
            normalized_attrs[prop] = values
          end
          normalized_attrs
        end

      end
    end
  end
end
