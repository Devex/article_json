module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class ListParser
          # @param [Nokogiri::HTML::Node] node
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(node:, css_analyzer:)
            @node = node
            @css_analyzer = css_analyzer
          end

          # Determine the list type, either ordered or unordered
          # @return [Symbol]
          def list_type
            case @node.name
              when 'ol' then :ordered
              when 'ul' then :unordered
            end
          end

          # Parse the list's sub nodes to get a set of paragraphs
          # @return [Array[ArticleJSON::Elements::Paragraph]]
          def content
            @node
              .children
              .select { |node| node.name == 'li' }
              .map do |node|
                ParagraphParser
                  .new(node: node, css_analyzer: @css_analyzer)
                  .element
              end
          end

          # @return [ArticleJSON::Elements::List]
          def element
            ArticleJSON::Elements::List.new(
              list_type: list_type,
              content: content
            )
          end
        end
      end
    end
  end
end
