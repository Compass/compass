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

        def file
          File.join(Compass.configuration.images_path, relative_file)
        end

        def width
          dimensions.first
        end

        def height
          dimensions.last
        end

        def name
          File.basename(relative_file, '.png')
        end

        def repeat
          [ "#{name}-repeat", "repeat" ].each { |which|
            if var = options.get_var(which)
              return var.value
            end
          }
          "no-repeat"
        end

        def position
          options.get_var("#{name}-position") || options.get_var("position") || Sass::Script::Number.new(0, ["px"])
        end

        def offset
          (position.unitless? || position.unit_str == "px") ? position.value : 0
        end

        def spacing
          (options.get_var("#{name}-spacing") || options.get_var("spacing") || Sass::Script::Number.new(0)).value
        end

        def digest
          Digest::MD5.file(file).hexdigest
        end

        def mtime
          File.mtime(file)
        end
        
        def hover?
          base.has_hover?(name)
        end
        
        def hover
          base.image_for("#{name}_hover")
        end
        
        def target?
          base.has_target?(name)
        end
        
        def target
          base.image_for("#{name}_target")
        end
        
        def active?
          base.has_active?(name)
        end
        
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
