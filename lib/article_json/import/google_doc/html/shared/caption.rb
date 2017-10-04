module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        module Shared
          module Caption
            # Parse the caption node
            # @return [Array[ArticleJSON::Elements::Text]]
            def caption
              return empty_caption if @caption_node.nil?
              ArticleJSON::Import::GoogleDoc::HTML::TextParser.extract(
                node: @caption_node,
                css_analyzer: @css_analyzer
              )
            end

            private

            def empty_caption
              [ArticleJSON::Elements::Text.new(content: '&nbsp;')]
            end
          end
        end
      end
    end
  end
end
