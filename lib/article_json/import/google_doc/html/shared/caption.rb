module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        module Shared
          module Caption
            # Parse the caption node
            # @return [Array[ArticleJSON::Elements::Text]]
            def caption
              return [] if no_caption?
              ArticleJSON::Import::GoogleDoc::HTML::TextParser.extract(
                node: @caption_node,
                css_analyzer: @css_analyzer
              )
            end

            private

            def no_caption?
              @caption_node.nil? ||
                @caption_node.inner_text.strip == '[no-caption]'
            end
          end
        end
      end
    end
  end
end
