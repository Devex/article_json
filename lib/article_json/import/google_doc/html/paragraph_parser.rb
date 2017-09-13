module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class ParagraphParser
          # @param [Nokogiri::HTML::Node] node
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(node:, css_analyzer:)
            @node = node
            @css_analyzer = css_analyzer
          end

          # @return [Array[ArticleJSON::Elements::Text]]
          def content
            TextParser.extract(node: @node, css_analyzer: @css_analyzer)
          end

          # @return [ArticleJSON::Elements::Paragraph]
          def element
            ArticleJSON::Elements::Paragraph.new(content: content)
          end
        end
      end
    end
  end
end
