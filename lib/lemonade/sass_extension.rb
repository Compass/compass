module Sass

  module Tree

    class RootNode < Node

      alias_method :render_without_lemonade, :render
      def render
        if result = render_without_lemonade
          Lemonade.generate_sprites
          result = ERB.new(result).result(binding)
          Lemonade.reset
          return result
        end
      end

    end

  end

end
