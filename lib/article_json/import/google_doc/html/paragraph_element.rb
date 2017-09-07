module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class ParagraphElement
          # @param [Nokogiri::XML::Node] node
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(node:, css_analyzer:)
            @node = node
            @css_analyzer = css_analyzer
          end

          # @return [Array[ArticleJSON::Import::GoogleDoc::HTML::TextElement]]
          def content
            TextElement.extract(node: @node, css_analyzer: @css_analyzer)
          end

          # Hash representation of this paragraph element
          # @return [Hash]
          def to_h
            {
              type: :paragraph,
              content: content.map(&:to_h)
            }
          end
        end
      end
    end
  end
end
