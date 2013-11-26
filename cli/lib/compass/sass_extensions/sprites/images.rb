module Compass
  module SassExtensions
    module Sprites
      class Images < Array

        def sort_by!(method)
          invert = false
          if method.to_s[0] == '!'[0] # have todo this for 1.8.7 compat
            method = method.to_s[1..-1]
            invert = true
          end
          method = method.to_sym
          self.sort! do |a, b|
            unless a.send(method) == b.send(method)
              a.send(method) <=> b.send(method)
            else
              other = ([:size, :name] - [method]).first
              a.send(other) <=> b.send(other)
            end
          end
          self.reverse! if invert
        end



      end
    end
  end
end