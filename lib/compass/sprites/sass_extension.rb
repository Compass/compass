module Sass

  module Tree

    class RootNode < Node

      alias_method :render_without_sprites, :render
      def render
        if result = render_without_sprites
          Compass::Sprites.generate_sprites
          result = ERB.new(result).result(binding)
          Compass::Sprites.reset
          return result
        end
      end

    end

  end

end
