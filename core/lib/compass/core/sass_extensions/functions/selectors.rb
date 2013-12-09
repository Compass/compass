module Compass::Core::SassExtensions::Functions::Selectors
  COMMA_SEPARATOR = /\s*,\s*/

  # Permute multiple selectors each of which may be comma delimited, the end result is
  # a new selector that is the equivalent of nesting each under the previous selector.
  # To illustrate, the following mixins are equivalent:
  #
  #     @include mixin-a($selector1, $selector2, $selector3) {
  #       #{$selector1} {
  #         #{$selector2} {
  #           #{$selector3} {
  #             width: 2px
  #           }
  #         }
  #       }
  #     }
  #     @include mixin-b($selector1, $selector2, $selector3) {
  #       #{nest($selector, $selector2, $selector3)} {
  #         width: 2px
  #       }
  #     }
  def nest(*arguments)
    nested = arguments.map{|a| a.value}.inject do |memo,arg|
      ancestors = memo.split(COMMA_SEPARATOR)
      descendants = arg.split(COMMA_SEPARATOR)
      ancestors.map{|a| descendants.map{|d| "#{a} #{d}"}.join(", ")}.join(", ")
    end
    unquoted_string(nested)
  end

  # Permute two selectors, the first may be comma delimited.
  # The end result is a new selector that is the equivalent of nesting the second
  # selector under the first one in a sass file and preceding it with an &.
  # To illustrate, the following mixins are equivalent, except the second
  # mixin handles:
  #
  #     @include mixin-a($selector, $to-append) {
  #       #{$selector} {
  #         &#{$to-append} {
  #           width: 2px
  #         }
  #       }
  #     }
  #     
  #     @include mixin-b($selector, $to-append) {
  #       #{append_selector($selector, $to-append)} {
  #         width: 2px
  #       }
  #     }
  def append_selector(selector, to_append)
    ancestors = selector.value.split(COMMA_SEPARATOR)
    descendants = to_append.value.split(COMMA_SEPARATOR)
    nested = ancestors.map{|a| descendants.map{|d| "#{a}#{d}"}.join(", ")}.join(", ")
    unquoted_string(nested)
  end

  # Return the header selectors for the levels indicated
  # Defaults to all headers h1 through h6
  # For example:
  # headers(all) => h1, h2, h3, h4, h5, h6
  # headers(4) => h1, h2, h3, h4
  # headers(2,4) => h2, h3, h4
  def headers(from = nil, to = nil)
    if from && !to
      if from.is_a?(Sass::Script::Value::String) && from.value == "all"
        from = number(1)
        to = number(6)
      else
        to = from
        from = number(1)
      end
    else
      from ||= number(1)
      to ||= number(6)
    end
    list((from.value..to.value).map{|n| identifier("h#{n}")}, :comma)
  end
  alias headings headers
end
