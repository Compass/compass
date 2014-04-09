module Compass
  module SassExtensions
    module Sprites
      module Layout
        class Smart < SpriteLayout

          def layout!
            calculate_positions!
          end

        private # ===========================================================================================>

          def calculate_positions!
            fitter = ::Compass::SassExtensions::Sprites::RowFitter.new(@images)
            current_y = 0
            
            extra_x = 0
            extra_y = 0
            
            fitter.fit!.each do |row|
              current_x = 0
              row.images.each_with_index do |image, index|
                
                if current_x.odd?
                  current_x += 3
                  extra_x += 3
                else
                  current_x += 2
                  extra_x += 2
                end
                
                if current_y.odd?
                  current_y += 1
                  extra_y += 1
                end
                
                image.left = current_x
                image.top = current_y
                current_x += image.width
              end
              
              current_y += row.height + 2
              extra_y += 2
            end
            @width = fitter.width + extra_x
            @height = fitter.height + extra_y
          end
          
        end
      end
    end
  end
end
