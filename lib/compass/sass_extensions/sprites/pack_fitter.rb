require 'forwardable'

module Compass
  module SassExtensions
    module Sprites
      class PackFitter

        attr_reader :images, :packed

        # Packing algorithm's relatively complex, you can find a great description
        # here: http://codeincomplete.com/posts/2011/5/7/bin_packing/
        def initialize(images)
          @images = images.sort do |a,b|
            diff = [b.width_with_spacing, b.height_with_spacing].max <=> [a.width_with_spacing, a.height_with_spacing].max
            diff = [b.width_with_spacing, b.height_with_spacing].min <=> [a.width_with_spacing, a.height_with_spacing].min if diff == 0
            diff = b.height_with_spacing <=> a.height_with_spacing if diff == 0
            diff = b.width_with_spacing <=> a.width_with_spacing if diff == 0
            diff
          end
          @root = { :x => 0, :y => 0, :w => @images[0].width_with_spacing, :h => @images[0].height_with_spacing }
          @packed = false
        end

        def pack!
          return @root if @packed
          
          @packed = true
          @images.each do |i|
            if node = find_node(@root, i.width_with_spacing, i.height_with_spacing)
              place_image(i, node)
              split_node(node, i.width_with_spacing, i.height_with_spacing)
            else
              @root = grow(@root, i.width_with_spacing, i.height_with_spacing)
              redo
            end
          end
          @root
        end

        def width
          pack![:w]
        end
        
        def height
          pack![:h]
        end

        protected
        def place_image(image, node)
          image.top = node[:y]+image.spacing
          image.left = node[:x]+image.spacing
        end
        
        def find_node(root, w, h)
          if root[:used]
            find_node(root[:right], w, h) || find_node(root[:down], w, h)
          elsif (w <= root[:w]) && (h <= root[:h])
            root
          end
        end
        
        def split_node(node, w, h)
          node[:used] = true
          node[:down] = {:x => node[:x], :y => node[:y] + h, :w => node[:w], :h => node[:h] - h}
          node[:right] = {:x => node[:x] + w, :y => node[:y], :w => node[:w] - w, :h => h}
        end
        

        def grow(root, w, h)
  
          canGrowDown  = (w <= root[:w])
          canGrowRight = (h <= root[:h])
  
          shouldGrowRight = canGrowRight && (root[:h] >= (root[:w] + w))
          shouldGrowDown  = canGrowDown  && (root[:w] >= (root[:h] + h))
  
          if shouldGrowRight
            grow_right(root, w, h)
          elsif shouldGrowDown
            grow_down(root, w, h)
          elsif canGrowRight
            grow_right(root, w, h)
          elsif canGrowDown
            grow_down(root, w, h)
          else
            raise RuntimeError, "can't fit #{w}x#{h} block into root #{root[:w]}x#{root[:h]} - this should not happen if images are pre-sorted correctly"
          end
  
        end
  
        def grow_right(root, w, h)
          return {
            :used  => true,
            :x     => 0,
            :y     => 0,
            :w     => root[:w] + w,
            :h     => root[:h],
            :down  => root,
            :right => { :x => root[:w], :y => 0, :w => w, :h => root[:h] }
          }
        end
  
        def grow_down(root, w, h)
          return {
            :used  => true,
            :x     => 0,
            :y     => 0,
            :w     => root[:w],
            :h     => root[:h] + h,
            :down  => { :x => 0, :y => root[:h], :w => root[:w], :h => h },
            :right => root
          }
        end
        
      end
    end
  end
end





