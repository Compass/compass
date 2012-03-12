module Compass
  module Configuration
    # Comments are emitted into the configuration file when serialized and make it easier to understand for new users.
    module Comments

      def comment_for_http_path
        unless top_level.http_path_without_default
          "# Set this to the root of your project when deployed:\nhttp_path = #{top_level.http_path.to_s.inspect}\n"
        else
          ""
        end
      end

      def comment_for_relative_assets
        unless top_level.relative_assets
          %q{# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
}
        else
          ""
        end
      end

      def comment_for_line_comments
        if top_level.line_comments
          %q{# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false
}
        else
          ""
        end
      end

      def comment_for_output_style
        unless top_level.output_style_without_default
          %Q{# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
}
        else
          ""
        end
      end

      def comment_for_preferred_syntax
        if top_level.preferred_syntax == :scss && top_level.sass_dir
          %Q{
# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass #{top_level.sass_dir} scss && rm -rf sass && mv scss sass
}
        else
          ""
        end
      end
    end
  end
end
