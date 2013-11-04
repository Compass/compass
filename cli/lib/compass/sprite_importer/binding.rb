require 'ostruct'
module Compass
  module Sprites
    class Binding < OpenStruct
      
      def get_binding
        binding
      end
    end
  end
end