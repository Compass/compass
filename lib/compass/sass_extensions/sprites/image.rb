module Compass
  module SassExtensions
    module Sprites
      class Image
        ACTIVE = %r{[_-]active$}
        TARGET = %r{[_-]target$}
        HOVER = %r{[_-]hover$}
        PARENT = %r{(.+)[-_](.+)$}

        REPEAT_X = 'repeat-x'
        NO_REPEAT = 'no-repeat'

        VALID_REPEATS = [REPEAT_X, NO_REPEAT]
        
        attr_reader :relative_file, :options, :base
        attr_accessor :top, :left

        def initialize(base, relative_file, options)
          @base, @relative_file, @options = base, relative_file, options
          @left = @top = 0
        end
        
        # The Full path to the image
        def file
          @file ||= find_file
        end
        
        def find_file
          Compass.configuration.sprite_load_path.compact.each do |path|
            f = File.join(path, relative_file)
            if File.exists?(f)
              return f
            end
          end
        end
        
        # Width of the image
        def width
          dimensions.first
        end
        
        def size
          @size ||= File.size(file)
        end
        
        # Height of the image
        def height
          dimensions.last
        end
        
        # Basename of the image
        def name
          File.basename(relative_file, '.png')
        end

        def get_var_file(var)
          options.get_var "#{base.name}_#{name}_#{var}"
        end

        # Value of <tt> $#{name}-repeat </tt> or <tt> $repeat </tt>
        def repeat 
          @repeat ||= begin 
            rep = (get_var_file("repeat") || options.get_var("repeat") || Sass::Script::String.new(NO_REPEAT)).value
            unless VALID_REPEATS.include? rep
              raise SpriteException, "Invalid option for repeat \"#{rep}\" - valid options are #{VALID_REPEATS.join(', ')}"
            end

            rep
          end
        end

        def repeat_x?
          repeat == REPEAT_X
        end

        def no_repeat?
          repeat == NO_REPEAT
        end

        # Value of <tt> $#{name}-position </tt> or <tt> $position </tt> defaults to <tt>0px</tt>
        def position
          @position||= get_var_file("position") || options.get_var("position") || Sass::Script::Number.new(0, ["px"])
        end
        
        # Offset within the sprite
        def offset
          @offset ||= (position.unitless? || position.unit_str == "px") ? position.value : 0
        end
               
        # Spacing between this image and the next
        def spacing
          @spacing ||= (get_var_file("spacing") || options.get_var("spacing") || Sass::Script::Number.new(0, ['px'])).value
        end

        # MD5 hash of this file
        def digest
          Digest::MD5.file(file).hexdigest
        end
        
        # mtime of this file
        def mtime
          File.mtime(file)
        end
        
        # Is hover selector
        def hover?
          name =~ HOVER
        end
        
        # Hover selector Image object if exsists
        def hover
          base.image_for("#{name}_hover")
        end
        
        # Is target selector
        def target?
          name =~ TARGET
        end
        
        # Target selector Image object if exsists
        def target
          base.image_for("#{name}_target")
        end
        
        # Is active selector
        def active?
          name =~ ACTIVE
        end
        
        # Active selector Image object if exsists
        def active
          base.image_for("#{name}_active")
        end
        
        
        def parent
          if [hover?, target?, active?].any?
            PARENT.match name
            base.image_for($1)
          end
        end
        
                
        private
          def dimensions
            @dimensions ||= Compass::SassExtensions::Functions::ImageSize::ImageProperties.new(file).size
          end
      end
    end
  end
end
