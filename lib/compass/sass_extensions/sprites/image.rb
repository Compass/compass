module Compass
  module SassExtensions
    module Sprites
      class Image
        attr_reader :relative_file, :options, :base
        attr_accessor :top, :left

        def initialize(base, relative_file, options)
          @base, @relative_file, @options = base, relative_file, options
          @left = @top = 0
        end
        
        # The Full path to the image
        def file
          File.join(Compass.configuration.images_path, relative_file)
        end
        
        # Width of the image
        def width
          dimensions.first
        end
        
        # Height of the image
        def height
          dimensions.last
        end
        
        # Basename of the image
        def name
          File.basename(relative_file, '.png')
        end

        # Value of <tt> $#{name}-repeat </tt> or <tt> $repeat </tt>
        def repeat
          [ "#{name}-repeat", "repeat" ].each { |which|
            if var = options.get_var(which)
              return var.value
            end
          }
          "no-repeat"
        end

        # Value of <tt> $#{name}-position </tt> or <tt> $position </tt> defaults o <tt>0px</tt>
        def position
          options.get_var("#{name}-position") || options.get_var("position") || Sass::Script::Number.new(0, ["px"])
        end
        
        # Offset within the sprite
        def offset
          (position.unitless? || position.unit_str == "px") ? position.value : 0
        end
        
        # Spacing between this image and the next
        def spacing
          (options.get_var("#{name}-spacing") || options.get_var("spacing") || Sass::Script::Number.new(0)).value
        end

        # MD5 hash of this file
        def digest
          Digest::MD5.file(file).hexdigest
        end
        
        # mtime of this file
        def mtime
          File.mtime(file)
        end
        
        # Has hover selector
        def hover?
          base.has_hover?(name)
        end
        
        # Hover selector Image object if exsists
        def hover
          base.image_for("#{name}_hover")
        end
        
        # Has target selector
        def target?
          base.has_target?(name)
        end
        
        # Target selector Image object if exsists
        def target
          base.image_for("#{name}_target")
        end
        
        # Has active selector
        def active?
          base.has_active?(name)
        end
        
        # Active selector Image object if exsists
        def active
          base.image_for("#{name}_active")
        end
                
        private
          def dimensions
            @dimensions ||= Compass::SassExtensions::Functions::ImageSize::ImageProperties.new(file).size
          end
      end
    end
  end
end
