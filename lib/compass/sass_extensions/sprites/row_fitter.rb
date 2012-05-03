require 'forwardable'

module Compass
  module SassExtensions
    module Sprites
      class RowFitter
        extend Forwardable

        attr_reader :images, :rows
        def_delegators :rows, :[]

        def initialize(images)
          @images = images.sort do |a,b|
            if a.height == b.height
              b.width <=> a.width
            else
              a.height <=> b.height
            end
          end
          @rows = []
        end

        def fit!(style = :scan)
          send("#{style}_fit")
          @rows
        end

        def width
          @width ||= @images.collect(&:width).max
        end
        
        def height
          @height ||= @rows.inject(0) {|sum, row| sum += row.height}
        end

        def efficiency
          @rows.inject(0) { |sum, row| sum += row.efficiency } ** @rows.length
        end

        private
        def new_row(image = nil)
          row = Compass::SassExtensions::Sprites::ImageRow.new(width)
          row.add(image) if image
          row
        end

        def fast_fit
          row = new_row
          @images.each do |image|
            if !row.add(image)
              @rows << row
              row = new_row(image)
            end
          end

          @rows << row
        end

        def scan_fit
          fast_fit

          moved_images = []

          begin
            removed = false

            catch :done do
              @rows.each do |row|
                (@rows - [ row ]).each do |other_row|
                  other_row.images.each do |image|
                    if !moved_images.include?(image)
                      if row.will_fit?(image)
                        other_row.delete(image)
                        row << image

                        @rows.delete(other_row) if other_row.empty?
                        removed = true

                        moved_images << image
                        throw :done
                      end
                    end
                  end
                end
              end
            end
          end while removed
        end
      end
    end
  end
end