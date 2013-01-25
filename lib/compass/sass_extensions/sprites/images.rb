module Compass
  module SassExtensions
    module Sprites
      class Images < Array

        def sort_by!(method)
          method = method.to_sym
          self.sort! do |a, b|
            unless a.send(method) == b.send(method)
              a.send(method) <=> b.send(method)
            else
              other = ([:name, :size] - [method]).first
              a.send(other) <=> b.send(other)
            end
          end
        end

      end
    end
  end
end