module Compass
  module SassExtensions
    module Sprites
      module SpriteMethods
        
        # Changing this string will invalidate all previously generated sprite images.
        # We should do so only when the packing algorithm changes
        SPRITE_VERSION = "2"
        
        # Calculates the overal image dimensions
        # collects image sizes and input parameters for each sprite
        # Calculates the height
        def compute_image_metadata!
          @width = 0
          init_images
          compute_image_positions!
          init_engine
        end
        
        def init_engine
          @engine = eval("::Compass::SassExtensions::Sprites::#{modulize}Engine.new(nil, nil, nil)")
          @engine.width = @width
          @engine.height = @height
          @engine.images = @images
        end
        
        # Creates the Sprite::Image objects for each image and calculates the width
        def init_images
          @images = Images.new
          image_names.each do |relative_file|
            @images << Image.new(self, relative_file, kwargs)
          end
          unless sort_method == 'none'
            @images.sort_by! sort_method
          end
        end

        def name_and_hash
          "#{path}-s#{uniqueness_hash}.png"
        end

        # The on-the-disk filename of the sprite
        def filename
          File.join(Compass.configuration.generated_images_path, name_and_hash)
        end

        def relativize(path)
          Pathname.new(path).relative_path_from(Pathname.new(Dir.pwd)).to_s rescue path
        end

        # Generate a sprite image if necessary
        def generate
          if generation_required?
            if kwargs.get_var('cleanup').value
              cleanup_old_sprites
            end
            engine.construct_sprite
            Compass.configuration.run_sprite_generated(engine.canvas)
            save!
          else
            log :unchanged, filename
          end
        end
        
        def cleanup_old_sprites
          Sass::Util.glob(File.join(Compass.configuration.generated_images_path, "#{path}-s*.png")).each do |file|
            log :remove, file
            FileUtils.rm file
            Compass.configuration.run_sprite_removed(file)
          end
        end
        
        # Does this sprite need to be generated
        def generation_required?
          !File.exists?(filename) || outdated? || options[:force]
        end

        # Returns the uniqueness hash for this sprite object
        def uniqueness_hash
          @uniqueness_hash ||= begin
            sum = Digest::MD5.new
            sum << SPRITE_VERSION
            sum << path
            sum << layout
            images.each do |image|
              [:relative_file, :height, :width, :repeat, :spacing, :position, :digest].each do |attr|
                sum << image.send(attr).to_s
              end
            end
            sum.hexdigest[0...10]
          end
          @uniqueness_hash
        end

        # Saves the sprite engine
        def save!
          FileUtils.mkdir_p(File.dirname(filename))
          saved = engine.save(filename)
          log :create, filename
          Compass.configuration.run_sprite_saved(filename)
          @mtime = nil if saved
          saved
        end

        # All the full-path filenames involved in this sprite
        def image_filenames
          @images.map(&:file)
        end

        # Checks whether this sprite is outdated
        def outdated?
          if File.exists?(filename)
            return @images.any? {|image| image.mtime.to_i > self.mtime.to_i }
          end
          true
        end

        # Mtime of the sprite file
        def mtime
          @mtime ||= File.mtime(filename)
        end
        
       # Calculate the size of the sprite
        def size
          [width, height]
        end

        def log(action, filename, *extra)
          if options[:compass] && options[:compass][:logger] && !options[:quiet]
            options[:compass][:logger].record(action, relativize(filename), *extra)
          end
        end
      end
    end
  end
end
