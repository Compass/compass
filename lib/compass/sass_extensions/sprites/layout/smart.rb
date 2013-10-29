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
            width = 0
            height = 0
            last_row_spacing = 9999
            fitter.fit!.each do |row|
              current_x = 0
              current_x = 0
              row_height = 0
              row.images.each_with_index do |image, index|
                extra_y = [image.spacing - last_row_spacing,0].max
                if index > 0
                  last_image = row.images[index-1]
                  current_x += [image.spacing, last_image.spacing].max
                end
                image.left = current_x
                image.top = current_y + extra_y
                current_x += image.width
                width = [width, current_x].max
                row_height = [row_height, extra_y + image.height + image.spacing].max
              end
              current_y += row.height
              height = [height, current_y].max
              last_row_spacing = row_height - row.height
              current_y += last_row_spacing
            end
            @width = fitter.width
            @height = fitter.height
          end

        end
      end
    end
  end
end
