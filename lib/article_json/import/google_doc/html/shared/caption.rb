module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        module Shared
          module Caption
            # Parse the caption node
            # @return [Array[ArticleJSON::Elements::Text]]
            def caption
              ArticleJSON::Import::GoogleDoc::HTML::TextParser.extract(
                node: @caption_node,
                css_analyzer: @css_analyzer
              )
            end
          end
        end
      end
    end
  end
end
